"use strict";

module.exports = [
    {
        files: ["**/*.js"], // JS 파일에만 ESLint 적용
        languageOptions: {
            ecmaVersion: "latest", // 최신 ECMAScript 버전 사용
            sourceType: "script", // CommonJS 환경에서는 "script" 사용
            globals: {
                // Node.js 내장 글로벌 객체 허용
                process: "readonly",
                __dirname: "readonly",
                __filename: "readonly",
                module: "readonly",
                require: "readonly",
                exports: "readonly",
                console: "readonly", // ✅ console 추가
                setInterval: "readonly",  // ✅ setInterval 허용
                clearInterval: "readonly",
                setTimeout: "readonly",
                clearTimeout: "readonly",
                global: "readonly",
                Buffer: "readonly",
                URL: "readonly",
            },
        },
        linterOptions: {
            reportUnusedDisableDirectives: true,
        },

        plugins: {
            import: require("eslint-plugin-import") // ✅ import 및 require 검사용 플러그인
        },
        rules: {
            "no-undef": "error", // 정의되지 않은 변수 사용 금지
            "no-unused-vars": "off", // 사용하지 않는 변수 경고
            "no-console": "off", // console.log 허용
            "strict": ["error", "global"], // strict mode 강제 적용
            "import/no-unresolved": "error" // ✅ 존재하지 않는 파일 require/import 시 오류 발생
        },
    },
];
