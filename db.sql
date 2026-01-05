SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for key_store
-- ----------------------------
DROP TABLE IF EXISTS `key_store`;
CREATE TABLE `key_store` (
  `name` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `raw` JSON DEFAULT NULL,
  `memo` VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for sports
-- ----------------------------
DROP TABLE IF EXISTS `sports`;
CREATE TABLE `sports` (
  `id` VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for country
-- ----------------------------
DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `id` CHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_kr` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_url` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for league
-- ----------------------------
DROP TABLE IF EXISTS `league`;
CREATE TABLE `league` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for season
-- ----------------------------
DROP TABLE IF EXISTS `season`;
CREATE TABLE `season` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for team
-- ----------------------------
DROP TABLE IF EXISTS `team`;
CREATE TABLE `team` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for schedule
-- ----------------------------
DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `lineup`;
CREATE TABLE `lineup` (
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

DROP TABLE IF EXISTS `player_stat`;
CREATE TABLE `player_stat` (
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

DROP TABLE IF EXISTS `betting`;
CREATE TABLE `betting`
(
    `id` INT NOT NULL PRIMARY KEY,
    `schedule_id` INT NOT NULL,
    `region`      VARCHAR(10)                              NOT NULL,
    `type`        VARCHAR(10)                              NOT NULL,
    `show_ref`    TINYINT(1)                               NOT NULL,
    `choice`      JSON                                     NOT NULL,
    `values`    JSON                                     NOT NULL,
    `is_deleted`  TINYINT(1)                               NOT NULL,
    `created_at`  DATETIME(3) default CURRENT_TIMESTAMP(3) NOT NULL,
    `updated_at`  DATETIME(3) default CURRENT_TIMESTAMP(3) NOT NULL ON UPDATE CURRENT_TIMESTAMP(3),
    CONSTRAINT `fk_betting_schedule_id` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

