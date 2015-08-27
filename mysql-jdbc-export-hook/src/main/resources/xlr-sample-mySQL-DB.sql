# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.6.26)
# Database: xlrelease
# Generation Time: 2015-08-27 21:00:57 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table XL_FLAG
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XL_FLAG`;

CREATE TABLE `XL_FLAG` (
  `flagId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(25) DEFAULT NULL COMMENT 'Current Values: OK, ATTENTION_NEEDED, AT_RISK , Flags indicate that an item needs attention, [''OK'' or ''ATTENTION_NEEDED'' or ''AT_RISK'']:',
  PRIMARY KEY (`flagId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `XL_FLAG` WRITE;
/*!40000 ALTER TABLE `XL_FLAG` DISABLE KEYS */;

INSERT INTO `XL_FLAG` (`flagId`, `status`)
VALUES
	(1,'OK'),
	(2,'ATTENTION_NEEDED'),
	(3,'AT_RISK');

/*!40000 ALTER TABLE `XL_FLAG` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table XLR_ATTACHEMENT
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_ATTACHEMENT`;

CREATE TABLE `XLR_ATTACHEMENT` (
  `attachmentId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `attachment` blob NOT NULL COMMENT 'Attached object',
  `objectId` int(11) NOT NULL COMMENT '(ex/ taskId, releaseId)',
  `objectType` int(11) NOT NULL COMMENT '(ex/ ''TASK'', ''RELEASE'')',
  PRIMARY KEY (`attachmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_AUDIT_TRAIL
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_AUDIT_TRAIL`;

CREATE TABLE `XLR_AUDIT_TRAIL` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `objectId` int(11) NOT NULL,
  `objectType` varchar(20) NOT NULL DEFAULT '',
  `originalValue` varchar(5000) DEFAULT NULL,
  `newValue` varchar(5000) DEFAULT NULL,
  `createdBy` varchar(100) DEFAULT NULL COMMENT 'Who generated the change',
  `entryDate` datetime DEFAULT NULL COMMENT 'Date time that change occurred',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_PERSON
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_PERSON`;

CREATE TABLE `XLR_PERSON` (
  `personId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `personName` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`personId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `XLR_PERSON` WRITE;
/*!40000 ALTER TABLE `XLR_PERSON` DISABLE KEYS */;

INSERT INTO `XLR_PERSON` (`personId`, `personName`)
VALUES
	(1,'Release Admin');

/*!40000 ALTER TABLE `XLR_PERSON` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table XLR_PHASE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_PHASE`;

CREATE TABLE `XLR_PHASE` (
  `phaseId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(250) DEFAULT NULL COMMENT 'The title of the item',
  `description` varchar(1000) DEFAULT NULL COMMENT 'The description of the item',
  `ownerId` int(11) unsigned NOT NULL COMMENT 'Join to XLR_PERSON',
  `scheduledStartDate` datetime DEFAULT NULL COMMENT 'The date that the item is supposed to start',
  `dueDate` datetime DEFAULT NULL COMMENT 'The date that the item is supposed to end',
  `startDate` datetime DEFAULT NULL COMMENT 'The actual start date',
  `endDate` datetime DEFAULT NULL COMMENT 'The actual end date',
  `plannedDuration` bigint(20) DEFAULT '0' COMMENT 'The time that the item is supposed to take to complete, in seconds',
  `flagId` int(11) unsigned DEFAULT NULL COMMENT 'Join to XLR_FLAG for status',
  `flagComment` varchar(100) DEFAULT NULL COMMENT ' The reason the item is flagged',
  `releaseId` int(11) unsigned DEFAULT NULL COMMENT 'The release this phase belongs to. This field contains id of the referred object',
  `statusId` int(11) unsigned DEFAULT NULL,
  `color` varchar(25) DEFAULT NULL COMMENT 'The color of the phase top bar in the UI. Format: #(hex value); for example ''#009CDB''',
  PRIMARY KEY (`phaseId`),
  KEY `phase_owner` (`ownerId`),
  KEY `phase_flag` (`flagId`),
  KEY `phase_release` (`releaseId`),
  KEY `phase_status` (`statusId`),
  CONSTRAINT `phase_flag` FOREIGN KEY (`flagId`) REFERENCES `XL_FLAG` (`flagId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `phase_owner` FOREIGN KEY (`ownerId`) REFERENCES `XLR_PERSON` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `phase_status` FOREIGN KEY (`statusId`) REFERENCES `XLR_STATUS` (`statusId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_PHASE_TASKS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_PHASE_TASKS`;

CREATE TABLE `XLR_PHASE_TASKS` (
  `phaseId` int(11) unsigned NOT NULL,
  `taskId` int(11) NOT NULL,
  PRIMARY KEY (`phaseId`,`taskId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_RELEASE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_RELEASE`;

CREATE TABLE `XLR_RELEASE` (
  `releaseId` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(500) DEFAULT NULL COMMENT 'he title of the item',
  `description` varchar(1000) DEFAULT NULL COMMENT 'The description of the item',
  `ownerId` int(10) unsigned DEFAULT NULL COMMENT 'The owner of the item',
  `scheduledStartDate` datetime DEFAULT NULL COMMENT 'The date that the item is supposed to start',
  `dueDate` datetime DEFAULT NULL COMMENT 'The date that the item is supposed to end',
  `startDate` datetime DEFAULT NULL COMMENT 'The actual start date',
  `endDate` datetime DEFAULT NULL COMMENT 'The actual end date',
  `plannedDuration` int(11) DEFAULT NULL COMMENT 'The time that the item is supposed to take to complete, in seconds',
  `flagId` int(10) unsigned DEFAULT NULL COMMENT 'Flags indicate that an item needs attention',
  `flagComment` varchar(100) DEFAULT NULL COMMENT 'The reason the item is flagged',
  `triggerId` int(10) unsigned DEFAULT NULL COMMENT 'The triggers that may start a release from a template',
  `realFlagStatusId` int(10) unsigned DEFAULT NULL COMMENT 'The calculated flag status, derived from the flags from the release and its tasks',
  `stateId` int(10) unsigned DEFAULT NULL COMMENT 'The state the release is in.',
  `abortOnFailure` tinyint(1) DEFAULT '0' COMMENT 'Releases automatically abort when a task fails if this property is set to true',
  `allowConcurrentReleasesFromTrigger` tinyint(1) DEFAULT NULL COMMENT 'If set to false, a trigger can''t create a release if the previous one it created is still running.',
  `originTemplateId` varchar(255) DEFAULT NULL COMMENT 'The ID of the template that created this release.',
  `createdFromTrigger` tinyint(1) DEFAULT NULL COMMENT 'True if release was created by a trigger',
  `scriptUsername` varchar(100) DEFAULT NULL COMMENT 'The credentials of this user are used to run automated scripts in this release',
  `scriptUserPassword` varchar(100) DEFAULT NULL COMMENT 'The password of the user that lends his credentials to run the scripts.',
  `datecreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dateupdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`releaseId`),
  KEY `release_flag` (`realFlagStatusId`),
  KEY `release_state` (`stateId`),
  KEY `release_owner` (`ownerId`),
  KEY `release_trigger` (`triggerId`),
  KEY `release_template` (`originTemplateId`),
  CONSTRAINT `release_flag` FOREIGN KEY (`realFlagStatusId`) REFERENCES `XL_FLAG` (`flagId`),
  CONSTRAINT `release_owner` FOREIGN KEY (`ownerId`) REFERENCES `XLR_PERSON` (`personId`),
  CONSTRAINT `release_state` FOREIGN KEY (`stateId`) REFERENCES `XLR_STATE` (`stateId`),
  CONSTRAINT `release_template` FOREIGN KEY (`originTemplateId`) REFERENCES `XLR_TEMPLATE` (`templateId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_RELEASE_PERSON
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_RELEASE_PERSON`;

CREATE TABLE `XLR_RELEASE_PERSON` (
  `releaseId` varchar(255) NOT NULL DEFAULT '',
  `personId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`releaseId`),
  KEY `release_per` (`personId`),
  CONSTRAINT `release_per` FOREIGN KEY (`personId`) REFERENCES `XLR_PERSON` (`personId`),
  CONSTRAINT `release_rel` FOREIGN KEY (`releaseId`) REFERENCES `XLR_RELEASE` (`releaseId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_RELEASE_PHASE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_RELEASE_PHASE`;

CREATE TABLE `XLR_RELEASE_PHASE` (
  `releaseId` varchar(255) NOT NULL DEFAULT '',
  `phaseId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`releaseId`),
  KEY `phase` (`phaseId`),
  CONSTRAINT `phase` FOREIGN KEY (`phaseId`) REFERENCES `XLR_PHASE` (`phaseId`),
  CONSTRAINT `release` FOREIGN KEY (`releaseId`) REFERENCES `XLR_RELEASE` (`releaseId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_RELEASE_STATUS_TAGS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_RELEASE_STATUS_TAGS`;

CREATE TABLE `XLR_RELEASE_STATUS_TAGS` (
  `releaseId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `statusId` int(11) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`releaseId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_RELEASE_TEAM
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_RELEASE_TEAM`;

CREATE TABLE `XLR_RELEASE_TEAM` (
  `releaseId` varchar(255) NOT NULL DEFAULT '',
  `teamId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`releaseId`),
  KEY `team` (`teamId`),
  CONSTRAINT `release_team` FOREIGN KEY (`releaseId`) REFERENCES `XLR_RELEASE` (`releaseId`),
  CONSTRAINT `team` FOREIGN KEY (`teamId`) REFERENCES `XLR_TEAM` (`teamId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_RELEASE_TRIGGERS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_RELEASE_TRIGGERS`;

CREATE TABLE `XLR_RELEASE_TRIGGERS` (
  `releaseId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `triggerId` int(11) DEFAULT NULL,
  `triggerValue` int(11) DEFAULT NULL,
  PRIMARY KEY (`releaseId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_RELEASE_VARIABLE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_RELEASE_VARIABLE`;

CREATE TABLE `XLR_RELEASE_VARIABLE` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `objectId` int(11) NOT NULL,
  `variableValue` varchar(500) DEFAULT NULL,
  `passwordVariableValue` varchar(500) DEFAULT NULL,
  `objectType` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_STATE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_STATE`;

CREATE TABLE `XLR_STATE` (
  `stateId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `state` varchar(25) DEFAULT NULL COMMENT '[''PLANNED'' or ''PENDING'' or ''IN_PROGRESS'' or ''COMPLETED'' or ''COMPLETED_IN_ADVANCE'' or ''SKIPPED'' or ''SKIPPED_IN_ADVANCE'' or ''FAILED'' or ''FAILING'' or ''ABORTED'' or ''PRECONDITION_IN_PROGRESS'']',
  PRIMARY KEY (`stateId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `XLR_STATE` WRITE;
/*!40000 ALTER TABLE `XLR_STATE` DISABLE KEYS */;

INSERT INTO `XLR_STATE` (`stateId`, `state`)
VALUES
	(1,'PLANNED'),
	(2,'PENDING'),
	(3,'IN_PROGRESS'),
	(4,'COMPLETED'),
	(5,'COMPLETED_IN_ADVANCE'),
	(6,'SKIPPED'),
	(7,'SKIPPED_IN_ADVANCE'),
	(8,'FAILED'),
	(9,'FAILING'),
	(10,'ABORTED'),
	(11,'PRECONDITION_IN_PROGRESS');

/*!40000 ALTER TABLE `XLR_STATE` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table XLR_STATUS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_STATUS`;

CREATE TABLE `XLR_STATUS` (
  `statusId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(50) DEFAULT NULL COMMENT 'Current Values: ''PLANNED'' or ''IN_PROGRESS'' or ''COMPLETED'' or ''FAILING'' or ''FAILED'' or ''SKIPPED'' or ''ABORTED''',
  PRIMARY KEY (`statusId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_TAG
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_TAG`;

CREATE TABLE `XLR_TAG` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `objectId` int(11) NOT NULL,
  `objectType` int(11) NOT NULL,
  `tag` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_TASK
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_TASK`;

CREATE TABLE `XLR_TASK` (
  `taskId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL COMMENT 'The title of the item',
  `description` varchar(1000) DEFAULT NULL COMMENT 'The description of the item',
  `scheduledStartDate` datetime DEFAULT NULL COMMENT ' The date that the item is supposed to start',
  `dueDate` datetime DEFAULT NULL COMMENT 'The date that the item is supposed to end',
  `startDate` datetime DEFAULT NULL COMMENT 'The actual start date',
  `endDate` datetime DEFAULT NULL COMMENT 'The actual end date',
  `plannedDuration` bigint(20) DEFAULT '0' COMMENT 'The time that the item is supposed to take to complete, in seconds',
  `flagStatusId` int(11) unsigned DEFAULT NULL COMMENT 'Flags indicate that an item needs attention',
  `flagComment` varchar(100) DEFAULT NULL COMMENT 'The reason the item is flagged',
  `containerId` int(11) unsigned NOT NULL COMMENT 'The phase or task this task is contained in. This field contains a string that is the identifier of the referred object',
  `stateId` int(11) unsigned NOT NULL COMMENT 'The state the task is in',
  `teamId` int(11) unsigned DEFAULT NULL COMMENT 'Link to name of the team this task is assigned to',
  `waitForScheduledStartDate` tinyint(1) DEFAULT '0' COMMENT 'The task is not started until the scheduledStartDate is reached if set to true',
  `precondition` varchar(5000) DEFAULT NULL COMMENT 'A snippet of code that is evaluated when the task is started',
  `failuresCount` int(11) DEFAULT '0' COMMENT 'The number of times this task has failed',
  `automated` tinyint(1) DEFAULT '0' COMMENT 'Whether this is an automated task',
  `preconditionEnabled` tinyint(1) DEFAULT '0' COMMENT 'Whether preconditions should be enabled',
  `sendNotificationWhenStarted` tinyint(1) DEFAULT '0' COMMENT 'Whether a notification must be sent when the task starts',
  `releaseId` varchar(255) DEFAULT NULL,
  `color` varchar(25) DEFAULT NULL COMMENT 'Color for task',
  PRIMARY KEY (`taskId`),
  KEY `task_state` (`stateId`),
  KEY `task_team` (`teamId`),
  KEY `task_flag` (`flagStatusId`),
  KEY `task_release` (`releaseId`),
  CONSTRAINT `task_comments` FOREIGN KEY (`taskId`) REFERENCES `XLR_TASK_COMMENTS` (`taskId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_container` FOREIGN KEY (`taskId`) REFERENCES `XLR_TASK_CONTAINER` (`containerId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_flag` FOREIGN KEY (`flagStatusId`) REFERENCES `XL_FLAG` (`flagId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_state` FOREIGN KEY (`stateId`) REFERENCES `XLR_STATE` (`stateId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_team` FOREIGN KEY (`teamId`) REFERENCES `XLR_TEAM` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_TASK_COMMENT
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_TASK_COMMENT`;

CREATE TABLE `XLR_TASK_COMMENT` (
  `taskId` int(11) unsigned NOT NULL,
  `comment` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`taskId`,`comment`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_TASK_CONTAINER
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_TASK_CONTAINER`;

CREATE TABLE `XLR_TASK_CONTAINER` (
  `containerId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `phaseId` int(11) DEFAULT NULL,
  `taskId` int(11) DEFAULT NULL,
  PRIMARY KEY (`containerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_TEAM
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_TEAM`;

CREATE TABLE `XLR_TEAM` (
  `teamId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `teamName` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`teamId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table XLR_TEMPLATE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_TEMPLATE`;

CREATE TABLE `XLR_TEMPLATE` (
  `templateId` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`templateId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `XLR_TEMPLATE` WRITE;
/*!40000 ALTER TABLE `XLR_TEMPLATE` DISABLE KEYS */;

INSERT INTO `XLR_TEMPLATE` (`templateId`)
VALUES
	('Release6903453');

/*!40000 ALTER TABLE `XLR_TEMPLATE` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table XLR_TRIGGERS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `XLR_TRIGGERS`;

CREATE TABLE `XLR_TRIGGERS` (
  `triggerId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`triggerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
