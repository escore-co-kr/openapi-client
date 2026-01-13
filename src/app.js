"use strict";

const mysql = require("mysql2/promise");
const mods = require("./modules");
const SyncAPI = require("./modules/SyncAPI");
const fs = require("fs"), path = require("path");
const status = { interrupted: false };

async function mainLoop() {
    console.time("MAIN");

    const conn = await getConnection();
    try {
        const permisions = await SyncAPI.getPermissions();
        if (permisions == null) throw new Error("API Error");
        console.log(`permisions=${JSON.stringify(permisions)}`);
        const [r] = await conn.query(`SELECT 1;`); // DB Check
        if (r == null) throw new Error(`DB Error`);

        for (const mod of mods) {
            const syncMod = /** @type {SyncAPI} */ (mod);
            if (permisions.includes(syncMod.permision) == false) continue;
            await syncMod.sync(conn);
            await new Promise(n => setTimeout(n, 100));
        }
    } catch (e) {
        if (e instanceof Error != true) throw e;
        console.error(JSON.stringify({ message: e.message, stack: e.stack }));
    } finally {
        try { await conn.end(); } catch { }
    }

    console.timeEnd("MAIN");
    if (status.interrupted == true) return;
    setTimeout(mainLoop, 5000);
}

async function boot() {
    if (process.env["API_KEY"] == null) {
        console.error("Need API_KEY env");
        process.exit(1);
    }
    console.time("BOOT");

    console.log("CONNECT DB");
    const conn = await getConnection(true);
    try {
        const sql = await fs.promises.readFile(path.resolve(__dirname, "db.sql"), "utf-8");
        console.log("INIT/MIGRATE DB");
        await conn.query(sql);


        const [databases] = await conn.query(`SHOW DATABASES`);
        // @ts-ignore
        if (databases.some(d => d.Database == "data") == false) throw new Error("Error No Database");

        // @ts-ignore
        const [[, tables]] = await conn.query(`USE data; SHOW TABLES;`)
        if (tables.length == 0) throw new Error("Error No Tables");

        return true;
    } catch (e) {
        if (e instanceof Error != true) throw e;
        console.error(JSON.stringify({ message: e.message, stack: e.stack }));
    } finally {
        try { await conn.end(); } catch { }
        console.timeEnd("BOOT");
    }
}

process.on('SIGINT', () => gracefulShutdown('SIGINT'));
process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));

let ts = null;
/**
 * @param {string} signal
 */
async function gracefulShutdown(signal) {
    console.warn(`Graceful shutdown initiated [${signal}]`);
    status.interrupted = true;
}

(async () => {
    const success = await boot();
    if (success != true) return;
    mainLoop();
})();

/**
 * @returns {Promise<import("mysql2/promise").Connection>}
 */
async function getConnection(noDB = false) {
    while (true) {
        try {
            // @ts-ignore
            return await mysql.createConnection({
                host: process.env.MYSQL_HOST ?? "localhost",
                port: process.env.MYSQL_PORT ?? 3306,
                user: process.env.MYSQL_USER ?? "root",
                password: process.env.MYSQL_PASS ?? "password",
                ...(noDB == false ? { database: process.env.MYSQL_DATA ?? "data" } : {}),
                multipleStatements: true,
            });
        } catch {
            await new Promise(n => setTimeout(n, 100));
        }
    }
}

