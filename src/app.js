"use strict";

const mysql = require("mysql2/promise");
const mods = require("./modules");
const SyncAPI = require("./modules/SyncAPI");

async function main() {
    console.time("MAIN");

    const permisions = await SyncAPI.getPermissions();

    const conn = await getConnection();
    try {
        const [r] = await conn.query(`SELECT 1;`); // DB Check
        if (r == null) throw new Error(`DB Error`);

        for (const mod of mods) {
            const syncMod = /** @type {SyncAPI} */ (mod);
            if (permisions.includes(syncMod.permision) == false) continue;
            await syncMod.sync(conn);
        }

    } finally {
        try { await conn.end(); } catch { }
    }

    console.timeEnd("MAIN");
    setTimeout(main, 5000);
}

main();

/**
 * @returns {Promise<import("mysql2/promise").Connection}
 */
async function getConnection() {
    while (true) {
        try {
            // @ts-ignore
            return await mysql.createConnection({
                host: process.env.MYSQL_HOST ?? "localhost",
                port: process.env.MYSQL_PORT ?? 3306,
                user: process.env.MYSQL_USER ?? "root",
                password: process.env.MYSQL_PASS ?? "password",
                database: process.env.MYSQL_DATA ?? "database",
                multipleStatements: true,
            });
        } catch {
            await new Promise(n => setTimeout(n, 100));
        }
    }
}

