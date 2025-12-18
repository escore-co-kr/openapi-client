"use strict";

const { API } = require("../lib/API");
const { Cursor } = require("../lib/Cursor");

class SyncAPI {
    #api;
    #table;
    #fullScan;
    #fields;
    #converter;
    #checkThrottle;
    /**
     * 
     * @param {string} api 
     * @param {string} table
     * @param {{ 
     *      fullScan?: boolean, 
     *      fields?: string[], 
     *      converter?: (value: any, key: string) => ({ 
     *          field: string, 
     *          value: string | number,
     *      }),
     *      checkThrottle?: number,
     *  }} [option]
     */
    constructor(api, table, { fullScan = false, fields, converter, checkThrottle = 0 } = {}) {
        this.#api = api; // table
        this.#table = table;
        this.#fullScan = fullScan;
        this.#fields = fields;
        this.#converter = converter ?? ((o, k) => ({ field: k, value: o[k] }));
        this.#checkThrottle = checkThrottle;
    }

    /**
     * 
     * @param {import("mysql2/promise").Connection} conn 
     */
    async sync(conn) {

        while (true) {
            const cursor = new Cursor(conn, this.#table);
            const { lastChecked, ...context } = await cursor.getCurContext() ?? {};
            if (this.#fullScan == true && Date.now() - lastChecked < this.#checkThrottle) return;
            const res = await API.get(`/${this.#api}${getQueryString(context)}`);
            if (res.status != 200) return; // 에러나면 무시

            
            const results = /** @type {{ code: string, data: { items: string[], nextToken?: string }}} */ (res.data);
            console.log(this.#table, JSON.stringify(context), results.code, results.data.items.length);
            const items = results.data.items;
            await conn.beginTransaction();
            if (items != null && items.length > 0) {
                const fields = this.#fields?.map(f => ({ field: f, target: f })) ?? detectFields(items[0]);
                for (const item of items) {
                    const paramMap = fields.map(k => this.#converter(item, k.field));
                    const params = fields.map(k => paramMap.find(p => p.field == k.field)?.value)
                        .map(v => typeof v == "object" && v != null ? JSON.stringify(v) : v);
                    const updateFields = fields.filter(k => k.field != "id");
                    // console.log(fields, item, params)
                    await conn.query(`
                        INSERT ${updateFields.length == 0 ? "IGNORE " : ""}INTO ${this.#table} (${fields.map(f => f.target).join(", ")})
                        VALUES (${fields.map(k => k.target.endsWith("_at") ? "FROM_UNIXTIME(? / 1000)" : "?").join(", ")})
                        ${updateFields.length > 0 ? `ON DUPLICATE KEY UPDATE ${updateFields.map(k => `${k.target}=VALUES(${k.target})`).join(", ")}` : ""}
                    `, params);
                }
            }

            context.nextToken = results.data.nextToken;
            await cursor.saveCurContext({ lastChecked: Date.now(), ...context });

            await conn.commit();
            if (items.length == 0 || this.#fullScan == true || context.nextToken == null) break;
        }
    }
}

module.exports = SyncAPI;

/**
 * 
 * @param {any} query 
 * @returns {string}
 */
function getQueryString(query) {
    if (query == null) return "";
    const params = Object.keys(query).map(k => `${encodeURIComponent(k)}=${encodeURIComponent(query[k])}`);
    if (params.length == 0) return "";
    return `?${params.join("&")}`;
}

/**
 * 
 * @param {*} o 
 * @returns {{ field: string, target: string }[]}
 */
function detectFields(o) {
    return Object.keys(o)
        .map(k => ({ field: k, target: k.replace(/([a-z0-9])([A-Z])/g, "$1_$2").replace(/-/g, "_").toLowerCase() }));
}
