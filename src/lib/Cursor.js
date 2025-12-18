"use strict";

const dayjs = require("dayjs");

class Cursor {
    #conn;
    #curKey;

    /**
     * 
     * @param {*} conn 
     * @param {string} curKey 
     */
    constructor(conn, curKey) {
        this.#conn = conn;
        this.#curKey = curKey;
    }

    get curKey() {
        return this.#curKey;
    }

    /**
     * 
     * @returns {Promise<null | { cur: number } & any>}
     */
    async getCurContext() {
        // if (isDebug) return null;
        const conn = this.#conn;
        const CUR_NAME = this.curKey;
        const [[kv]] = await conn.query(`SELECT raw FROM key_store WHERE name = ?`, [CUR_NAME]);
        if (kv == null) return null;
        return kv.raw;
    }

    /**
     * 
     * @param {{ cur: number } & any} context 
     */
    async saveCurContext(context) {
        // if (isDebug) return;
        const conn = this.#conn;
        const CUR_NAME = this.curKey;
        const memo = dayjs(context.cur).format("YYYY/MM/DD HH:mm:ss");
        await conn.query(`INSERT INTO key_store (name, raw, memo) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE raw=VALUES(raw), memo=VALUES(memo)`, [CUR_NAME, JSON.stringify(context), memo]);
    }
}


module.exports = {
    Cursor,
};

