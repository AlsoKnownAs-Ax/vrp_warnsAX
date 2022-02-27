ALTER TABLE `vrp_users` ADD COLUMN `warns` int(11) NOT NULL DEFAULT 0,
ALTER TABLE `vrp_users` ADD COLUMN `bannedTemp` bigint(20) NOT NULL DEFAULT 0,
ALTER TABLE `vrp_users` ADD COLUMN `bannedReason` varchar(50) DEFAULT NULL,
ALTER TABLE `vrp_users` ADD COLUMN `bannedBy` varchar(50) DEFAULT NULL,
ALTER TABLE `vrp_users` ADD COLUMN `bannedTemp` bigint(20) NOT NULL DEFAULT 0,
ALTER TABLE `vrp_users` ADD COLUMN `BanTempZile` int(11) NOT NULL DEFAULT 0,
ALTER TABLE `vrp_users` ADD COLUMN `BanTempData` varchar(50) DEFAULT NULL
ALTER TABLE `vrp_users` ADD COLUMN `BanTempExpire` varchar(50) DEFAULT NULL,