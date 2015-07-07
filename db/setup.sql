
CREATE DATABASE `raptorData`;
CREATE DATABASE `raptorResponse`;
CREATE DATABASE `raptorAdmin`;
CREATE USER 'raptorResponse'@'localhost' IDENTIFIED BY 'raptor';
CREATE USER 'raptorAdmin'@'localhost' IDENTIFIED BY 'raptor';
GRANT SELECT (`name`,`param_list`,`db`,`type`) ON `mysql`.`proc` TO 'raptorResponse'@'localhost';
GRANT EXECUTE ON `raptorResponse`.* TO 'raptorResponse'@'localhost';
GRANT SELECT (`name`,`param_list`,`db`,`type`) ON `mysql`.`proc` TO 'raptorAdmin'@'localhost';
GRANT EXECUTE ON `raptorAdmin`.* TO 'raptorAdmin'@'localhost';

