-- Chatty database template
-- Chatty version 0.1.0
-- Template version 0.1.0

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
CREATE DATABASE IF NOT EXISTS chatty;
USE 'chatty';

--
-- Database: `chatty`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `UID` INT(6) NOT NULL AUTO_INCREMENT,
  `PRIVILEGE` varchar(8) DEFAULT 'user',
  `NICK` varchar(24),
  `PASSWORD` varchar(128),
  `BAN` boolean DEFAULT false,
  PRIMARY KEY (`UID`)
) DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UID`, `PRIVILEGE`, `NICK`, `PASSWORD`, `BAN`) VALUES
('0', 'mod', 'MODERATOR', '0408f3c997f309c03b08bf3a4bc7b730', false),
('1', 'user', 'guest', '084e0343a0486ff05530df6c705c8bb4', false);

-- --------------------------------------------------------

--
-- Table structure for table `iptables`
--

CREATE TABLE IF NOT EXISTS `iptables` (
  `UID` INT(6) NOT NULL,
  `IP` varchar(15),
  `BAN` boolean DEFAULT false,
  PRIMARY KEY (`UID`, `IP`)
) DEFAULT CHARSET=latin1;

--
-- Dumping data for table `iptables`
--

INSERT INTO `iptables` (`UID`, `IP`, `BAN`) VALUES
('0', '0.0.0.0', false),
('1', '0.0.0.0', false);

-- --------------------------------------------------------

--
-- Table structure for table `activity`
--

CREATE TABLE IF NOT EXISTS `activity` (
  `UID` varchar(6) NOT NULL,
  `ACTIVITY` varchar(80),
  `CONTENT` varchar(1280),
  `TIMESTAMP` varchar(21) NOT NULL,
  PRIMARY KEY (`UID`, `TIMESTAMP`)
) DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `TYPE` varchar(16) NOT NULL,
  `MODULE` varchar(32) NOT NULL,
  `CONTENT` varchar(512),
  `TIMESTAMP` varchar(21) NOT NULL,
  PRIMARY KEY (`TIMESTAMP`)
) DEFAULT CHARSET=latin1;

--
-- #TODO Create a moderator and admin role & Create a moderator and admin user
--
