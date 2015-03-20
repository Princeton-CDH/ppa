-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 04, 2015 at 03:32 PM
-- Server version: 5.6.16
-- PHP Version: 5.5.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ppa`
--

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE IF NOT EXISTS `author` (
  `authorID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Author ID',
  `author_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Full name',
  `author_last` varchar(255) NOT NULL DEFAULT '' COMMENT 'Author last name',
  `author_first` varchar(128) DEFAULT NULL COMMENT 'Author first name',
  `author_prefix` varchar(128) DEFAULT NULL COMMENT 'Author name prefix',
  `author_suffix` varchar(128) DEFAULT NULL COMMENT 'Author name suffix',
  `author_initials` varchar(10) DEFAULT NULL COMMENT 'Author initials (including first name initial)',
  `author_affiliation` varchar(255) DEFAULT NULL COMMENT 'Author affiliation or address',
  PRIMARY KEY (`authorID`),
  KEY `lastname` (`author_last`),
  KEY `firstname` (`author_first`),
  KEY `initials` (`author_initials`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Contains Author information for each publication' AUTO_INCREMENT=3318 ;

-- --------------------------------------------------------

--
-- Table structure for table `collection`
--

CREATE TABLE IF NOT EXISTS `collection` (
  `collectionID` int(11) NOT NULL AUTO_INCREMENT,
  `collection_title` varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`collectionID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='The collections defined by Meredith and Meagan' AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `entry`
--

CREATE TABLE IF NOT EXISTS `entry` (
  `entryID` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) NOT NULL,
  `entry_sort_title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `entry_full_title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `entry_secondary_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_tertiary_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_edition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_publisher` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_place_published` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_year` int(11) DEFAULT NULL,
  `entry_volume` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_pages` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_date` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_isbn` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_lang` varchar(24) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_notes` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`entryID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='The Bibliographic records' AUTO_INCREMENT=11740 ;

-- --------------------------------------------------------

--
-- Table structure for table `entry_author`
--

CREATE TABLE IF NOT EXISTS `entry_author` (
  `entry_authorID` int(11) NOT NULL AUTO_INCREMENT,
  `entry_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'node.nid of the node',
  `author_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'biblio_contributor_data.cid of the node',
  PRIMARY KEY (`entry_authorID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Relational table linking authors to bibliographic entries' AUTO_INCREMENT=7207 ;

-- --------------------------------------------------------

--
-- Table structure for table `entry_collection`
--

CREATE TABLE IF NOT EXISTS `entry_collection` (
  `entry_collectionID` int(11) NOT NULL AUTO_INCREMENT,
  `entry_id` int(11) NOT NULL,
  `collection_id` int(11) NOT NULL,
  PRIMARY KEY (`entry_collectionID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Linking table connecting entries and collections' AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `entry_hathi`
--

CREATE TABLE IF NOT EXISTS `entry_hathi` (
  `entry_hathiID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: The biblio_ht_item.iid of the item of the node.',
  `entry_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid of the node.',
  `enumcron` varchar(255) DEFAULT NULL COMMENT 'The HathiTrust enumcron',
  `htid` varchar(255) NOT NULL COMMENT 'The HathiTrust identifier',
  PRIMARY KEY (`entry_hathiID`),
  KEY `nid` (`entry_id`),
  KEY `htid` (`htid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Linking table connecting entries and Hathi records' AUTO_INCREMENT=51296 ;

-- --------------------------------------------------------

--
-- Table structure for table `entry_tag`
--

CREATE TABLE IF NOT EXISTS `entry_tag` (
  `entry_tagID` int(11) NOT NULL AUTO_INCREMENT,
  `entry_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`entry_tagID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Linking entries with Tags to be dinined by Meredith and Meag' AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE IF NOT EXISTS `tag` (
  `tagID` int(11) NOT NULL AUTO_INCREMENT,
  `tag_value` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`tagID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Tags' AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `type`
--

CREATE TABLE IF NOT EXISTS `type` (
  `typeID` int(11) NOT NULL DEFAULT '0' COMMENT 'biblio_types.tid of the publication type',
  `type_name` varchar(64) NOT NULL DEFAULT '' COMMENT 'The name of the publication type',
  PRIMARY KEY (`typeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Types from Drupal Biblio (book, article, etc))';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
