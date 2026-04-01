"use strict";

const SyncAPI = require("./SyncAPI");

module.exports = [
    new SyncAPI("sports", "sports", {
        fullScan: true,
        fields: ["id"],
        converter: (o) => ({ field: "id", value: o }),
        checkThrottle: 60000,
    }),
    new SyncAPI("countries", "country"),
    new SyncAPI("leagues", "league"),
    new SyncAPI("seasons", "season"),
    new SyncAPI("teams", "team"),
    new SyncAPI("schedules", "schedule"),
    new SyncAPI("players", "player"),
    new SyncAPI("teams/players", "team_player"),
    new SyncAPI("lineups", "lineup"),
    new SyncAPI("players/stats", "player_stat"),
    new SyncAPI("bettings", "betting"),
    new SyncAPI("stats/kbl/players", "stat_kbl_player"),
    new SyncAPI("stats/kbl/teams", "stat_kbl_team"),
    new SyncAPI("pandascore/assets", "pandascore_assets"),
    new SyncAPI("pandascore/players", "pandascore_player"),
    new SyncAPI("schedules/pandascore/games", "pandascore_schedule_games"),
    new SyncAPI("schedules/pandascore/games/events", "pandascore_schedule_games_event"),
    new SyncAPI("pandascore/opponents", "pandascore_schedule_opponents"),
];

