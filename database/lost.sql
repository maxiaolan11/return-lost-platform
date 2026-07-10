-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: campus_lost_found
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '分类名称',
  `slug` varchar(100) NOT NULL COMMENT '分类别名',
  `description` text COMMENT '分类描述',
  `parent_id` int DEFAULT '0' COMMENT '父分类ID',
  `sort` int DEFAULT '0' COMMENT '排序',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uk_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'失物','lost','丢失的物品',0,1,'2026-06-10 09:10:14','2026-06-10 09:10:14'),(2,'招领','found','捡到的物品',0,2,'2026-06-10 09:10:14','2026-06-10 09:10:14'),(4,'失物招领','lost-found','失物招领信息',NULL,1,'2026-06-13 15:45:52','2026-06-13 15:45:52'),(5,'默认分类','default','系统默认分类',NULL,1,'2026-06-13 16:07:27','2026-06-13 16:07:27');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `status_id` int NOT NULL COMMENT '状态ID',
  `user_name` varchar(50) NOT NULL COMMENT '评论用户',
  `content` text NOT NULL COMMENT '评论内容',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  PRIMARY KEY (`comment_id`),
  KEY `idx_status_id` (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,163,'user','哈哈哈','2026-05-27 11:42:26'),(2,163,'admin','hhh','2026-05-27 11:43:12'),(3,208,'admin','hh','2026-05-28 11:18:52'),(4,212,'admin','aaa','2026-06-16 15:42:20');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `files` (
  `file_id` int NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名(UUID)',
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型(MIME类型)',
  `extension` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件扩展名',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件描述',
  `upload_user` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上传用户',
  `upload_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `download_count` int DEFAULT '0' COMMENT '下载次数',
  `is_deleted` int DEFAULT '0' COMMENT '是否删除(0-未删除,1-已删除)',
  PRIMARY KEY (`file_id`),
  KEY `idx_upload_user` (`upload_user`),
  KEY `idx_upload_time` (`upload_time`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件上传表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
INSERT INTO `files` VALUES (3,'273388d6d64c4dea88072c343075660c.png','F1 1.png','2026\\05\\273388d6d64c4dea88072c343075660c.png',90084,'image/png','png','','admin','2026-05-26 18:43:36',0,1),(4,'0ee40c8c45e24f47902ed00224c2a094.png','F1 2.png','2026\\05\\0ee40c8c45e24f47902ed00224c2a094.png',752353,'image/png','png','','admin','2026-05-26 18:53:44',0,1),(5,'3f05e5f6ed9049d783da1e6e8cea6556.png','屏幕截图 2026-05-26 191213.png','2026\\05\\3f05e5f6ed9049d783da1e6e8cea6556.png',63615,'image/png','png','','admin','2026-05-26 19:15:04',1,0),(6,'c220f01df6de4dd8b4cf2e6db2fb117a.png','屏幕截图 2024-06-06 112926.png','2026\\05\\c220f01df6de4dd8b4cf2e6db2fb117a.png',146385,'image/png','png','','admin','2026-05-26 19:45:58',0,0),(8,'55e774a90c1d4b508692dc678f8873d8.png','屏幕截图 2024-09-11 181502.png','2026\\05\\55e774a90c1d4b508692dc678f8873d8.png',10676,'image/png','png','','admin','2026-05-26 19:52:37',0,0),(14,'3c1dd65dfb874886b29612395db97b1e.docx','题库.docx','2026\\05\\3c1dd65dfb874886b29612395db97b1e.docx',23902,'application/vnd.openxmlformats-officedocument.wordprocessingml.document','docx','','admin','2026-05-27 10:15:31',0,0),(23,'0eca6ed876944d22bd02c257b9414af1.png','屏幕截图 2024-12-19 212846.png','2026\\05\\0eca6ed876944d22bd02c257b9414af1.png',4070194,'image/png','png','','admin','2026-05-28 11:51:27',0,0),(24,'ada327c8-e6a4-4183-814c-2cf7f43f88d9.png','屏幕截图 2024-06-06 103407.png','avatars/ada327c8-e6a4-4183-814c-2cf7f43f88d9.png',584523,'image/png',NULL,NULL,'admin','2026-06-19 23:12:07',0,0),(25,'9395a2ab-72a0-480a-9721-3eddbb7559dc.png','屏幕截图 2026-06-19 162145.png','avatars/9395a2ab-72a0-480a-9721-3eddbb7559dc.png',8078,'image/png',NULL,NULL,'admin','2026-06-19 23:12:37',0,0),(26,'1882f601-6104-4c23-b2d8-dc82fdeb5938.png','屏幕截图 2024-06-06 103407.png','avatars/1882f601-6104-4c23-b2d8-dc82fdeb5938.png',584523,'image/png',NULL,NULL,'admin','2026-06-19 23:16:20',0,0),(27,'c6cf2a8a-bdfb-4280-8e85-78254cf9b7a7.png','5326.png_300.png','avatars/c6cf2a8a-bdfb-4280-8e85-78254cf9b7a7.png',36152,'image/png',NULL,NULL,'admin','2026-06-19 23:18:19',0,0),(28,'b4b91ecf-d7a3-4692-a3ec-417487798dc3.png','屏幕截图 2024-06-06 103407.png','avatars/b4b91ecf-d7a3-4692-a3ec-417487798dc3.png',584523,'image/png',NULL,NULL,'admin','2026-06-19 23:19:02',0,0),(29,'3ba3dd84-f68d-4da0-9aa3-4d043b1548c5.png','u=3943093702,2744567685&fm=253&app=138&f=JPEG.png','avatars/3ba3dd84-f68d-4da0-9aa3-4d043b1548c5.png',43775,'image/png',NULL,NULL,'admin','2026-06-26 13:07:21',0,0),(30,'28a126af-650c-407a-becb-d5b5ed62dc38.png','u=3943093702,2744567685&fm=253&app=138&f=JPEG.png','avatars/28a126af-650c-407a-becb-d5b5ed62dc38.png',43775,'image/png',NULL,NULL,'admin','2026-06-26 13:09:10',0,0),(31,'7dd77aa8-adf3-481b-9f6b-89f9c21e7176.png','u=3943093702,2744567685&fm=253&app=138&f=JPEG.png','avatars/7dd77aa8-adf3-481b-9f6b-89f9c21e7176.png',43775,'image/png',NULL,NULL,'admin','2026-06-26 13:11:26',0,0);
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_category`
--

DROP TABLE IF EXISTS `item_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '分类唯一标识ID',
  `category_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称（如：证件、电子设备、生活用品）',
  `category_desc` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类描述',
  `sort` int DEFAULT '0' COMMENT '排序权重（数字越小越靠前）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '分类创建时间',
  `cover_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'active' COMMENT '状态',
  `is_top` tinyint(1) DEFAULT '0' COMMENT '是否置顶',
  `published_at` datetime DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='物品分类基础表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_category`
--

LOCK TABLES `item_category` WRITE;
/*!40000 ALTER TABLE `item_category` DISABLE KEYS */;
INSERT INTO `item_category` VALUES (1,'电子产品（更新）','更新描述02',1,'2026-03-21 20:46:56',NULL,'active',0,NULL),(2,'电子设备','手机、电脑、平板、耳机、充电宝等电子产品',2,'2026-03-21 20:46:56',NULL,'active',0,NULL),(3,'学习用品','书包、笔记本、笔、U盘、书籍等学习相关物品',3,'2026-03-21 20:46:56',NULL,'active',0,NULL),(4,'生活用品','水杯、雨伞、钥匙、钱包、衣物等日常用品',4,'2026-03-21 20:46:56',NULL,'active',0,NULL),(5,'饰品配饰','手表、项链、手链、戒指、耳环等装饰物品',5,'2026-03-21 20:46:56',NULL,'active',0,NULL),(6,'箱包类','背包、行李箱、手提包、帆布包等各类包袋',6,'2026-03-21 20:46:56',NULL,'active',0,NULL),(7,'运动器材','篮球、足球、羽毛球拍、跳绳、瑜伽垫等',7,'2026-03-21 20:46:56',NULL,'active',0,NULL),(8,'食品饮品','外卖、零食、瓶装水、保温杯等食品类',8,'2026-03-21 20:46:56',NULL,'active',0,NULL),(9,'文具耗材','打印机墨盒、中性笔芯、文件夹、订书机等',9,'2026-03-21 20:46:56',NULL,'active',0,NULL),(10,'数码配件','数据线、充电器、鼠标、键盘、存储卡等',10,'2026-03-21 20:46:56',NULL,'active',0,NULL),(11,'银行卡','储蓄卡、信用卡、校园一卡通等各类卡类',11,'2026-03-21 20:46:56',NULL,'active',0,NULL),(12,'眼镜','近视镜、墨镜、老花镜等各类眼镜',12,'2026-03-21 20:46:56',NULL,'active',0,NULL),(13,'化妆品','口红、粉底液、眼影、护肤品等美妆类',13,'2026-03-21 20:46:56',NULL,'active',0,NULL),(14,'药品','感冒药、退烧药、创可贴等各类常备药品',14,'2026-03-21 20:46:56',NULL,'active',0,NULL),(15,'乐器','吉他、尤克里里、口琴、笛子等小型乐器',15,'2026-03-21 20:46:56',NULL,'active',0,NULL),(16,'充电宝','便携充电宝、车载充电器等（单独分类）',16,'2026-03-21 20:46:56',NULL,'active',0,NULL),(17,'耳机','有线耳机、无线耳机、头戴式耳机等',17,'2026-03-21 20:46:56',NULL,'active',0,NULL),(18,'U盘/硬盘','U盘、移动硬盘、固态硬盘等存储设备',18,'2026-03-21 20:46:56',NULL,'active',0,NULL),(19,'雨伞雨具','折叠伞、长柄伞、雨衣、雨鞋等雨具',19,'2026-03-21 20:46:56',NULL,'active',0,NULL),(20,'其他物品','无法归类的其他失物/寻物物品',20,'2026-03-21 20:46:56',NULL,'active',0,NULL),(21,'电子产品','手机、耳机、平板等',1,'2026-03-29 20:39:36',NULL,'active',0,NULL),(27,'电脑','电脑',0,'2026-06-26 14:38:32',NULL,'active',0,NULL),(28,'背包测试','测试',0,'2026-06-26 15:14:34',NULL,'active',0,NULL);
/*!40000 ALTER TABLE `item_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `location_id` int NOT NULL AUTO_INCREMENT COMMENT '地点唯一标识ID',
  `location_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地点名称（如：一教101教室、图书馆3楼阅览区）',
  `location_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '地点类型（教学楼、图书馆、食堂、宿舍、操场等）',
  `campus_area` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '校区（如：本部、东校区、西校区）',
  `is_common` tinyint DEFAULT '1' COMMENT '是否常用地点：1-是 0-否',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '地点创建时间',
  PRIMARY KEY (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='校园地点基础表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'一教101教室','教学楼','本部',1,'2026-03-21 20:46:56'),(2,'一教205教室','教学楼','本部',1,'2026-03-21 20:46:56'),(3,'二教308教室','教学楼','本部',1,'2026-03-21 20:46:56'),(4,'图书馆1楼借阅区','图书馆','本部',1,'2026-03-21 20:46:56'),(5,'图书馆3楼电子阅览室','图书馆','本部',1,'2026-03-21 20:46:56'),(6,'图书馆4楼自习室','图书馆','本部',1,'2026-03-21 20:46:56'),(7,'第一食堂1楼','食堂','本部',1,'2026-03-21 20:46:56'),(8,'第二食堂2楼','食堂','本部',1,'2026-03-21 20:46:56'),(9,'北苑宿舍1号楼','宿舍','本部',1,'2026-03-21 20:46:56'),(10,'南苑宿舍3号楼','宿舍','本部',1,'2026-03-21 20:46:56'),(11,'操场篮球场','运动场地','本部',1,'2026-03-21 20:46:56'),(12,'操场跑道','运动场地','本部',1,'2026-03-21 20:46:56'),(13,'体育馆1楼健身房','运动场地','本部',0,'2026-03-21 20:46:56'),(14,'校医院一楼挂号处','医疗场所','本部',0,'2026-03-21 20:46:56'),(15,'行政楼302办公室','行政楼','本部',0,'2026-03-21 20:46:56'),(16,'东校区教学楼A栋203','教学楼','东校区',1,'2026-03-21 20:46:56'),(17,'东校区图书馆2楼','图书馆','东校区',1,'2026-03-21 20:46:56'),(18,'东校区第三食堂','食堂','东校区',1,'2026-03-21 20:46:56'),(19,'西校区操场足球场','运动场地','西校区',1,'2026-03-21 20:46:56'),(20,'校门口快递站','便民场所','本部',1,'2026-03-21 20:46:56'),(23,'西区食堂',NULL,NULL,1,'2026-06-26 13:15:50');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '启事唯一标识ID',
  `notice_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '启事标题',
  `notice_type` tinyint NOT NULL COMMENT '启事类型：1-寻物启事 2-失物招领',
  `user_id` int NOT NULL COMMENT '发布者ID（关联用户表）',
  `category_id` int NOT NULL COMMENT '物品分类ID（关联物品分类表）',
  `location_id` int NOT NULL COMMENT '丢失/拾获地点ID（关联地点表）',
  `item_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '物品名称',
  `item_desc` text COLLATE utf8mb4_unicode_ci COMMENT '物品描述（特征、外观等）',
  `time` datetime NOT NULL COMMENT '丢失/拾获时间',
  `status_id` int NOT NULL DEFAULT '1' COMMENT '状态ID（关联状态表）',
  `contact_way` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系方式（可多个）',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '物品图片路径',
  `view_count` int DEFAULT '0' COMMENT '浏览次数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_top` int DEFAULT '0' COMMENT '是否置顶：0-否，1-是',
  PRIMARY KEY (`notice_id`),
  KEY `user_id` (`user_id`),
  KEY `category_id` (`category_id`),
  KEY `location_id` (`location_id`),
  KEY `status_id` (`status_id`),
  CONSTRAINT `notice_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `notice_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `item_category` (`category_id`),
  CONSTRAINT `notice_ibfk_3` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='失物招领/寻物启事基础表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (2,'拾到黑色小米手机',2,2,2,4,'小米14手机','黑色外壳，屏幕有轻微划痕，开机密码6位','2026-02-02 10:15:00',3,'电话13800138002','/uploads/notices/d0a5ae3b-445a-47bf-beab-9c9199a99be6.png',0,'2026-03-21 20:46:56','2026-06-23 16:22:43',0),(3,'寻找丢失的黑色雨伞',1,3,19,7,'黑色折叠伞','伞柄有小熊挂件，伞面有轻微破损','2026-02-03 12:20:00',3,'微信13800138003','/uploads/notices/0ff9bd1c-be38-46d1-a9c1-a80083877ef8.png',0,'2026-03-21 20:46:56','2026-06-23 16:33:04',0),(4,'拾到棕色钱包',2,4,4,8,'棕色钱包','内有身份证、银行卡2张，现金若干','2026-02-04 14:00:00',4,'邮箱zhaoliu@school.edu.cn','/images/wallet1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(5,'寻找丢失的蓝牙耳机',1,5,17,5,'AirPods Pro','白色外壳，刻有字母Q','2026-02-05 16:30:00',3,'电话13800138005','/images/earphone1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(6,'拾到红色保温杯',2,6,4,6,'保温杯','膳魔师品牌，500ml，杯身有贴纸','2026-02-06 09:10:00',3,'微信13800138006','/images/cup1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(7,'寻找丢失的学生证',1,7,1,9,'学生证','学号2023001007，姓名周九，商学院','2026-02-07 11:25:00',6,'电话13800138007','/images/studentcard1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(8,'拾到黑色双肩包',2,8,3,2,'双肩包','耐克品牌，内有笔记本、笔','2026-02-08 13:40:00',4,'邮箱wushi@school.edu.cn','/images/bag1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(9,'寻找丢失的U盘',1,9,18,3,'U盘','64G，金士顿品牌，外壳刻有名字郑十一','2026-02-09 15:50:00',3,'电话13800138009','/images/usb1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(10,'拾到近视眼镜',2,10,12,4,'近视眼镜','黑色镜框，度数左300右250','2026-02-10 17:10:00',3,'微信13800138010','/images/glasses1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(11,'寻找丢失的篮球',1,11,7,11,'斯伯丁篮球','橙色，球面上有签名，7号球','2026-02-11 08:20:00',3,'电话13800138011','/images/basketball1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(12,'拾到粉色笔记本',2,12,3,1,'笔记本','封面有樱花图案，内有笔记内容','2026-02-12 10:35:00',3,'邮箱chushisi@school.edu.cn','/images/notebook1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(13,'寻找丢失的身份证',1,13,1,15,'身份证','姓名卫老师，身份证号后四位1234','2026-02-13 12:45:00',6,'电话13900139001','/images/idcard1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(14,'拾到充电宝',2,14,16,7,'罗马仕充电宝','20000mAh，白色，有数据线','2026-02-14 14:55:00',4,'电话13900139002','/images/powerbank1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(15,'寻找丢失的口红',1,15,13,8,'迪奥999口红','红色外壳，余量约一半','2026-02-15 16:15:00',3,'微信13900139003','/images/lipstick1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(16,'拾到考研书籍',2,16,3,6,'考研数学真题','2025版，内有笔记和标注','2026-02-16 09:30:00',3,'邮箱hanlaoshi@school.edu.cn','/images/book1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(17,'寻找丢失的钥匙串',1,17,4,10,'钥匙串','有宿舍钥匙2把，门禁卡1张，卡通挂件','2026-02-17 11:40:00',3,'电话13900139005','/images/keys1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(18,'拾到羽毛球拍',2,18,7,11,'尤尼克斯羽毛球拍','单拍，线是新换的','2026-02-18 13:50:00',3,'邮箱zhulaoshi@school.edu.cn','/images/racket1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(19,'寻找丢失的数据线',1,19,10,5,'苹果数据线','原装，1米长，白色','2026-02-19 15:10:00',3,'电话13900139007','/images/cable1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(20,'拾到帆布包',2,20,6,20,'帆布包','印有学校logo，内有纸巾、口罩','2026-02-20 17:20:00',4,'邮箱youlaoshi@school.edu.cn','/images/canvasbag1.jpg',0,'2026-03-21 20:46:56','2026-03-21 20:46:56',0),(26,'蜜雪冰城',1,100,20,6,'蜜雪冰城','蜜雪冰城','2026-06-23 16:32:15',1,'12345','/uploads/notices/b2d5fcc1-4540-4085-bf5e-5bb108ac9883.png',0,'2026-06-23 16:32:15','2026-06-23 16:32:15',0),(27,'发圈',1,100,20,4,'发圈','发圈','2026-06-23 17:07:46',1,'12345','/uploads/notices/15d6c54b-83b7-4ba3-b88f-bfb9408a9082.png',0,'2026-06-23 17:07:46','2026-06-23 17:07:46',0),(28,'Mac电脑',1,100,21,20,'电脑','1111','2026-06-23 17:10:21',1,'1111','/uploads/notices/5af16cef-38c8-4b86-a463-c70cb5a53599.png',0,'2026-06-23 17:10:21','2026-06-23 17:10:21',0),(29,'背包',1,101,6,23,'背包','背包','2026-06-26 15:12:51',1,'1234567','/uploads/notices/6535eeed-b760-4186-9c96-0a67053b5f9d.png',0,'2026-06-26 15:12:51','2026-06-26 15:12:51',0);
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persistent_logins`
--

DROP TABLE IF EXISTS `persistent_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persistent_logins` (
  `username` varchar(64) NOT NULL,
  `series` varchar(64) NOT NULL,
  `token` varchar(64) NOT NULL,
  `last_used` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`series`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persistent_logins`
--

LOCK TABLES `persistent_logins` WRITE;
/*!40000 ALTER TABLE `persistent_logins` DISABLE KEYS */;
INSERT INTO `persistent_logins` VALUES ('admin','pkDck0TCWnJiVhCLxtElEg==','//I52xkFNguJ4zpg33Sleg==','2026-06-16 07:42:11');
/*!40000 ALTER TABLE `persistent_logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `status_id` int NOT NULL AUTO_INCREMENT COMMENT '状态唯一标识ID',
  `status_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态名称（如：待审核、已发布、已找回、已认领）',
  `status_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_desc` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态描述',
  `category_id` int DEFAULT NULL COMMENT '分类ID',
  `tags` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签ID列表，逗号分隔',
  `sort` int DEFAULT '0' COMMENT '排序权重',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `author_id` int DEFAULT NULL COMMENT '作者ID',
  `publish_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'immediate' COMMENT '发布类型: immediate-立即发布, scheduled-定时发布',
  `publish_time` datetime DEFAULT NULL COMMENT '定时发布时间',
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片URL',
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`),
  UNIQUE KEY `status_code` (`status_code`),
  UNIQUE KEY `status_code_2` (`status_code`)
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='启事/招领状态基础表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (5,'待确认','TO_CONFIRM','认领申请提交后等待发布者确认测试',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(6,'已找回','FOUND','寻物启事对应的物品已找回',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(10,'认领失败','CLAIM_FAILED','认领信息不符，认领失败。',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(11,'暂存草稿','DRAFT','用户保存为草稿，未提交审核',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(12,'过期未处理','EXPIRED','超过有效期未处理',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(13,'已归档','ARCHIVED','处理完成后归档',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(14,'举报待核实','REPORTED','被用户举报，待管理员核实',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(15,'违规下架','ILLEGAL','违规内容，强制下架',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(16,'找回待确认','FOUND_TO_CONFIRM','用户提交找回，待管理员确认',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(17,'认领待审核','CLAIM_REVIEW','认领申请待管理员审核',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(18,'补发审核','REPUBLISH_REVIEW','重新发布待审核',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(19,'修改待审核','EDIT_REVIEW','修改内容后待审核',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(20,'删除待审核','DELETE_REVIEW','申请删除待审核',1,NULL,NULL,'2026-04-09 10:21:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(53,'ccc','cccd','cccc',1,NULL,NULL,'2026-04-29 19:07:49','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(60,'6','6','60',1,NULL,NULL,'2026-05-19 18:11:39','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(61,'77','77','7',1,NULL,NULL,'2026-05-19 18:14:24','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(62,'31','31','2',1,NULL,NULL,'2026-05-19 18:17:05','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(64,'消费','1','1',1,NULL,NULL,'2026-05-19 19:17:20','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(162,'啊啊','14','aaa\n\n\n',1,NULL,NULL,'2026-05-27 11:13:00','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(163,'AAA','142','12',1,NULL,NULL,'2026-05-27 11:31:36','2026-06-13 15:45:52',1,'immediate',NULL,'2026\\05\\b06c2b276dbf4764919a665fd6567ec9.png'),(187,'立即发布_钥匙','published_999','捡到一串钥匙（立即发布，首页可见）',1,NULL,NULL,'2026-05-27 23:14:45','2026-06-13 15:45:52',1,'immediate','2026-05-27 23:14:45',NULL),(190,'a','published_9','捡到一串钥匙（立即发布，首页可见）',1,NULL,NULL,'2026-05-27 23:15:17','2026-06-13 15:45:52',1,'immediate','2026-05-27 23:15:17',NULL),(201,'待认领_测试','published_001','物品已被捡到，等待失主前来认领',1,NULL,1,'2026-05-27 23:21:43','2026-06-13 15:45:52',1,'immediate','2026-05-27 23:21:43',NULL),(202,'已归还_测试','published_202','物品已成功归还给失主（1分钟后发布）',1,NULL,NULL,'2026-05-27 23:21:43','2026-06-13 15:45:52',1,'published','2026-05-27 23:22:43',NULL),(203,'待a','13','111',1,NULL,1,'2026-05-27 23:26:14','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(204,'SSSS','published_204','123',1,NULL,NULL,'2026-05-27 23:30:45','2026-06-13 15:45:52',1,'immediate',NULL,NULL),(206,'测试s','published_206','111',1,NULL,NULL,'2026-05-28 10:55:54','2026-06-13 15:45:52',1,'published','2026-05-28 10:57:00',NULL),(207,'测试F','published_207','123',1,NULL,NULL,'2026-05-28 11:15:37','2026-06-13 15:45:52',1,'published','2026-05-28 11:16:00',NULL),(208,'测试w','published_208','12',1,NULL,NULL,'2026-05-28 11:16:32','2026-06-13 15:45:52',1,'published','2026-05-29 03:16:00',NULL),(209,'测试r','published_209','111',1,NULL,0,'2026-05-28 11:52:49','2026-06-13 15:45:52',1,'published','2026-05-28 11:54:00',NULL),(211,'测试111','published_211','111',1,NULL,NULL,'2026-05-28 11:58:10','2026-06-13 15:45:52',1,'published','2026-05-28 11:59:00',NULL),(221,'测试1','t','测试',NULL,NULL,0,'2026-06-26 13:29:11','2026-06-26 13:29:11',NULL,'published',NULL,NULL),(222,'测试Qq','qqq','qqq',NULL,NULL,0,'2026-06-26 13:49:15','2026-06-26 13:49:15',NULL,'immediate',NULL,NULL),(223,'测试去','111','11',NULL,NULL,0,'2026-06-26 13:50:26','2026-06-26 13:50:26',NULL,'immediate',NULL,NULL),(224,'待取回','2301','带取回',NULL,NULL,0,'2026-06-26 13:53:27','2026-06-26 13:53:27',NULL,'immediate',NULL,NULL),(225,'找回','1231','1221',NULL,NULL,0,'2026-06-26 14:00:14','2026-06-26 14:00:14',NULL,'immediate',NULL,NULL),(226,'待找到','te','111',NULL,NULL,0,'2026-06-26 14:37:35','2026-06-26 14:37:35',NULL,'published',NULL,NULL),(229,'已找回_测试','re','111',NULL,NULL,0,'2026-06-26 14:43:15','2026-06-26 14:43:15',NULL,'published',NULL,NULL),(230,'已丢失_','ddd','ddd',NULL,NULL,0,'2026-06-26 14:47:04','2026-06-26 14:47:04',NULL,'published',NULL,NULL),(231,'待归还_','guihuan','111',NULL,NULL,0,'2026-06-26 14:52:55','2026-06-26 14:52:55',NULL,'published',NULL,NULL),(232,'测试待归还_','qqqqd','11110',NULL,NULL,0,'2026-06-26 15:00:27','2026-06-26 15:11:11',NULL,'published',NULL,NULL),(234,'测试sds','sds','sss\n',NULL,NULL,0,'2026-06-26 15:16:49','2026-06-26 15:16:49',NULL,'published',NULL,NULL),(235,'测试','ssssd','ssdsasq',NULL,NULL,0,'2026-06-26 15:18:00','2026-06-26 15:21:51',NULL,'published',NULL,NULL);
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `tag_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '标签名称',
  `slug` varchar(100) NOT NULL COMMENT '标签别名',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `uk_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='标签表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'手机','phone','2026-06-10 09:10:14'),(2,'钱包','wallet','2026-06-10 09:10:14'),(3,'钥匙','keys','2026-06-10 09:10:14'),(4,'校园卡','campus-card','2026-06-10 09:10:14');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户唯一标识ID',
  `user_no` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学号/工号',
  `user_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户姓名',
  `user_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '普通用户',
  `college` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所属学院（学生/教职工）',
  `phone` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '/default/avatar.png' COMMENT '头像路径',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '账号创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '信息更新时间',
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码哈希值',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'user' COMMENT '角色：admin/editor/user',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'active' COMMENT '状态：active/inactive/banned',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_no` (`user_no`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户基础表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'2023001001','张三','1','计算机学院','13900139991','zhangsan@school.edu.cn','','2026-03-21 20:46:56','2026-05-10 18:33:20','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'admin','active'),(2,'2023001002','李四','1','计算机学院','13800138002','lisi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(3,'2023001003','王五','1','电子信息学院','13800138003','wangwu@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(4,'2023001004','赵六','1','电子信息学院','13800138004','zhaoliu@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(5,'2023001005','钱七','1','文学院','13800138005','qianqi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(6,'2023001006','孙八','1','文学院','13800138006','sunba@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(7,'2023001007','周九','1','商学院','13800138007','zhoujiu@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(8,'2023001008','吴十','1','商学院','13800138008','wushi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(9,'2023002001','郑十一','1','外国语学院','13800138009','zhengshiyi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(10,'2023002002','冯十二','1','外国语学院','13800138010','fengshi\'er@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(11,'2023003001','陈十三','1','法学院','13800138011','chenshisan@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(12,'2023003002','褚十四','1','法学院','13800138012','chushisi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(13,'2021001001','卫老师','2','计算机学院','13900139001','weilaoshi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(14,'2021001002','蒋老师','2','电子信息学院','13900139002','jianglaoshi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(15,'2021001003','沈老师','2','文学院','13900139003','shenlaoshi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(16,'2021002001','韩老师','2','商学院','13900139004','hanlaoshi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(17,'2021002002','杨老师','2','外国语学院','13900139005','yanglaoshi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(18,'2021003001','朱老师','2','法学院','13900139006','zhulaoshi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(19,'2021003002','秦老师','2','后勤处','13900139007','qinlaoshi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(20,'2021004001','尤老师','2','保卫处','13900139008','youlaoshi@school.edu.cn','/default/avatar.png','2026-03-21 20:46:56','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(21,'2023004001','测试用户','1','测试学院','13800138999','test@school.edu.cn','/default/avatar.png','2026-03-29 20:53:30','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(24,'20231774789075047','测试用户','1','测试学院','13800138999','test@school.edu.cn','/default/avatar.png','2026-03-29 20:57:55','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(25,'20231775014852015','测试用户','1','测试学院','13800138999','test@school.edu.cn','/default/avatar.png','2026-04-01 11:40:52','2026-05-06 21:04:45','$2a$10$X20eU.mkYz.e284Q2Ow.hye1E37kqTHVs6Bg6loWIPqlhCoQDAiC9G',NULL,'user','active'),(26,'T001','张老师','2','计算机学院','13800138001','teacher@example.com','/avatars/teacher.png','2026-05-07 10:32:59','2026-05-07 10:32:59','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',NULL,'user','active'),(27,'S001','李同学','1','计算机学院','13800138002','student@example.com','/avatars/student.png','2026-05-07 10:32:59','2026-05-07 10:32:59','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',NULL,'user','active'),(28,'admin','系统管理员','2','信息中心','13800000000','admin@example.com','/avatars/admin.png','2026-05-07 11:13:33','2026-05-07 11:13:33','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',NULL,'user','active'),(29,'2024001001','测试用户','1','计算机学院','13800138001','test@school.edu.cn','/default/avatar.png','2026-05-07 11:25:16','2026-05-10 18:33:20','',NULL,'user','active'),(30,'admin001','admin','1','计算机学院','13900139000','admin@school.edu.cn','/uploads/avatars/b4b91ecf-d7a3-4692-a3ec-417487798dc3.png','2026-05-07 11:32:11','2026-06-22 23:44:26','','$2a$10$faYed2MHoYCm7cgdwEgaEeyfOoDEmLXUIdKYfJO6buDUC.aN22q7a','admin','active'),(40,'EDIT001','editor','0','内容编辑部','13800138001','editor@campus.com','/default-avatar.png','2026-05-09 21:47:30','2026-05-10 20:22:47','','$2a$10$g2KobHS3UnY48iPhYkvgPeuKZ2s38Y3kR.F1CJ6a3ctzS8N5ELGNy','editor','active'),(41,'USER001','user','1','计算机学院','13800138002','user@campus.com','/default-avatar.png','2026-05-09 21:47:30','2026-05-10 20:41:44','','$2a$10$g2KobHS3UnY48iPhYkvgPeuKZ2s38Y3kR.F1CJ6a3ctzS8N5ELGNy','user','active'),(97,'U001','张三','1','计算机学院','13800138001','zhangsan@test.com','/avatars/1.png','2026-06-13 15:45:52','2026-06-19 16:44:58','','','user','active'),(100,'123445','陈舞','1',NULL,NULL,'1234567@qq.com','/uploads/avatars/c6cf2a8a-bdfb-4280-8e85-78254cf9b7a7.png','2026-06-19 22:54:16','2026-06-22 21:12:38','','','user','active'),(101,'1234','肖战','普通用户',NULL,NULL,'12321@qq.com','/uploads/avatars/7dd77aa8-adf3-481b-9f6b-89f9c21e7176.png','2026-06-26 13:11:27','2026-06-26 13:11:27','','$2a$10$GmWKsKvP5fZ.aYZgiozy.ufhmw2.54lq23oaNLoObqf2TZ1BTng2W','user','active');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-26 15:35:58
