
DROP VIEW IF EXISTS `phishCounts`;
CREATE VIEW `phishCounts` AS
SELECT `phishes`.`id`, `phishes`.`nickname` AS phishname, 
	COUNT(`emails`.`smallHash`) AS total, 
	COUNT(DISTINCT(`emails`.`dtResponse`)) AS responses
	FROM `phishes` 
	LEFT JOIN `campaigns` ON `phishes`.`id` = `campaigns`.`idPhish`
	JOIN `emails` ON `campaigns`.`id` = `emails`.`idCampaign`
	GROUP BY `phishes`.`id`
	ORDER BY `phishes`.`id` DESC;

DROP VIEW IF EXISTS `campaignCounts`;
CREATE VIEW `campaignCounts` AS
SELECT `campaigns`.`id`, `campaigns`.`nickName` AS campName, 
	`phishes`.`nickname` AS phishname, `clients`.`name` AS clientname, 
	DATE_FORMAT(`campaigns`.`dtLaunch`, '%b %D, %Y') AS launchDate,
	COUNT(`emails`.`smallHash`) AS total, 
	COUNT(DISTINCT(`emails`.`dtResponse`)) AS responses
	FROM `campaigns`
	JOIN `phishes` ON `campaigns`.`idPhish` = `phishes`.`id`
	JOIN `clients` ON `campaigns`.`idClient` = `clients`.`id`
	LEFT JOIN `emails` ON `campaigns`.`id` = `emails`.`idCampaign`
	GROUP BY `campaigns`.`id`
	ORDER BY `campaigns`.`dtLaunch` DESC;

DROP VIEW IF EXISTS `clientCounts`;
CREATE VIEW `clientCounts` AS
SELECT `clients`.`id`, `clients`.`name`, COUNT(`emails`.`smallHash`) AS total, 
	COUNT(DISTINCT(`emails`.`dtResponse`)) AS responses,
	COUNT(DISTINCT(`campaigns`.`id`)) AS numCampaigns
	FROM `clients`
	LEFT JOIN `campaigns` ON `clients`.`id` = `campaigns`.`idClient`
	LEFT JOIN `emails` ON `campaigns`.`id` = `emails`.`idCampaign`
	GROUP BY `clients`.`id`;

DROP VIEW IF EXISTS `rawCampaignData`;
CREATE VIEW `rawCampaignData` AS
SELECT `emails`.*, REPLACE(`campaigns`.`nickName`, ',', '_') AS campName, 
	`campaigns`.`idPhish`, `campaigns`.`dtLaunch`, `campaigns`.`idClient`, 
	REPLACE(`phishes`.`nickname`, ',', '_') AS phishName, 
	REPLACE(`clients`.`name`, ',', '_') AS clientName
	FROM `emails`
	JOIN `campaigns` ON `emails`.`idCampaign` = `campaigns`.`id`
	JOIN `phishes` ON `campaigns`.`idPhish` = `phishes`.`id`
	JOIN `clients` ON `campaigns`.`idClient` = `clients`.`id`;

