DELIMITER $$

DROP FUNCTION IF EXISTS `checkSession` $$
CREATE FUNCTION `checkSession`(sessionId VARCHAR(32)) RETURNS INT
MODIFIES SQL DATA
BEGIN
	DECLARE lastAccess, expiration DATETIME DEFAULT NULL;
	SELECT `dtLast` INTO lastAccess FROM `sessions` 
		WHERE `id` = sessionId LIMIT 1;
	IF lastAccess IS NULL THEN
		RETURN 0;
	END IF;
	SET expiration = lastAccess + INTERVAL 10 MINUTE;
	IF expiration < NOW() THEN
		DELETE FROM `sessions` WHERE `id` = sessionId;
		RETURN 0;
	END IF;
	UPDATE `sessions` SET `dtLast` = NOW() WHERE `id` = sessionId;
	RETURN 1;
END $$

DROP FUNCTION IF EXISTS `responseHash` $$
CREATE FUNCTION `responseHash`() RETURNS VARCHAR(8)
READS SQL DATA
BEGIN
	DECLARE newhash VARCHAR(8) DEFAULT NULL;
	DECLARE workhash VARCHAR(32) DEFAULT NULL;
	DECLARE already INT DEFAULT 0;
	WHILE newhash IS NULL DO
		SET workhash = MD5(CONCAT(NOW(),CONNECTION_ID(),RAND()));
		SET newhash = SUBSTR(workhash, FLOOR(RAND() * 23) + 1, 8);
		SELECT COUNT(`id`) INTO already FROM `emails`
			WHERE `smallHash` = newhash;
		IF already > 0 THEN
			SET newhash = NULL;
		END IF;
	END WHILE;
	RETURN newhash;
END $$

DROP FUNCTION IF EXISTS `sendEmails` $$
CREATE FUNCTION `sendEmails`(filename VARCHAR(1024), clientid INT,
				campid INT, fromAddress VARCHAR(128), 
				emailBody TEXT, srvnport VARCHAR(128)) RETURNS VARCHAR(32)
MODIFIES SQL DATA
BEGIN
	DECLARE fileContent, customBody TEXT DEFAULT '';
	DECLARE addr, addressee, idHash, err VARCHAR(128) DEFAULT '';
	DECLARE position, contentLength, errno INT DEFAULT 1;
	SET fileContent = LOAD_FILE(filename);
	SET contentLength = LENGTH(fileContent);
	WHILE contentLength > position DO
		SET addr = SUBSTRING_INDEX(SUBSTR(fileContent, position), ',', 1);
		SET position = position + LENGTH(addr) + 1;
		SET addressee = SUBSTRING_INDEX(SUBSTR(fileContent, position), '\n', 1);
		SET position = position + LENGTH(addressee) + 1;
		SET addr = TRIM(addr);
		SET addressee = TRIM(addressee);
		IF LENGTH(addr) > 3 THEN
			SET customBody = REPLACE(emailBody, '*NAME*', addressee);
			SET customBody = REPLACE(customBody, '*EMAIL*', addr);
			SET customBody = REPLACE(customBody, '*DATE*', 
				DATE_FORMAT(UTC_TIMESTAMP(),'%a, %e %b %Y %T UTC'));
			SET idHash = responseHash();
			SET customBody = REPLACE(customBody, '*HASH*', idHash);
			SET customBody = REPLACE(customBody, '*MESSAGEID*', 
				CONCAT(UTC_TIMESTAMP(), '.', idHash));
			SET errno = emailer(fromAddress, addr, srvnport, customBody);
			IF errno = 0 THEN
				INSERT INTO `emails` (`idCampaign`,`emailHash`,`smallHash`)
					VALUES (campid, MD5(addr), idHash);
			ELSE
				SET err = CONCAT(err, ' ', errno);
			END IF;
		END IF;
	END WHILE;
	RETURN err;
END $$

DROP FUNCTION IF EXISTS `getFromAddr` $$
CREATE FUNCTION `getFromAddr`(pcontent TEXT) RETURNS TEXT
NO SQL
BEGIN
	DECLARE pfrom TEXT DEFAULT '';
	SET pfrom = SUBSTRING(pcontent, LOCATE('\nFrom:', pcontent) + 7);
	SET pfrom = SUBSTRING(pfrom, 1, LOCATE('\r\n', pfrom) - 1);
	IF LOCATE('<', pfrom) > 0 AND LOCATE('>', pfrom) > 0 THEN
		SET pfrom = SUBSTRING(pfrom, LOCATE('<', pfrom) + 1);
		SET pfrom = SUBSTRING(pfrom, 1, LOCATE('>', pfrom) - 1);
	END IF;
	SET pfrom = TRIM(pfrom);
	RETURN pfrom;
END $$

DROP FUNCTION IF EXISTS `getResponseRate` $$
CREATE FUNCTION `getResponseRate`(total INT, responses INT) RETURNS VARCHAR(32)
NO SQL
BEGIN
	DECLARE rate VARCHAR(32);
	IF total < 1 THEN
		SET rate = 'N/A';
	ELSE
		SET rate = CONCAT(FORMAT(responses * 100 / total, 1), ' %');
	END IF;
	RETURN rate;
END $$

DELIMITER ;

