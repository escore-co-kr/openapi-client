SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS data
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE data;

-- ----------------------------
-- Table structure for key_store
-- ----------------------------
CREATE TABLE IF NOT EXISTS `key_store` (
  `name` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `raw` JSON DEFAULT NULL,
  `memo` VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`name`)
);

-- ----------------------------
-- Table structure for sports
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sports` (
  `id` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`)
);

-- ----------------------------
-- Table structure for country
-- ----------------------------
CREATE TABLE IF NOT EXISTS `country` (
  `id` CHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_kr` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_url` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_updated_at` (`updated_at`)
);

-- ----------------------------
-- Table structure for league
-- ----------------------------
CREATE TABLE IF NOT EXISTS `league` (
  `id` INT NOT NULL,
  `sports` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_urls` JSON DEFAULT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_league_sports` (`sports`),
  KEY `idx_updated_at_id` (`updated_at`,`id`),
  CONSTRAINT `fk_league_sports` FOREIGN KEY (`sports`) REFERENCES `sports` (`id`)
);

-- ----------------------------
-- Table structure for season
-- ----------------------------
CREATE TABLE IF NOT EXISTS `season` (
  `id` INT NOT NULL,
  `league_id` INT DEFAULT NULL,
  `sports` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT '0',
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_season_country` (`country`),
  KEY `fk_season_league` (`league_id`),
  KEY `fk_season_sports` (`sports`),
  KEY `idx_updated_at` (`updated_at`),
  CONSTRAINT `fk_season_country` FOREIGN KEY (`country`) REFERENCES `country` (`id`),
  CONSTRAINT `fk_season_league` FOREIGN KEY (`league_id`) REFERENCES `league` (`id`),
  CONSTRAINT `fk_season_sports` FOREIGN KEY (`sports`) REFERENCES `sports` (`id`),
  CONSTRAINT `check_sports_no_spaces` CHECK ((`sports` = trim(`sports`)))
);

-- ----------------------------
-- Table structure for team
-- ----------------------------
CREATE TABLE IF NOT EXISTS `team` (
  `id` INT NOT NULL,
  `sports` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_urls` JSON DEFAULT NULL,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_updated_at_id` (`updated_at`,`id`)
);

-- ----------------------------
-- Table structure for schedule
-- ----------------------------
CREATE TABLE IF NOT EXISTS `schedule` (
  `id` INT NOT NULL,
  `sports` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `league_id` INT NOT NULL,
  `season_id` INT NOT NULL,
  `home_id` int DEFAULT NULL,
  `away_id` int DEFAULT NULL,
  `start_at` DATETIME(3) NOT NULL,
  `start_date` VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hidden` TINYINT(1) NOT NULL DEFAULT '0',
  `status` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ended_status` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `home_score` int DEFAULT NULL,
  `away_score` int DEFAULT NULL,
  `scores` JSON DEFAULT NULL,
  `clock` JSON DEFAULT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_schedule_away_id` (`away_id`),
  KEY `fk_schedule_home_id` (`home_id`),
  KEY `fk_schedule_league_id` (`league_id`),
  KEY `fk_schedule_season_id` (`season_id`),
  KEY `fk_schedule_sports` (`sports`),
  KEY `idx_updated_at_id` (`updated_at`,`id`),
  CONSTRAINT `fk_schedule_away_id` FOREIGN KEY (`away_id`) REFERENCES `team` (`id`),
  CONSTRAINT `fk_schedule_home_id` FOREIGN KEY (`home_id`) REFERENCES `team` (`id`),
  CONSTRAINT `fk_schedule_league_id` FOREIGN KEY (`league_id`) REFERENCES `league` (`id`),
  CONSTRAINT `fk_schedule_season_id` FOREIGN KEY (`season_id`) REFERENCES `season` (`id`),
  CONSTRAINT `fk_schedule_sports` FOREIGN KEY (`sports`) REFERENCES `sports` (`id`)
);

CREATE TABLE IF NOT EXISTS `player` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile` JSON DEFAULT NULL,
  `country` VARCHAR(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_country_player` (`country`),
  KEY `idx_updated_at` (`updated_at`,`id`),
  CONSTRAINT `fk_country_player` FOREIGN KEY (`country`) REFERENCES `country` (`id`)
);

CREATE TABLE IF NOT EXISTS `team_player` (
  `id`         INT NOT NULL PRIMARY KEY,
  `team_id`    INT NOT NULL,
  `player_id`  INT NOT NULL,
  `hidden`     TINYINT(1)  DEFAULT 0 NOT NULL,
  `is_deleted` TINYINT(1)  DEFAULT 0 NOT NULL,
  `created_at` DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
  `updated_at` DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) NOT NULL ON UPDATE CURRENT_TIMESTAMP(3),
    CONSTRAINT `uniq_team_id_player_id` UNIQUE (`team_id`, `player_id`),
    CONSTRAINT `fk_team_player_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`),
    CONSTRAINT `fk_team_player_team_id` FOREIGN KEY (`team_id`) REFERENCES `team` (`id`)
);


CREATE TABLE IF NOT EXISTS `lineup` (
  `id` INT NOT NULL,
  `schedule_id` INT NOT NULL,
  `team_id` INT NOT NULL,
  `player_id` int DEFAULT NULL,
  `is_starting` TINYINT(1) DEFAULT NULL,
  `type` VARCHAR(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta` JSON DEFAULT NULL,
  `is_deleted` TINYINT(1) DEFAULT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_key` (`schedule_id`,`team_id`,`player_id`),
  KEY `fk_lineup_player_id` (`player_id`),
  KEY `fk_lineup_team_id` (`team_id`),
  KEY `idx_updated_at` (`updated_at`,`id`),
  CONSTRAINT `fk_lineup_schedule_id` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `player_stat` (
  `id` INT NOT NULL,
  `schedule_id` INT NOT NULL,
  `player_id` INT NOT NULL,
  `raw` JSON DEFAULT NULL,
  `is_deleted` TINYINT(1) DEFAULT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_key` (`schedule_id`,`player_id`),
  KEY `fk_player_stat_player_id` (`player_id`),
  KEY `idx_updated_at` (`updated_at`,`id`),
  CONSTRAINT `fk_player_stat_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`),
  CONSTRAINT `fk_player_stat_schedule_id` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `betting`
(
    `id` INT NOT NULL PRIMARY KEY,
    `schedule_id` INT NOT NULL,
    `region`      VARCHAR(100)                              NOT NULL,
    `type`        VARCHAR(100)                              NOT NULL,
    `show_ref`    TINYINT(1)                               NOT NULL,
    `choice`      JSON                                     NOT NULL,
    `values`    JSON                                     NOT NULL,
    `is_deleted`  TINYINT(1)                               NOT NULL,
    `created_at`  DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    `updated_at`  DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) NOT NULL ON UPDATE CURRENT_TIMESTAMP(3),
    CONSTRAINT `fk_betting_schedule_id` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

