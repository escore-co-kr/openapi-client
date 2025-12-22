"use strict";

const { default: axios } = require("axios");


const API = axios.create({
    timeout: 15000,
    baseURL: 'https://api.openapi.escore.co.kr/v1',
    headers: {
        "content-type": "application/json",
        "X-API-KEY": process.env.API_KEY,
    },
    validateStatus: () => true,
});

module.exports = {
    API,
};

