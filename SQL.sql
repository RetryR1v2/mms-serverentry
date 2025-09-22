CREATE TABLE `mms_einreise` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'armscii8_general_ci',
	`charidentifier` INT(11) NULL DEFAULT NULL,
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'armscii8_general_ci',
	`admin` VARCHAR(50) NULL DEFAULT NULL COLLATE 'armscii8_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='armscii8_general_ci'
ENGINE=InnoDB
;
