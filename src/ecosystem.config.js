"use strict";

module.exports = {
    apps: [
        {
            script: 'app.js',
            automation: false,
            instances: 1,
            env: {
                NODE_ENV: "production",
            },
            max_memory_restart: process.env.NODE_MAX_MEMORY || "512M",
            kill_timeout: 5000,
        },
    ],
};
