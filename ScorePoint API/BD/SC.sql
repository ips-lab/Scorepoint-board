# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.5-10.1.10-MariaDB)
# Database: sc
# Generation Time: 2017-02-24 20:21:40 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table game
# ------------------------------------------------------------

DROP TABLE IF EXISTS `game`;

CREATE TABLE `game` (
  `gameId` int(11) NOT NULL AUTO_INCREMENT,
  `pongTableId` int(11) NOT NULL,
  `tournamentId` int(11) DEFAULT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime DEFAULT NULL,
  `teamLocalId` int(11) NOT NULL,
  `teamVisitId` int(11) NOT NULL,
  `winnerTeamId` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `gameTypeId` int(11) unsigned NOT NULL,
  `points` int(11) NOT NULL,
  PRIMARY KEY (`gameId`),
  KEY `fk_game_pongTable1_idx` (`pongTableId`),
  KEY `fk_game_tournament1_idx` (`tournamentId`),
  KEY `fk_game_team1_idx` (`teamLocalId`),
  KEY `fk_game_team2_idx` (`teamVisitId`),
  KEY `fk_game_team3_idx` (`winnerTeamId`),
  KEY `fk_game_gameTypes1_idx` (`gameTypeId`),
  CONSTRAINT `fk_game_gameTypes1` FOREIGN KEY (`gameTypeId`) REFERENCES `gameTypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_pongTable1` FOREIGN KEY (`pongTableId`) REFERENCES `pongTable` (`pongTableId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_team1` FOREIGN KEY (`teamLocalId`) REFERENCES `team` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_team2` FOREIGN KEY (`teamVisitId`) REFERENCES `team` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_team3` FOREIGN KEY (`winnerTeamId`) REFERENCES `team` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_tournament1` FOREIGN KEY (`tournamentId`) REFERENCES `tournament` (`tournamentId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `game` WRITE;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;

INSERT INTO `game` (`gameId`, `pongTableId`, `tournamentId`, `startDate`, `endDate`, `teamLocalId`, `teamVisitId`, `winnerTeamId`, `active`, `gameTypeId`, `points`)
VALUES
	(10,1,NULL,'2017-01-09 00:00:00','2017-01-19 13:29:43',1,2,2,1,2,11),
	(11,1,NULL,'2017-01-17 00:00:00','2017-01-19 13:57:55',1,2,2,1,2,11),
	(12,1,NULL,'2017-01-17 04:00:00','2017-01-19 14:49:28',2,1,1,1,3,11),
	(13,1,NULL,'2017-01-17 00:00:00','2017-01-19 14:04:17',2,1,1,1,3,11),
	(14,1,NULL,'2017-01-16 00:00:00','2017-01-19 13:54:29',1,2,2,1,5,11),
	(15,1,NULL,'2017-01-16 00:00:00','2017-01-19 14:57:47',1,2,2,1,5,11),
	(16,1,NULL,'2017-01-16 00:00:00','2017-01-19 15:01:25',1,2,2,1,2,11),
	(17,1,NULL,'2017-01-16 00:00:00','2017-01-19 15:06:38',1,2,2,1,2,11),
	(18,1,NULL,'2017-01-16 00:00:00','2017-01-19 15:10:27',1,2,2,1,2,11),
	(19,1,NULL,'2017-01-16 00:00:00','2017-01-19 15:15:34',1,2,2,1,2,11),
	(20,1,NULL,'2017-01-16 00:00:00','2017-01-19 15:18:38',1,2,2,1,2,11),
	(21,1,NULL,'2017-01-16 00:00:00','2017-01-20 09:00:39',1,2,1,1,2,11),
	(22,1,NULL,'2017-01-16 00:00:00','2017-01-20 09:50:20',1,2,1,1,2,11),
	(23,1,NULL,'2017-01-16 00:00:00','2017-01-20 10:11:58',1,2,2,1,2,11),
	(24,1,NULL,'2017-01-16 00:00:00','2017-01-20 10:56:42',1,2,1,1,2,11),
	(25,1,NULL,'2017-01-16 00:00:00','2017-01-20 11:26:19',1,2,1,1,2,11),
	(26,1,NULL,'2017-01-16 00:00:00','2017-01-20 11:37:05',1,2,1,1,2,11),
	(27,1,NULL,'2017-01-16 00:00:00','2017-01-20 12:08:32',1,2,1,1,2,11),
	(28,1,NULL,'2017-01-16 00:00:00','2017-01-20 12:11:24',1,2,1,1,2,11),
	(29,1,NULL,'2017-01-16 00:00:00','2017-01-20 12:23:24',1,2,2,1,2,11),
	(31,1,NULL,'2017-01-16 00:00:00','0000-00-00 00:00:00',1,2,NULL,1,2,11),
	(32,1,NULL,'2017-01-16 00:00:00','0000-00-00 00:00:00',1,2,NULL,1,2,11),
	(33,1,NULL,'2017-01-16 00:00:00','0000-00-00 00:00:00',1,2,NULL,1,2,11),
	(34,1,NULL,'2017-01-16 00:00:00','2017-02-17 16:05:56',1,2,2,1,2,11),
	(35,1,NULL,'2017-01-16 00:00:00','2017-02-17 16:54:49',1,2,2,1,2,5),
	(36,1,NULL,'2017-01-16 00:00:00','2017-02-17 17:05:03',1,2,2,1,2,5),
	(37,1,NULL,'2017-01-16 00:00:00','2017-02-17 17:31:51',1,2,2,1,2,5),
	(38,1,NULL,'2017-01-16 00:00:00','2017-02-17 17:33:43',1,2,2,1,2,5),
	(39,1,NULL,'2017-01-16 00:00:00','2017-02-17 17:38:46',1,2,2,1,2,5),
	(40,1,NULL,'2017-01-16 00:00:00','2017-02-17 17:50:30',1,2,2,1,2,5),
	(41,1,NULL,'2017-01-16 00:00:00','0000-00-00 00:00:00',1,2,NULL,1,2,5),
	(42,1,NULL,'2017-01-16 00:00:00','2017-02-17 17:59:25',1,2,2,1,2,5),
	(43,1,NULL,'2017-01-16 00:00:00','2017-02-17 18:08:36',1,2,2,1,2,5),
	(44,1,NULL,'2017-01-16 00:00:00','2017-02-20 10:30:01',1,2,2,1,2,5),
	(45,1,NULL,'2017-01-16 00:00:00','0000-00-00 00:00:00',1,2,NULL,1,2,5),
	(46,1,NULL,'2017-01-16 00:00:00','2017-02-20 10:53:19',1,2,1,1,2,5),
	(47,1,NULL,'2017-01-16 00:00:00','2017-02-20 10:58:08',1,2,1,1,2,5),
	(48,1,NULL,'2017-01-16 00:00:00','2017-02-20 11:02:30',1,2,1,1,2,5),
	(49,1,NULL,'2017-01-16 00:00:00','2017-02-20 11:11:13',1,2,2,1,2,5),
	(50,1,NULL,'2017-01-16 00:00:00','2017-02-20 11:16:47',1,2,2,1,2,5),
	(51,1,NULL,'2017-01-16 00:00:00','2017-02-20 13:23:24',1,2,2,1,2,5),
	(52,1,NULL,'2017-01-16 00:00:00','2017-02-20 13:27:34',1,2,2,1,2,5),
	(53,1,NULL,'2017-01-16 00:00:00','2017-02-20 13:28:37',1,2,2,1,2,5),
	(54,1,NULL,'2017-01-16 00:00:00','0000-00-00 00:00:00',1,2,NULL,1,2,5),
	(55,1,NULL,'2017-01-16 00:00:00','2017-02-21 13:50:38',1,2,1,1,2,5),
	(56,1,NULL,'2017-01-16 00:00:00','0000-00-00 00:00:00',1,2,NULL,1,2,5),
	(57,1,NULL,'2017-01-16 00:00:00','2017-02-23 14:59:56',1,2,2,1,2,5),
	(58,1,NULL,'2017-01-16 00:00:00','2017-02-23 15:10:58',1,2,2,1,2,5),
	(59,1,NULL,'2017-01-16 00:00:00',NULL,1,2,2,1,2,5);

/*!40000 ALTER TABLE `game` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table gameRequest
# ------------------------------------------------------------

DROP TABLE IF EXISTS `gameRequest`;

CREATE TABLE `gameRequest` (
  `gameId` int(11) NOT NULL AUTO_INCREMENT,
  `pongTableId` int(11) NOT NULL,
  `tournamentId` int(11) DEFAULT NULL,
  `teamLocalId` int(11) NOT NULL,
  `teamVisitId` int(11) NOT NULL,
  `gameTypeId` int(11) unsigned NOT NULL,
  `points` int(11) NOT NULL,
  PRIMARY KEY (`gameId`),
  KEY `fk_game_pongTable1_idx` (`pongTableId`),
  KEY `fk_game_tournament1_idx` (`tournamentId`),
  KEY `fk_game_team1_idx` (`teamLocalId`),
  KEY `fk_game_team2_idx` (`teamVisitId`),
  KEY `fk_game_gameTypes1_idx` (`gameTypeId`),
  CONSTRAINT `gamerequest_ibfk_1` FOREIGN KEY (`gameTypeId`) REFERENCES `gameTypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gamerequest_ibfk_2` FOREIGN KEY (`pongTableId`) REFERENCES `pongTable` (`pongTableId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gamerequest_ibfk_3` FOREIGN KEY (`teamLocalId`) REFERENCES `team` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gamerequest_ibfk_4` FOREIGN KEY (`teamVisitId`) REFERENCES `team` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gamerequest_ibfk_6` FOREIGN KEY (`tournamentId`) REFERENCES `tournament` (`tournamentId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table gameset
# ------------------------------------------------------------

DROP TABLE IF EXISTS `gameset`;

CREATE TABLE `gameset` (
  `setId` int(11) NOT NULL AUTO_INCREMENT,
  `gameId` int(11) NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime DEFAULT NULL,
  `scoreLocal` smallint(6) DEFAULT '0',
  `scoreVisit` smallint(6) DEFAULT '0',
  `winnerTeamId` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT '1',
  PRIMARY KEY (`setId`,`gameId`),
  KEY `fk_set_game1_idx` (`gameId`),
  KEY `fk_set_team1_idx` (`winnerTeamId`),
  CONSTRAINT `fk_set_game1` FOREIGN KEY (`gameId`) REFERENCES `game` (`gameId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_set_team1` FOREIGN KEY (`winnerTeamId`) REFERENCES `team` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `gameset` WRITE;
/*!40000 ALTER TABLE `gameset` DISABLE KEYS */;

INSERT INTO `gameset` (`setId`, `gameId`, `startDate`, `endDate`, `scoreLocal`, `scoreVisit`, `winnerTeamId`, `active`)
VALUES
	(1,10,'2017-01-09 00:00:00','2017-01-19 12:41:57',4,2,2,1),
	(6,11,'2017-01-18 00:00:00','2017-01-19 13:30:21',0,0,2,1),
	(7,10,'2017-01-19 12:41:57','2017-01-19 13:02:39',2,2,1,1),
	(8,10,'2017-01-19 13:02:39','2017-01-19 13:29:43',6,8,2,1),
	(9,11,'2017-01-19 13:30:21','2017-01-19 13:57:55',0,2,2,1),
	(10,12,'2017-01-17 04:00:00','2017-01-19 14:48:02',0,0,1,1),
	(11,13,'2017-01-17 00:00:00','2017-01-19 14:03:34',0,0,1,1),
	(12,14,'2017-01-16 00:00:00','2017-01-19 13:53:12',2,11,2,1),
	(13,14,'2017-01-19 13:53:12','2017-01-19 13:53:46',0,0,2,1),
	(14,14,'2017-01-19 13:53:46','2017-01-19 13:54:01',0,0,2,1),
	(15,14,'2017-01-19 13:54:01','2017-01-19 13:54:21',0,0,2,1),
	(16,14,'2017-01-19 13:54:21','2017-01-19 13:54:29',0,0,2,1),
	(17,13,'2017-01-19 14:03:34','2017-01-19 14:03:55',0,0,1,1),
	(18,13,'2017-01-19 14:03:55','2017-01-19 14:04:17',0,0,1,1),
	(19,12,'2017-01-19 14:48:02','2017-01-19 14:48:44',0,0,1,1),
	(20,12,'2017-01-19 14:48:44','2017-01-19 14:49:28',0,0,1,1),
	(21,15,'2017-01-16 00:00:00','2017-01-19 14:56:48',0,0,2,1),
	(22,15,'2017-01-19 14:56:48','2017-01-19 14:56:56',0,0,2,1),
	(23,15,'2017-01-19 14:56:56','2017-01-19 14:57:14',0,0,2,1),
	(24,15,'2017-01-19 14:57:14','2017-01-19 14:57:30',0,0,2,1),
	(25,15,'2017-01-19 14:57:30','2017-01-19 14:57:47',0,0,2,1),
	(26,16,'2017-01-16 00:00:00','2017-01-19 15:01:16',0,0,2,1),
	(27,17,'2017-01-16 00:00:00','2017-01-19 15:06:09',0,0,2,1),
	(28,18,'2017-01-16 00:00:00','2017-01-19 15:09:59',0,0,2,1),
	(29,16,'2017-01-19 15:01:16','2017-01-19 15:01:25',0,0,2,1),
	(30,17,'2017-01-19 15:06:09','2017-01-19 15:06:38',0,0,2,1),
	(31,18,'2017-01-19 15:09:59','2017-01-19 15:10:27',0,0,2,1),
	(32,19,'2017-01-16 00:00:00','2017-01-19 15:13:36',0,0,2,1),
	(33,19,'2017-01-19 15:13:37','2017-01-19 15:15:34',0,0,2,1),
	(34,20,'2017-01-16 00:00:00','2017-01-19 15:18:21',0,0,2,1),
	(35,21,'2017-01-16 00:00:00','2017-01-20 08:49:53',14,5,1,1),
	(36,20,'2017-01-19 15:18:21','2017-01-19 15:18:38',0,0,2,1),
	(37,21,'2017-01-20 08:49:53','2017-01-20 09:00:39',20,5,1,1),
	(38,22,'2017-01-16 00:00:00','2017-01-20 09:48:04',19,3,1,1),
	(39,23,'2017-01-16 00:00:00','2017-01-20 10:11:44',35,2,2,1),
	(40,22,'2017-01-20 09:48:04','2017-01-20 09:50:20',33,0,1,1),
	(41,23,'2017-01-20 10:11:41',NULL,0,0,NULL,1),
	(42,23,'2017-01-20 10:11:43',NULL,0,0,NULL,1),
	(43,23,'2017-01-20 10:11:44','2017-01-20 10:11:58',6,0,2,1),
	(44,24,'2017-01-16 00:00:00','2017-01-20 10:46:08',11,7,1,1),
	(45,24,'2017-01-20 10:46:08','2017-01-20 10:56:42',11,4,1,1),
	(46,25,'2017-01-16 00:00:00','2017-01-20 11:26:12',14,7,1,1),
	(47,26,'2017-01-16 00:00:00','2017-01-20 11:36:51',11,4,1,1),
	(48,27,'2017-01-16 00:00:00','2017-01-20 11:55:05',4,11,2,1),
	(49,28,'2017-01-16 00:00:00','2017-01-20 12:09:50',0,11,2,1),
	(50,25,'2017-01-20 11:26:01',NULL,0,0,NULL,1),
	(51,25,'2017-01-20 11:26:01',NULL,0,0,NULL,1),
	(52,25,'2017-01-20 11:26:03',NULL,0,0,NULL,1),
	(53,25,'2017-01-20 11:26:03',NULL,0,0,NULL,1),
	(54,25,'2017-01-20 11:26:05',NULL,0,0,NULL,1),
	(55,25,'2017-01-20 11:26:05',NULL,0,0,NULL,1),
	(56,25,'2017-01-20 11:26:07',NULL,0,0,NULL,1),
	(57,25,'2017-01-20 11:26:08',NULL,0,0,NULL,1),
	(58,25,'2017-01-20 11:26:09',NULL,0,0,NULL,1),
	(59,25,'2017-01-20 11:26:10',NULL,0,0,NULL,1),
	(60,25,'2017-01-20 11:26:11',NULL,0,0,NULL,1),
	(61,25,'2017-01-20 11:26:12','2017-01-20 11:26:19',0,0,1,1),
	(62,26,'2017-01-20 11:36:51','2017-01-20 11:37:05',0,0,1,1),
	(63,27,'2017-01-20 11:55:05','2017-01-20 12:01:18',11,7,1,1),
	(64,27,'2017-01-20 12:01:18','2017-01-20 12:08:32',11,2,1,1),
	(65,28,'2017-01-20 12:09:50','2017-01-20 12:11:12',11,0,1,1),
	(66,28,'2017-01-20 12:11:12','2017-01-20 12:11:24',0,0,1,1),
	(67,29,'2017-01-16 00:00:00','2017-01-20 12:14:26',0,0,1,1),
	(69,31,'2017-01-16 00:00:00','0000-00-00 00:00:00',0,1,NULL,1),
	(70,29,'2017-01-20 12:14:12',NULL,0,0,NULL,1),
	(71,29,'2017-01-20 12:14:14',NULL,0,0,NULL,1),
	(72,29,'2017-01-20 12:14:16',NULL,0,0,NULL,1),
	(73,29,'2017-01-20 12:14:17',NULL,0,0,NULL,1),
	(74,29,'2017-01-20 12:14:23',NULL,0,0,NULL,1),
	(75,29,'2017-01-20 12:14:23',NULL,0,0,NULL,1),
	(76,29,'2017-01-20 12:14:24',NULL,0,0,NULL,1),
	(77,29,'2017-01-20 12:14:24',NULL,0,0,NULL,1),
	(78,29,'2017-01-20 12:14:24',NULL,0,0,NULL,1),
	(79,29,'2017-01-20 12:14:26','2017-01-20 12:23:07',2,5,2,1),
	(80,29,'2017-01-20 12:23:07','2017-01-20 12:23:24',0,0,2,1),
	(85,32,'2017-01-16 00:00:00','0000-00-00 00:00:00',1,0,NULL,1),
	(86,33,'2017-01-16 00:00:00','0000-00-00 00:00:00',0,0,NULL,1),
	(87,34,'2017-01-16 00:00:00','2017-01-20 16:45:30',3,11,2,1),
	(88,35,'2017-01-16 00:00:00','2017-02-17 16:40:28',1,5,2,1),
	(89,34,'2017-01-20 16:45:30','2017-02-17 16:05:56',5,11,2,1),
	(90,35,'2017-02-17 16:40:28','2017-02-17 16:54:49',2,5,2,1),
	(91,36,'2017-01-16 00:00:00','2017-02-17 17:01:16',2,5,2,1),
	(92,36,'2017-02-17 17:01:16','2017-02-17 17:05:03',0,5,2,1),
	(93,37,'2017-01-16 00:00:00','2017-02-17 17:29:44',0,5,2,1),
	(94,38,'2017-01-16 00:00:00','2017-02-17 17:33:01',0,5,2,1),
	(95,37,'2017-02-17 17:29:44','2017-02-17 17:30:31',5,0,1,1),
	(96,37,'2017-02-17 17:30:31','2017-02-17 17:31:51',0,5,2,1),
	(97,38,'2017-02-17 17:33:01','2017-02-17 17:33:43',0,5,2,1),
	(98,39,'2017-01-16 00:00:00','2017-02-17 17:38:00',0,5,2,1),
	(99,39,'2017-02-17 17:38:00','2017-02-17 17:38:46',0,5,2,1),
	(100,40,'2017-01-16 00:00:00','2017-02-17 17:49:43',1,5,2,1),
	(101,40,'2017-02-17 17:49:43','2017-02-17 17:50:30',0,5,2,1),
	(102,41,'2017-01-16 00:00:00','0000-00-00 00:00:00',0,0,NULL,1),
	(103,42,'2017-01-16 00:00:00','2017-02-17 17:58:47',0,5,2,1),
	(104,42,'2017-02-17 17:58:47','2017-02-17 17:59:25',0,5,2,1),
	(105,43,'2017-01-16 00:00:00','2017-02-17 18:07:52',0,5,2,1),
	(106,43,'2017-02-17 18:07:52','2017-02-17 18:08:36',0,5,2,1),
	(107,44,'2017-01-16 00:00:00','2017-02-20 10:29:21',0,5,2,1),
	(108,44,'2017-02-20 10:29:21','2017-02-20 10:30:01',0,5,2,1),
	(109,45,'2017-01-16 00:00:00','0000-00-00 00:00:00',0,0,NULL,1),
	(110,46,'2017-01-16 00:00:00','2017-02-20 10:52:38',5,2,1,1),
	(111,47,'2017-01-16 00:00:00','2017-02-20 10:57:27',5,0,1,1),
	(112,46,'2017-02-20 10:52:38','2017-02-20 10:53:19',5,0,1,1),
	(113,47,'2017-02-20 10:57:27','2017-02-20 10:58:08',5,0,1,1),
	(114,48,'2017-01-16 00:00:00','2017-02-20 11:01:24',5,0,1,1),
	(115,49,'2017-01-16 00:00:00','2017-02-20 11:05:44',0,5,2,1),
	(116,50,'2017-01-16 00:00:00','2017-02-20 11:15:58',0,5,2,1),
	(117,51,'2017-01-16 00:00:00','2017-02-20 13:13:32',0,5,2,1),
	(118,48,'2017-02-20 11:01:24','2017-02-20 11:02:30',5,0,1,1),
	(119,49,'2017-02-20 11:05:44','2017-02-20 11:11:13',0,5,2,1),
	(120,50,'2017-02-20 11:15:58','2017-02-20 11:16:47',0,5,2,1),
	(121,51,'2017-02-20 13:13:32','2017-02-20 13:21:14',5,1,1,1),
	(122,51,'2017-02-20 13:21:14','2017-02-20 13:23:24',0,5,2,1),
	(123,52,'2017-01-16 00:00:00','2017-02-20 13:27:10',0,5,2,1),
	(124,52,'2017-02-20 13:27:10','2017-02-20 13:27:34',0,0,2,1),
	(125,53,'2017-01-16 00:00:00','2017-02-20 13:28:21',0,0,2,1),
	(126,53,'2017-02-20 13:28:21','2017-02-20 13:28:37',0,0,2,1),
	(127,54,'2017-01-16 00:00:00','0000-00-00 00:00:00',0,5,2,1),
	(128,55,'2017-01-16 00:00:00','2017-02-21 13:23:39',5,0,1,1),
	(129,54,'2017-02-21 10:07:48','0000-00-00 00:00:00',0,0,NULL,1),
	(130,55,'2017-02-21 13:23:39','2017-02-21 13:50:38',5,0,1,1),
	(131,56,'2017-01-16 00:00:00','0000-00-00 00:00:00',-2,3,NULL,1),
	(132,57,'2017-01-16 00:00:00','2017-02-21 17:51:06',3,5,2,1),
	(133,57,'2017-02-21 17:51:06','2017-02-23 14:59:56',0,5,2,1),
	(134,58,'2017-01-16 00:00:00','2017-02-23 15:05:48',0,5,2,1),
	(135,58,'2017-02-23 15:05:48','2017-02-23 15:10:58',2,5,2,1),
	(136,59,'2017-01-16 00:00:00','2017-02-23 15:14:10',0,5,2,1),
	(137,59,'2017-02-23 15:14:10','2017-02-23 15:15:03',0,5,2,1);

/*!40000 ALTER TABLE `gameset` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table gameTypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `gameTypes`;

CREATE TABLE `gameTypes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `gameTypes` WRITE;
/*!40000 ALTER TABLE `gameTypes` DISABLE KEYS */;

INSERT INTO `gameTypes` (`id`, `name`)
VALUES
	(1,'1 out of 1'),
	(2,'2 out of 3'),
	(3,'3 out of 5'),
	(4,'4 out of 7'),
	(5,'5 out of 9');

/*!40000 ALTER TABLE `gameTypes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pongTable
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pongTable`;

CREATE TABLE `pongTable` (
  `pongTableId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pongTableId`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `pongTable` WRITE;
/*!40000 ALTER TABLE `pongTable` DISABLE KEYS */;

INSERT INTO `pongTable` (`pongTableId`, `name`, `active`)
VALUES
	(1,'primera mesa',1);

/*!40000 ALTER TABLE `pongTable` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ranks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ranks`;

CREATE TABLE `ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `ranks_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`rankId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table team
# ------------------------------------------------------------

DROP TABLE IF EXISTS `team`;

CREATE TABLE `team` (
  `teamId` int(11) NOT NULL AUTO_INCREMENT,
  `teamName` varchar(45) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL,
  PRIMARY KEY (`teamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;

INSERT INTO `team` (`teamId`, `teamName`, `active`, `created`)
VALUES
	(1,'cesarmtz',1,'2017-01-10 13:56:33'),
	(2,'palomac',1,'2017-01-10 13:57:09'),
	(3,'test',1,'2017-01-16 17:31:57');

/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tournament
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tournament`;

CREATE TABLE `tournament` (
  `tournamentId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime DEFAULT NULL,
  `pointValue` int(11) DEFAULT NULL,
  PRIMARY KEY (`tournamentId`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) DEFAULT '123456',
  `email` varchar(512) NOT NULL,
  `created` datetime NOT NULL,
  `imageUrl` varchar(45) DEFAULT NULL,
  `firstName` varchar(45) DEFAULT NULL,
  `lastName` varchar(45) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `rankId` int(11) DEFAULT NULL,
  PRIMARY KEY (`userId`),
  KEY `fk_user_ranks1_idx` (`rankId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;

INSERT INTO `user` (`userId`, `username`, `password`, `email`, `created`, `imageUrl`, `firstName`, `lastName`, `active`, `rankId`)
VALUES
	(1,'cesarmtz','123456','cesar@test.com','2017-01-10 13:56:33',NULL,'Cesar','Martinez',1,NULL),
	(2,'palomac','123456','paloma@test.com','2017-01-10 13:57:09',NULL,'paloma','chavez',1,NULL),
	(3,'test','123456','test@test.com','2017-01-16 17:31:57',NULL,'test','test',1,NULL);

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table userHasTeam
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userHasTeam`;

CREATE TABLE `userHasTeam` (
  `userId` int(11) NOT NULL,
  `teamId` int(11) NOT NULL,
  PRIMARY KEY (`userId`,`teamId`),
  KEY `fk_user_has_team_team1_idx` (`teamId`),
  KEY `fk_user_has_team_user_idx` (`userId`),
  CONSTRAINT `fk_user_has_team_team1` FOREIGN KEY (`teamId`) REFERENCES `team` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_team_user` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `userHasTeam` WRITE;
/*!40000 ALTER TABLE `userHasTeam` DISABLE KEYS */;

INSERT INTO `userHasTeam` (`userId`, `teamId`)
VALUES
	(1,1),
	(2,2),
	(3,3);

/*!40000 ALTER TABLE `userHasTeam` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
