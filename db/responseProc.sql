DELIMITER $$

DROP PROCEDURE IF EXISTS `landing` $$
CREATE PROCEDURE `landing`()
BEGIN
	DECLARE emailId, campaignId, phishId INT DEFAULT 0;
	SELECT `id` INTO emailId FROM `raptorData`.`emails`
		WHERE `smallHash` = SUBSTRING(@mvp_uri, -8) LIMIT 1;
	IF emailId > 0 THEN
		UPDATE `raptorData`.`emails` 
			SET `dtResponse` = UTC_TIMESTAMP(),
				`ipResponse` = @mvp_remoteip
			WHERE `id` = emailId;
		SELECT `idCampaign` INTO campaignId FROM `raptorData`.`emails`
			WHERE `id` = emailId LIMIT 1;
		-- maybe alert or update a dashboard?
		SELECT `idPhish` INTO phishId FROM `raptorData`.`campaigns`
			WHERE `id` = campaignId LIMIT 1;
		IF phishId > 0 THEN
			SELECT * FROM `raptorData`.`phishes` WHERE `id` = phishId;
			SET @mvp_template = 'response';
		END IF;
	END IF;
END $$

DELIMITER ;

