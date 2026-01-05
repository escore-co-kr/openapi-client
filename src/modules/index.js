"use strict";

const SyncAPI = require("./SyncAPI");

module.exports = [
    new SyncAPI("sports", "sports", {
        fullScan: true,
        fields: ["id"],
        converter: (o) => ({ field: "id", value: o }),
        checkThrottle: 60000,
    }),
    new SyncAPI("countries", "country", { fullScan: true }),
    new SyncAPI("leagues", "league"),
    new SyncAPI("seasons", "season"),
    new SyncAPI("teams", "team"),
    new SyncAPI("schedules", "schedule"),
    new SyncAPI("players", "player"),
    new SyncAPI("lineups", "lineup"),
    new SyncAPI("players/stats", "player_stat"),
    new SyncAPI("bettings", "betting"),
];

