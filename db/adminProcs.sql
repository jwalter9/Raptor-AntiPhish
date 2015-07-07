DELIMITER $$

DROP PROCEDURE IF EXISTS `admin` $$
CREATE PROCEDURE `admin`()
BEGIN
	IF `raptorData`.checkSession(@mvp_session) != 1 THEN
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `login` $$
CREATE PROCEDURE `login`(IN uname VARCHAR(128), IN pass VARCHAR(128), 
			OUT err VARCHAR(32))
BEGIN
	DECLARE acctId INT DEFAULT 0;
	SELECT `id` INTO acctId FROM `raptorData`.`admin`
		WHERE `username` = uname AND `password` = MD5(pass)
		LIMIT 1;
	IF acctId > 0 THEN
		DELETE FROM `raptorData`.`sessions` WHERE `id` = @mvp_session;
		INSERT INTO `raptorData`.`sessions` (`id`,`dtLast`)
			VALUES (@mvp_session, UTC_TIMESTAMP());
		SET @mvp_template = 'admin';
	ELSE
		IF uname IS NOT NULL OR pass IS NOT NULL THEN
			SET err = 'Invalid credentials';
		END IF;
	END IF;
END $$

DROP PROCEDURE IF EXISTS `logout` $$
CREATE PROCEDURE `logout`()
BEGIN
	DELETE FROM `raptorData`.`sessions` WHERE `id` = @mvp_session;
	SET @mvp_template = 'login';
END $$

DROP PROCEDURE IF EXISTS `clients` $$
CREATE PROCEDURE `clients`()
BEGIN
	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		SELECT *, `raptorData`.getResponseRate(total, responses) AS responseRate
			FROM `raptorData`.`clientCounts`;
	ELSE
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `editClient` $$
CREATE PROCEDURE `editClient`(IN cid INT, IN cname VARCHAR(128), OUT err VARCHAR(32))
BEGIN
	DECLARE ferr, nid INT DEFAULT 0;
	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		IF cid IS NULL OR cid = 0 THEN
			INSERT INTO `raptorData`.`clients` (`name`)
				VALUES (REPLACE(cname,'\'','&rsquot;'));
			-- Problem w/ 's in the editor...
			SET nid = LAST_INSERT_ID();
		ELSE
			UPDATE `raptorData`.`clients` SET `name` = cname
				WHERE `id` = cid;
			SET nid = cid;
		END IF;
		SELECT *, `raptorData`.getResponseRate(total, responses) AS responseRate
			FROM `raptorData`.`clientCounts`;
		SET @mvp_template = 'clients';
	ELSE
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `campaigns` $$
CREATE PROCEDURE `campaigns`()
BEGIN
	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		SELECT *, `raptorData`.getResponseRate(total, responses) AS responseRate
			FROM `raptorData`.`campaignCounts`;
		SELECT * FROM `raptorData`.`clients`;
		SELECT * FROM `raptorData`.`phishes`;
	ELSE
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `launchCampaign` $$
CREATE PROCEDURE `launchCampaign`(IN clientid INT, IN phishid INT, IN emaillist VARCHAR(1024),
				INOUT nickname VARCHAR(128), IN srvnport VARCHAR(128),
				OUT err VARCHAR(128))
BEGIN
	DECLARE fromAddress VARCHAR(128) DEFAULT NULL;
	DECLARE emailBody TEXT DEFAULT NULL;
	DECLARE campid INT DEFAULT 0;

	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		SELECT `fromAddr`,`emailContent` INTO fromAddress, emailBody
			FROM `raptorData`.`phishes` WHERE `id` = phishid LIMIT 1;
		IF fromAddress IS NOT NULL AND emailBody IS NOT NULL THEN
			INSERT INTO `raptorData`.`campaigns` 
				(`idClient`,`idPhish`,`dtLaunch`,`nickName`)
				VALUES (clientid, phishid, NOW(), nickname);
			SET campid = LAST_INSERT_ID();
			SET err = `raptorData`.sendEmails(emaillist, clientid, 
					campid, fromAddress, emailBody, srvnport);
			IF err <> '' THEN
				SET err = CONCAT('Email error codes: ',err);
			END IF;
		ELSE
			SET err = 'Failed to find selected Phish';
		END IF;
	ELSE
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `phishes` $$
CREATE PROCEDURE `phishes`()
BEGIN
	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		SELECT *, `raptorData`.getResponseRate(total, responses) AS responseRate
			FROM `raptorData`.`phishCounts`;
	ELSE
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `editPhish` $$
CREATE PROCEDURE `editPhish`(INOUT pid INT, INOUT pnick VARCHAR(128), 
				INOUT email TEXT, INOUT presponse VARCHAR(128), 
				OUT err VARCHAR(128))
BEGIN
	DECLARE pfrom, pcontent TEXT DEFAULT '';
	SET pcontent = LOAD_FILE(email);
	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		SET pcontent = REPLACE(pcontent, '\n', '\r\n');
		SET pcontent = REPLACE(pcontent, '\r\r\n', '\r\n');
		SET pfrom = `raptorData`.getFromAddr(pcontent);
		IF pfrom IS NULL OR pfrom = '' THEN
			SET err = 'Phishing Email must contain "From:" definition';
		ELSE
			IF pid IS NULL OR pid = 0 THEN
				INSERT INTO `raptorData`.`phishes`
					(`nickname`,`fromAddr`,`emailContent`,`response`)
					VALUES (pnick, pfrom, pcontent, presponse);
				SET pid = LAST_INSERT_ID();
			ELSE
				UPDATE `raptorData`.`phishes` SET `nickname` = pnick,
					`fromAddr` = pfrom, `emailContent` = pcontent,
					`response` = presponse WHERE `id` = pid;
			END IF;
		END IF;
		SET @mvp_template = 'phishes';
		CALL `phishes`();
	ELSE
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `testPhish` $$
CREATE PROCEDURE `testPhish`(INOUT toAddr VARCHAR(128), IN email VARCHAR(1024), 
				INOUT srvnport VARCHAR(128), OUT err VARCHAR(128))
BEGIN
	DECLARE pfrom, pcontent TEXT DEFAULT '';
	DECLARE errno INT DEFAULT 0;
	IF email IS NOT NULL AND email != '' THEN
		SET pcontent = LOAD_FILE(email);
	END IF;
	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		IF pcontent IS NOT NULL AND pcontent != '' THEN
			SET pcontent = REPLACE(pcontent, '\n', '\r\n');
			SET pcontent = REPLACE(pcontent, '\r\r\n', '\r\n');
			SET pfrom = `raptorData`.getFromAddr(pcontent);
			IF pfrom IS NULL OR pfrom = '' THEN
				SET err = 'Phishing Email must contain "From:" definition';
			ELSE
				SET pcontent = REPLACE(pcontent, '*EMAIL*', toAddr);
				SET pcontent = REPLACE(pcontent, '*DATE*', 
					DATE_FORMAT(UTC_TIMESTAMP(),'%a, %e %b %Y %T UTC'));
				SET pcontent = REPLACE(pcontent, '*MESSAGEID*', 
					CONCAT(UTC_TIMESTAMP(), '.', 'test'));
				SET errno = emailer(pfrom, toAddr, srvnport, pcontent);
				IF errno = 0 THEN
					SET err = 'Email sent';
				ELSE
					SET err = CONCAT('Send failed: ',errno);
				END IF;
			END IF;
		END IF;
	ELSE
		SET err = 'Please log in to continue';
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `csvData` $$
CREATE PROCEDURE `csvData`(IN clid INT, IN phid INT, IN cmid INT)
BEGIN
	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		SET @mvp_content_type = 'text/csv';
		SET @mvp_layout = '';
		SELECT * FROM `raptorData`.`rawCampaignData`
		WHERE `idClient` = clid
			OR `idPhish` = phid
			OR `idCampaign` = cmid;
	ELSE
		SET @mvp_template = 'login';
	END IF;
END $$

DROP PROCEDURE IF EXISTS `emailHistory` $$
CREATE PROCEDURE `emailHistory`(INOUT addr VARCHAR(128), IN cid INT, OUT clientName VARCHAR(128))
BEGIN
	DECLARE emhash VARCHAR(32) DEFAULT NULL;
	IF addr IS NOT NULL AND addr <> '' THEN
		SET emhash = MD5(addr);
	END IF;
	IF `raptorData`.checkSession(@mvp_session) = 1 THEN
		SELECT *, DATE_FORMAT(`emails`.`dtResponse`, '%b %D, %Y') AS respDate,
			`campaigns`.`nickName`, 
			DATE_FORMAT(`campaigns`.`dtLaunch`, '%b %D, %Y') AS launchDate
		FROM `raptorData`.`emails`
		JOIN `raptorData`.`campaigns` ON `emails`.`idCampaign` = `campaigns`.`id`
		WHERE `emailHash` = emhash AND `idClient` = cid;
		SELECT * FROM `raptorData`.`clients` ORDER BY `id`;
		SELECT `name` INTO clientName FROM `raptorData`.`clients` WHERE `id` = cid LIMIT 1;
	ELSE
		SET @mvp_template = 'login';
	END IF;
END $$

DELIMITER ;

