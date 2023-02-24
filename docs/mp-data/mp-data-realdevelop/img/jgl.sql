/*
Navicat MySQL Data Transfer

Source Server         : 172.18.8.148
Source Server Version : 50726
Source Host           : 172.18.42.148:13306
Source Database       : jgl

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2021-09-23 09:26:57
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for active_executing_flows
-- ----------------------------
DROP TABLE IF EXISTS `active_executing_flows`;
CREATE TABLE `active_executing_flows` (
  `exec_id` int(11) NOT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`exec_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of active_executing_flows
-- ----------------------------

-- ----------------------------
-- Table structure for active_sla
-- ----------------------------
DROP TABLE IF EXISTS `active_sla`;
CREATE TABLE `active_sla` (
  `exec_id` int(11) NOT NULL,
  `job_name` varchar(128) NOT NULL,
  `check_time` bigint(20) NOT NULL,
  `rule` tinyint(4) NOT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `options` longblob NOT NULL,
  PRIMARY KEY (`exec_id`,`job_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of active_sla
-- ----------------------------

-- ----------------------------
-- Table structure for cfg_webank_all_users
-- ----------------------------
DROP TABLE IF EXISTS `cfg_webank_all_users`;
CREATE TABLE `cfg_webank_all_users` (
  `app_id` smallint(5) unsigned NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `urn` varchar(200) DEFAULT NULL,
  `full_name` varchar(200) DEFAULT NULL,
  `display_name` varchar(200) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `employee_number` int(10) unsigned DEFAULT NULL,
  `manager_urn` varchar(200) DEFAULT NULL,
  `manager_user_id` varchar(50) DEFAULT NULL,
  `manager_employee_number` int(10) unsigned DEFAULT NULL,
  `default_group_name` varchar(100) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `department_id` int(10) unsigned DEFAULT '0',
  `department_name` varchar(200) DEFAULT NULL,
  `org_id` int(10) unsigned DEFAULT '0',
  `start_date` varchar(20) DEFAULT NULL,
  `mobile_phone` varchar(50) DEFAULT NULL,
  `is_active` char(1) DEFAULT 'Y',
  `org_hierarchy` varchar(500) DEFAULT NULL,
  `org_hierarchy_depth` tinyint(3) unsigned DEFAULT NULL,
  `person_group` int(1) NOT NULL,
  `created_time` int(10) unsigned DEFAULT NULL COMMENT 'the create time in epoch',
  `modified_time` int(10) unsigned DEFAULT NULL COMMENT 'the modified time in epoch',
  `wh_etl_exec_id` bigint(20) DEFAULT NULL COMMENT 'wherehows etl execution id that modified this record',
  PRIMARY KEY (`user_id`,`app_id`) USING BTREE,
  KEY `email` (`email`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全行用户表';

-- ----------------------------
-- Records of cfg_webank_all_users
-- ----------------------------

-- ----------------------------
-- Table structure for cfg_webank_hrgetmd5
-- ----------------------------
DROP TABLE IF EXISTS `cfg_webank_hrgetmd5`;
CREATE TABLE `cfg_webank_hrgetmd5` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_updated` varchar(35) NOT NULL COMMENT 'ESB数据更新时间',
  `staff_MD5` varchar(200) NOT NULL COMMENT '人员信息MD5',
  `org_MD5` varchar(200) DEFAULT NULL COMMENT '部门信息MD5',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ESB签名（用于查看上面人员和组织数据有无改动）';

-- ----------------------------
-- Records of cfg_webank_hrgetmd5
-- ----------------------------

-- ----------------------------
-- Table structure for cfg_webank_organization
-- ----------------------------
DROP TABLE IF EXISTS `cfg_webank_organization`;
CREATE TABLE `cfg_webank_organization` (
  `dp_id` int(10) unsigned NOT NULL,
  `pid` int(10) DEFAULT NULL COMMENT '父级部门ID',
  `dp_name` varchar(200) NOT NULL COMMENT '英文部门名称',
  `dp_ch_name` varchar(200) NOT NULL COMMENT '中文部门名称',
  `org_id` int(10) unsigned NOT NULL COMMENT '室ID',
  `org_name` varchar(200) DEFAULT NULL COMMENT '室名称',
  `division` varchar(200) NOT NULL COMMENT '部门所属事业条线',
  `group_id` int(11) DEFAULT '1',
  `upload_flag` int(10) DEFAULT '1' COMMENT '部门上传权限',
  PRIMARY KEY (`dp_id`,`org_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全行部门表';

-- ----------------------------
-- Records of cfg_webank_organization
-- ----------------------------
INSERT INTO `cfg_webank_organization` VALUES ('9999999', '100000', '', '临时部门', '9999999', '临时室', 'null', '1', '1');

-- ----------------------------
-- Table structure for data_tag
-- ----------------------------
DROP TABLE IF EXISTS `data_tag`;
CREATE TABLE `data_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(32) DEFAULT NULL COMMENT '标签名',
  `tag_desc` varchar(60) DEFAULT NULL COMMENT '标签描述',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父标签',
  `tag_catalog` int(11) DEFAULT NULL COMMENT '是否是目录',
  `tag_active` int(11) DEFAULT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of data_tag
-- ----------------------------
INSERT INTO `data_tag` VALUES ('1', 'test', '测试', null, null, null);
INSERT INTO `data_tag` VALUES ('2', '目录', '目录', null, '0', '0');
INSERT INTO `data_tag` VALUES ('3', '节点', '节点', '2', '1', '0');
INSERT INTO `data_tag` VALUES ('4', '节点3', '3', '3', '1', null);
INSERT INTO `data_tag` VALUES ('5', '节点4', '4', '4', '1', null);
INSERT INTO `data_tag` VALUES ('6', 'test', '测试', null, '0', null);

-- ----------------------------
-- Table structure for department_group
-- ----------------------------
DROP TABLE IF EXISTS `department_group`;
CREATE TABLE `department_group` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL COMMENT '组名称',
  `description` varchar(256) DEFAULT NULL COMMENT '分组描述',
  `create_time` bigint(20) NOT NULL COMMENT '创建时间',
  `update_time` bigint(20) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门分组信息表';

-- ----------------------------
-- Records of department_group
-- ----------------------------
INSERT INTO `department_group` VALUES ('1', 'default_group', '默认分组(请勿删除)', '1562315302028', '1562315302028');

-- ----------------------------
-- Table structure for department_group_executors
-- ----------------------------
DROP TABLE IF EXISTS `department_group_executors`;
CREATE TABLE `department_group_executors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL COMMENT 'department_group的ID',
  `executor_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `executor_id` (`executor_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='executor分组关系信息表';

-- ----------------------------
-- Records of department_group_executors
-- ----------------------------
INSERT INTO `department_group_executors` VALUES ('1', '1', '1');

-- ----------------------------
-- Table structure for department_maintainer
-- ----------------------------
DROP TABLE IF EXISTS `department_maintainer`;
CREATE TABLE `department_maintainer` (
  `department_id` int(8) NOT NULL COMMENT '部门ID',
  `department_name` varchar(50) NOT NULL COMMENT '部门名称',
  `ops_user` varchar(300) NOT NULL COMMENT '运维人员',
  PRIMARY KEY (`department_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of department_maintainer
-- ----------------------------

-- ----------------------------
-- Table structure for distribute_lock
-- ----------------------------
DROP TABLE IF EXISTS `distribute_lock`;
CREATE TABLE `distribute_lock` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `request_id` varchar(128) NOT NULL COMMENT '线程和uuid',
  `lock_resource` varchar(128) NOT NULL COMMENT '业务主键,要锁住的资源,trigger/flow',
  `lock_count` int(16) NOT NULL DEFAULT '0' COMMENT '当前上锁次数,统计可重入锁',
  `version` int(16) NOT NULL COMMENT '版本,每次更新+1',
  `ip` varchar(45) NOT NULL COMMENT '抢占到所的服务IP',
  `timeout` bigint(20) NOT NULL DEFAULT '0' COMMENT '锁超时时间',
  `create_time` bigint(20) NOT NULL COMMENT '生成时间',
  `update_time` bigint(20) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unq_resource` (`lock_resource`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='分布式锁工具表';

-- ----------------------------
-- Records of distribute_lock
-- ----------------------------

-- ----------------------------
-- Table structure for event_auth
-- ----------------------------
DROP TABLE IF EXISTS `event_auth`;
CREATE TABLE `event_auth` (
  `sender` varchar(45) NOT NULL COMMENT '消息发送者',
  `topic` varchar(45) NOT NULL COMMENT '消息主题',
  `msg_name` varchar(45) NOT NULL COMMENT '消息名称',
  `record_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '插入记录时间',
  `allow_send` int(11) NOT NULL COMMENT '允许发送标志',
  PRIMARY KEY (`sender`,`topic`,`msg_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消息发送授权表';

-- ----------------------------
-- Records of event_auth
-- ----------------------------

-- ----------------------------
-- Table structure for event_notify
-- ----------------------------
DROP TABLE IF EXISTS `event_notify`;
CREATE TABLE `event_notify` (
  `source_pid` int(11) NOT NULL COMMENT '上游工程id',
  `dest_pid` int(11) NOT NULL COMMENT '下游工程id',
  `source_fid` varchar(128) NOT NULL COMMENT '上游flowid',
  `dest_fid` varchar(128) NOT NULL COMMENT '下游flowid',
  `topic` varchar(45) NOT NULL COMMENT '消息主题',
  `msgname` varchar(45) NOT NULL COMMENT '消息名称',
  `sender` varchar(45) NOT NULL COMMENT '消息发送者',
  `receiver` varchar(45) NOT NULL COMMENT '消息接收者',
  `maintainer` varchar(45) NOT NULL COMMENT '消息拥有者'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='信号血缘通知表';

-- ----------------------------
-- Records of event_notify
-- ----------------------------

-- ----------------------------
-- Table structure for event_queue
-- ----------------------------
DROP TABLE IF EXISTS `event_queue`;
CREATE TABLE `event_queue` (
  `msg_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '消息ID号',
  `sender` varchar(45) NOT NULL COMMENT '消息发送者',
  `send_time` datetime NOT NULL COMMENT '消息发送时间',
  `topic` varchar(45) NOT NULL COMMENT '消息主题',
  `msg_name` varchar(45) NOT NULL COMMENT '消息名称',
  `msg` varchar(1000) DEFAULT NULL,
  `send_ip` varchar(45) NOT NULL,
  PRIMARY KEY (`msg_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='azkaban调取系统消息队列表';

-- ----------------------------
-- Records of event_queue
-- ----------------------------

-- ----------------------------
-- Table structure for event_status
-- ----------------------------
DROP TABLE IF EXISTS `event_status`;
CREATE TABLE `event_status` (
  `receiver` varchar(45) NOT NULL COMMENT '消息接收者',
  `receive_time` datetime NOT NULL COMMENT '消息接收时间',
  `topic` varchar(45) NOT NULL COMMENT '消息主题',
  `msg_name` varchar(45) NOT NULL COMMENT '消息名称',
  `msg_id` int(11) NOT NULL COMMENT '消息的最大消费id',
  PRIMARY KEY (`receiver`,`topic`,`msg_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消息消费状态表';

-- ----------------------------
-- Records of event_status
-- ----------------------------

-- ----------------------------
-- Table structure for execution_cycle_flows
-- ----------------------------
DROP TABLE IF EXISTS `execution_cycle_flows`;
CREATE TABLE `execution_cycle_flows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) DEFAULT NULL,
  `now_exec_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `submit_user` varchar(64) DEFAULT NULL,
  `submit_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `start_time` bigint(20) DEFAULT NULL,
  `end_time` bigint(20) DEFAULT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `data` longblob,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of execution_cycle_flows
-- ----------------------------

-- ----------------------------
-- Table structure for execution_dependencies
-- ----------------------------
DROP TABLE IF EXISTS `execution_dependencies`;
CREATE TABLE `execution_dependencies` (
  `trigger_instance_id` varchar(64) NOT NULL,
  `dep_name` varchar(128) NOT NULL,
  `starttime` bigint(20) NOT NULL,
  `endtime` bigint(20) DEFAULT NULL,
  `dep_status` tinyint(4) NOT NULL,
  `cancelleation_cause` tinyint(4) NOT NULL,
  `project_id` int(11) NOT NULL,
  `project_version` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `flow_version` int(11) NOT NULL,
  `flow_exec_id` int(11) NOT NULL,
  PRIMARY KEY (`trigger_instance_id`,`dep_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of execution_dependencies
-- ----------------------------

-- ----------------------------
-- Table structure for execution_flows
-- ----------------------------
DROP TABLE IF EXISTS `execution_flows`;
CREATE TABLE `execution_flows` (
  `exec_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `submit_user` varchar(64) DEFAULT NULL,
  `submit_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `start_time` bigint(20) DEFAULT NULL,
  `end_time` bigint(20) DEFAULT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `flow_data` longblob,
  `executor_id` int(11) DEFAULT NULL,
  `flow_type` tinyint(1) DEFAULT NULL,
  `repeat_id` varchar(128) DEFAULT NULL,
  `use_executor` int(11) DEFAULT NULL,
  PRIMARY KEY (`exec_id`) USING BTREE,
  KEY `ex_flows_start_time` (`start_time`) USING BTREE,
  KEY `ex_flows_end_time` (`end_time`) USING BTREE,
  KEY `ex_flows_time_range` (`start_time`,`end_time`) USING BTREE,
  KEY `ex_flows_flows` (`project_id`,`flow_id`) USING BTREE,
  KEY `executor_id` (`executor_id`) USING BTREE,
  KEY `ex_flows_staus` (`status`) USING BTREE,
  KEY `ex_pro_flows_stime` (`project_id`,`flow_id`,`start_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of execution_flows
-- ----------------------------
INSERT INTO `execution_flows` VALUES ('1', '2', '1', 'hdfs_to_mysql', '70', 'superadmin', '1628473110172', '1628473111238', '1628473110854', '1628473111224', '2', 0x1F8B0800000000000000C597DF6EDB3614C6DF85D74627296E62FBCE4DECCD83670773D75E0C81418BC70B1B4A54492AA91BE46A0FD157E80314451F6818D0B7180FF5C7922C1BCE666037412492E77CE7773E52F42351697C450D900109BCC0F77A5E8F74087C8030355CC6F304FF6A3278246BCA45AA6018E21B3B7D3C994D163F2D87D3E9F27ABE584C5E4D4776650491549BCB5B08EFC8C0A8143AE47D0A294CE11E0419781D92F004048F6164734C1819C4A9101D12CA384C9582D864296D027DC7131B319686AF37F378CC9536E34C4411BA189BD2CAD09A0A0DDB3C79E62C8D4EC310B41E4576B29EDF83529C6D97E42566A364F0FB4D8730AEE94A00CB9ED6423E5C53452330A090CA532364360DFFBD54408D54B60E066B9A0A431AF11BD96D24FAF18EAE683CB649DED8F08E82FFC222339B048A0AA8311025C6A14C35A86B25935C49ACDF1AAD0B36DA50655EF3C8AEF4CF835EF7E2CCB7ED7DD9ED106169FD22195F7360BFD910C83A4D405116F1D8CAE46557B05EEC11B9656BBD3472196DF47B511A44AA09C3927D5BF33BB99AA72649CD8F42AEA870943259793ACC5695E307FD8B20E867E3B39A744C8BED04F62B18B5C9C2C8D4A0D44C589A306BDA46757E70D6734E62DC7937FE59AE16869AD40626548865DE2AAB5F9A5B5015735BF50B6BB72C69F91E7B4905288394AE20A12AB206B5C1FEFAF6E5EF4F5FBFFFF9F9FBA7CFA4B4C010A7E6762393D9784E1C964A25B5C8C586DA59658BBD2FFB5FD98CD7D4DCDA39E5B3FEC1B7191424D669DB5A9E2A2BB0777E9527168966CE0D5FB22AB8C69201CA7BDC1DAAF1475E32552134BDF1C28E9076F3F97EAFBBAF736E88B73A2D66AD938F6A73B671ECDC28A23123F5DDC3E3595E2D610F067352EBE61B273E0B76399C5D8EA6D3D1956DC9BF2122995E0AF9C701265EBFEBEF61E2F57BFD06933C5E2B15AF7FDE3F0595B2F8F1708295BB324B50A8C00A610F6CE9CA71726E90CE5E185BB639873D0E380F4EDED45CABC1A656ABA87BECA6651FB4FB1725BA8654FCD2EE509CB9C7467B4155D8B2D56156DE495A5D615575185B3579A124A74C3F039657B8B756D71E5E38F9B9BCB6AA0EC30A8EFD281C0BAB5950FBA66822AC9AF14884A83CF75BD980767E38F3F9FC0A4987F9755F9E7C6356ED54A7543D878FA484FA724A25E3764A38F3B994EA3BE32029AF777E6252EE80C2ECA8A209AB6EC3A37939953B9F957D3BD3CDFECF1FC45A1D873F87FDBD9FC37E71A0D4A9FC7F1FC3E6A179ECE95E1E1287DD7476EA5B4EF31A718253DE896C9EF2DB43B0DD52B8A6CD5278F54A5711DF71857F1114436DBF575A720401E610B476E14E947C07A199519C4B0C681390F22D5E9503F7F46183493262944999906CADCD6838E4B1C24D28A076E9DEF50A5EBB5FBBDE784FFF00B347D5B1690F0000, '1', '0', null, null);

-- ----------------------------
-- Table structure for execution_jobs
-- ----------------------------
DROP TABLE IF EXISTS `execution_jobs`;
CREATE TABLE `execution_jobs` (
  `exec_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `job_id` varchar(128) CHARACTER SET latin1 NOT NULL,
  `attempt` int(3) NOT NULL,
  `start_time` bigint(20) DEFAULT NULL,
  `end_time` bigint(20) DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `input_params` longblob,
  `output_params` longblob,
  `attachments` longblob,
  PRIMARY KEY (`exec_id`,`job_id`,`flow_id`,`attempt`) USING BTREE,
  KEY `ex_job_id` (`project_id`,`job_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of execution_jobs
-- ----------------------------
INSERT INTO `execution_jobs` VALUES ('1', '2', '1', 'hdfs_to_mysql', 'hdfs_to_ods_log', '0', '1628473110941', '1628473110969', '70', 0x1F8B08000000000000008D524D739B3010FD2B1D4D6F3520C0B1815B8E3DB777CF222941893EA83EDA128FFF7B57D8493D06CFE4C208EDDBF7DE6ADF918CE08409A43B126FA3638274262AB521A3B3A34FD7F0F60A3D98FC49D93FB90FE042AEA552D20B660D470869CA8A6CD670930087F58A56E53A20482DDEAC4151F2E825143F0630CF03C85B349A79112C489ED8D6A9CE76B05ED30520F65A86E84532E3E3281C702DCD1D91DFC279690D42EF98C6D61892E5BAB90588BF82CD2617AD1772033A7506E1C39D39B4356140085D909FEB036E2995DBDB728CB332F09652D1EF335E362CDBEEAA6DD6F7F54306EC41ECF6943575CD6E5BD3676E1EF8933F047BD093FFA5D6F5394CABF2970115F8C0D21605EFA7CF3CF7550387F959CB5DD56CF765D5EEAB6A21F33F3778D2E3255D196D32DAFEA46D57375D4D734CE437DA749492D369F3116C92D613032ED71765F13EABE5FEA0EC73FE627B7215FB598DCBF4D6058C23B3BAF86E5053A9E2F16CE8FDF79A1519C234262D6CD08081DC7C9C90287A57F4D22CB4FDF0E5EB9187D3D5B45A68EBA69C0D82BDA6C4B82870987FB909B53CB0030000, null, null);
INSERT INTO `execution_jobs` VALUES ('1', '2', '1', 'hdfs_to_mysql', 'mysql_to_hdfs', '0', '1628473110949', '1628473110969', '70', 0x1F8B08000000000000008D524D739B3010FD2B194D6F3520C0B1815B8E3DA7F78C903645893EA83ED2108FFF7B56D84D3D18CFF4C208EDDBF7DE6ADF818CCC8109A43B106FA3E3403A1395DA90D1D9D1A76BF6F1CA7A66F26765FFE43E3017722D95921EB8350221A4292BB259C34DC01CD62B5A95EB8020357C5883A2E4C14B563C0ECCFC1A985CA2D1CC0BF02045625BA73AD9C17A4DAF00B1D732440FC98C8F233826B4343744DEC079690D426F98C6D61892E5BA5902E01DF86CF2AAF54C6E984E9D017CB83187B6260C08A157E4A7FA805B4AE576598E715666A2A514FA7D26CA8667DB5DB5CDFABEBECF18BF87DD9EF2A6AEF9B2357DE6E6413CFBA7609FF4E47FAB757DC1A655F9F3808AF9C0D31641F4D3FF3CF7458360F3B396BBAAD9EECBAADD57D595CCBFDCE0498FE77465B4C968FB93B65DDD7435CD3191DF69D3514A8EC7CD57B0495A4F0CB85C5F94C53C631A360D9DBFD89E5C847ED61232BD74C1C6915B5DFC30A8A854F170B2F3F7F7921319C23426256CD00CE3B8F93A2151F4AEE8A55928FBE10E79EEBE1D44385E4CAB415B37E57C00FE9A12E322E0309F2EC369F4B0030000, null, null);

-- ----------------------------
-- Table structure for execution_logs
-- ----------------------------
DROP TABLE IF EXISTS `execution_logs`;
CREATE TABLE `execution_logs` (
  `exec_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `attempt` int(11) NOT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `start_byte` int(11) NOT NULL,
  `end_byte` int(11) DEFAULT NULL,
  `log` longblob,
  `upload_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`exec_id`,`name`,`attempt`,`start_byte`) USING BTREE,
  KEY `ex_log_attempt` (`exec_id`,`name`,`attempt`) USING BTREE,
  KEY `ex_log_index` (`exec_id`,`name`) USING BTREE,
  KEY `ex_log_upload_time` (`upload_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of execution_logs
-- ----------------------------
INSERT INTO `execution_logs` VALUES ('1', '', '0', '2', '0', '7375', 0x1F8B0800000000000000ED59416F1B4514BEF32BDE2D97C4F13A11A4BE594E0CAE2253C5451542C81AEF8CE36976679699D998142195AAAA44101288031237240427385640E1DFD44D7F066F66BD4ED6314E26DE3441428A0FD99DFDDE7BDFF7CD9B99DDEA9DB5EAD65AAD5A0BA07AA7BEB155DFA842B37B1F8674A07B46F6E223FD4904ED4EEB7D588350316218B04F59981AA9BA4C1DF29055DC8536AD076F5597476B49D51CB2F080295D12F03DC5A5E2E668C9745BCC84432EF6E1A1EC031114F490284621513261CA70A62B7E80423F305AD7C1A894ADC22092A37B4491B833B92CD2289A5CC6081D3DB257EDC54B4679D0D8EBD828D2008F9388C54C18CF0C1B5AF37D8135E654421D746C36EB416DA3E649DF5E2A8465CF427124DF55562F0E452A1FB2D0D46B7088F273297C35FA20A1C4D8285C70C349E48200E50A51A53AF22CBF6B8872681645FB3DDB279AB56CF09912576786E7B4B844570AF7563CD36D4A31E0FBA9B2708D4707A44F04C4CC281E6AF418090F5C1C14110DAC302C5320FB966F4F56D27ECC8DC967C2346749752F92FB2B602420BC67F2BB1273E311838498619E651D66C081E3C458274912CA78BD2DB42151B43EA935FF37F32A9A47AF07EB3D44A9049519980AFEFE13DCBA9B76941D7D45669BAE1BD28C5DA48E098AD94D729D25B814D10A595F55B202C815045B587501DC0FF82E3EEE1A03A3E7ECE98744225C366C3A9623F8E863979920313B6FFB04571A61B22651C05A22F7253858907951FB92F2EE4820C69070183B342BE9BFF81746B8D21BE63B4716042816B4003E58B0214995E38184861F3230433427D5B89856FD7006B8ACE921BA5A487ADE257E5877E79037C51F719CCF38374DAAA1D568EFEE6CE38A0A55D02C9482CE73CB8248DDDD068C7FFBE1D5F7CF5FBE78313EFE71FCEDF1EB5F7F1EFFF4F4E49B67E3BF1E8F7FF96A75FCF777E32FBF7E7DFCE4E4C91F27C7CF5F3DFEE2E5EF7FC2679F4F827BC66359072DDEC4DE9981F55AED4EBBFB5EBBF3AE1F2C6549C7D23E4B5A46537DCA93DE66AEDB08137171D02268269C6D031269E61710D71CCA6D5704FCB356CC2361CBECE9340C9976F38F1D922875CD0E6B74719C796D7E084947B4A7ED9CF7B78819227A367789863E63020E7884E500C2D3BC4AB0659E8E18B88257B387ED72302F0F345814E178088908198EF764C63D15599157E6C1AF004D996523B15B7F604A493577777E09B9CFE0D35309F6761ADB1F96A8F53575888B7AFC05FDA1D8FBFEEF0E97B04B91B2DBDA1BCEF630DABF89AE50CCA0C47E50042EB313CCA49C33DE6C749A3BBB0BE4B5E7FB9BEAFC37236EB1675E4BAF2F57DAF94DFE1A949D13F07451BCBD8EB279BA743D9B7B39763A8D5EA2974E41CB34D299546FB39A13F3CD7B3BF106D4CCA397AA660E5AAE9AD3546FB39AC64212DF8D57596AE6D14B5533072D57CD69AAB757CD8BDE92BCB18D59065DFEBE2C7BB5BD8CAC930F1B85F7C3D91D2CC17EEE702C33CDA8A751F2A3C1BC77F1F979677A5058E2C8D37207291B294D5CB00A344684BBD8F7998AB920D640570145B1ED57073F262FFC447409CED05C60789C99D8111858AE82B76B5B9BEF6C044150AB6DFA21EB616AA81C09B4667E208644CA6875D161F91FE22CC834CF1C0000, '1628473111228');
INSERT INTO `execution_logs` VALUES ('1', 'hdfs_to_ods_log', '0', '2', '0', '2124', 0x1F8B0800000000000000AD95CF6FD33014C7CFF4AFF0814327112B69BAB68904136CADD8B4B1A9FBC1619A2AA771DB6CA91D1CA75B3970E00412D238808404974993401C2A6E08D0E09F19DDF65FF09CB690752BB46C87AA8EEDF7F93EBFE7F7AC5B9A5ED0327AC640BA659B05DBD4D1ECEA1A6AB8B5B0227985BB61C5E77534FFA0B48C34B42A89901EABA36DEE5CD8432432729942366F1A866E658D943E195C311736961011F5D046DA1C79BC431CC270CDE7BB9E7B7B60D56C878FFCC432DDA35558361253404A18F4652675270AA9C092E340F0BD36FAB9FFB4FBFA53F7DDC7D3CEF793A3CE2D74F6EDCD69E7F0F8E8C7C9AB0F67075F4EDE76BAFB2F8FBF1EC267F7D9E7EEF3F7A7072F5018055410B7E9B149D5EF459EEFAA485779B349981B47471D35925C603436AE582E2F978157229E4F5D24397214F91C0ED5E07749466779043B1997A8E681072D223CE2F8144EE584D29391F4388B6D072BE9700A6DF61DD6EEB872EB5ADC94ED80A612A955DF78813B6BF0BF4418A95351DCABD240B963FFD7415337E0EEFE5D01C734982BF659E9A1F56DD222B699CF4EA1279B7D94A642C199A6E369ACC30661CF6C9D93527E91205052E58831A004820644509848FF998CD139CB84E00EC8CA52830BDAA26212FC763CBA0FE981640D0958F9CCD5055C0E8361F2B4790DAE8B8BDCACA58FCB55FB315C581F5739AB46425026F15A4350E2AE70EE0F92AA541E72B14345FA92C558D430B216A8CED8062E60BD9231321329DCECE1E3E38C92C865B223157CC2EA7D6C82D1B3CB670BC376B304DA988B9CB6FD3BB4CAC710AF3397425553774570E851B29D28A16BA8FB642E7B824A275C8F878286DC6FD18DBE7599063EA9D226042C9DD8151F093A47AFA0A096041D7D5F4669C43317A846CE1C8B7AA556306DFEB315608C511E35C187891B254822C83FAAF5DA5DAF6FA8F74236A86A7178D207A7E4312F6C8CF7B6E72CB4EBC9060A259151884A77E7178B73A95FAE2096704C080000, '1628473110978');
INSERT INTO `execution_logs` VALUES ('1', 'mysql_to_hdfs', '0', '2', '0', '2098', 0x1F8B0800000000000000AD95CD6E133110C7CFE4297CE0904AACB51F69925D092A6813D18AD22AFDE050559537EB24DB6EECC5EB4D130E1C388184540E2021C1A552251087881B0254789992B66FC17893429A12C8D21EA278C79EDF7F3C638F755BD38B9AA99B06D26DC72A3A968E66575651B3133D0CB624DF6A78B508CDDF2F2F210DAD4822A4CFEA689BBB232B884446DE2CE60A9661E876CECEE869C08AB7B0BE8888A8470ED2E6C8A31DE212866B01DFF5BD9B6AA972497C87A6699B5661DA183201092CE744D28512475460C9712878BB837EEC3DE9BDFAD87BFBE1A4FBEDF8B07B039D7E7D7DD23D383AFC7EFCF2FDE9FEE7E337DDDEDE8BA32F07F0D97BFAA9F7ECDDC9FE7314C52115C46BFA2C9DF69DD80F3C95DF2A6F3609F392BCA84DC6920B8C2684952A95A50AD0CAC40FA8872447AEE29E83A11AFC2E547196C7B08E71896A3EA8B788F0891B50D88F1B495FC6D2E72CF13C9BC94653686310AC76CB939B5710A2EC843433544EF58D17B8BB0AFF8B84913A15A57695862A18E73F3699B90667F5EF7C9CB0C0561A90B223F3DBA4451CAB909B428F3706284DA581334DC7D3588705C299D93C27A5A22261A8A42A31634009050D89A060C8FE3626E8BC6D4162CFC8CA538363D9A2220D7E3B19DD85D240A14604EC827979018FC360943C6D5D41E8E2223767EB9372D57A0C8735C055CEAAB1109449BCDA109478CB9C076745552A0FB8D8A122FB87C944D4307236A8CE38062E627DCB34CC540AD7FBF8643BE324F2666EAC4240587D801D62F4FD0AB9E2A8DF2C81E6E521B7E3FC4AAD8A31C26BCCA370A3A9B72C387426D919BA405770E7876BD917543AD15A321434E2418BAE0FBC2B340C4895362161D9A155C996A06BF42F14DC2541C79F97711A89E502D5C85B13512FD50AA6AD7FB6028C312AA026C490B249822082EAA35ABFD5F5BB867A256483AAF686D33D32659FF9516392573C6FA35D5F365024898C2354BE3D7FAF3497F909004234BD32080000, '1628473110978');

-- ----------------------------
-- Table structure for execution_recover_flows
-- ----------------------------
DROP TABLE IF EXISTS `execution_recover_flows`;
CREATE TABLE `execution_recover_flows` (
  `recover_id` int(11) NOT NULL AUTO_INCREMENT,
  `recover_status` tinyint(4) DEFAULT NULL,
  `recover_start_time` bigint(20) DEFAULT NULL,
  `recover_end_time` bigint(20) DEFAULT NULL,
  `ex_interval` varchar(64) DEFAULT NULL,
  `now_exec_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `submit_user` varchar(64) DEFAULT NULL,
  `submit_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `start_time` bigint(20) DEFAULT NULL,
  `end_time` bigint(20) DEFAULT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `recover_data` longblob,
  PRIMARY KEY (`recover_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of execution_recover_flows
-- ----------------------------

-- ----------------------------
-- Table structure for executor_events
-- ----------------------------
DROP TABLE IF EXISTS `executor_events`;
CREATE TABLE `executor_events` (
  `executor_id` int(11) NOT NULL,
  `event_type` tinyint(4) NOT NULL,
  `event_time` datetime DEFAULT NULL,
  `username` varchar(64) DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL,
  KEY `executor_log` (`executor_id`,`event_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of executor_events
-- ----------------------------

-- ----------------------------
-- Table structure for executors
-- ----------------------------
DROP TABLE IF EXISTS `executors`;
CREATE TABLE `executors` (
  `id` int(11) NOT NULL,
  `host` varchar(64) NOT NULL,
  `port` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `host` (`host`,`port`) USING BTREE,
  UNIQUE KEY `executor_id` (`id`) USING BTREE,
  KEY `executor_connection` (`host`,`port`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of executors
-- ----------------------------
INSERT INTO `executors` VALUES ('1', 'smt4', '12321', '1');

-- ----------------------------
-- Table structure for job_group
-- ----------------------------
DROP TABLE IF EXISTS `job_group`;
CREATE TABLE `job_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(64) NOT NULL COMMENT '执行器AppName',
  `title` varchar(32) NOT NULL COMMENT '执行器名称',
  `order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `address_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '执行器地址类型：0=自动注册、1=手动录入',
  `address_list` varchar(512) DEFAULT NULL COMMENT '执行器地址列表，多地址逗号分隔',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_group
-- ----------------------------
INSERT INTO `job_group` VALUES ('1', 'flinkx-executor', 'flinkx执行器', '1', '0', null);

-- ----------------------------
-- Table structure for job_info
-- ----------------------------
DROP TABLE IF EXISTS `job_info`;
CREATE TABLE `job_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_group` int(11) NOT NULL COMMENT '执行器主键ID',
  `job_cron` varchar(128) NOT NULL COMMENT '任务执行CRON',
  `job_desc` varchar(255) NOT NULL,
  `project_id` int(11) DEFAULT NULL COMMENT '所属项目id',
  `add_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL COMMENT '修改用户',
  `alarm_email` varchar(255) DEFAULT NULL COMMENT '报警邮件',
  `executor_route_strategy` varchar(50) DEFAULT NULL COMMENT '执行器路由策略',
  `executor_handler` varchar(255) DEFAULT NULL COMMENT '执行器任务handler',
  `executor_param` varchar(512) DEFAULT NULL COMMENT '执行器任务参数',
  `executor_block_strategy` varchar(50) DEFAULT NULL COMMENT '阻塞处理策略',
  `executor_timeout` int(11) NOT NULL DEFAULT '0' COMMENT '任务执行超时时间，单位分钟',
  `executor_fail_retry_count` int(11) NOT NULL DEFAULT '0' COMMENT '失败重试次数',
  `glue_type` varchar(50) NOT NULL COMMENT 'GLUE类型',
  `glue_source` mediumtext COMMENT 'GLUE源代码',
  `glue_remark` varchar(128) DEFAULT NULL COMMENT 'GLUE备注',
  `glue_updatetime` datetime DEFAULT NULL COMMENT 'GLUE更新时间',
  `child_jobid` varchar(255) DEFAULT NULL COMMENT '子任务ID，多个逗号分隔',
  `trigger_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '调度状态：0-停止，1-运行',
  `trigger_last_time` bigint(13) NOT NULL DEFAULT '0' COMMENT '上次调度时间',
  `trigger_next_time` bigint(13) NOT NULL DEFAULT '0' COMMENT '下次调度时间',
  `job_json` text COMMENT 'flinkx运行脚本',
  `replace_param` varchar(100) DEFAULT NULL COMMENT '动态参数',
  `jvm_param` varchar(200) DEFAULT NULL COMMENT 'jvm参数',
  `inc_start_time` datetime DEFAULT NULL COMMENT '增量初始时间',
  `partition_info` varchar(100) DEFAULT NULL COMMENT '分区信息',
  `last_handle_code` int(11) DEFAULT '0' COMMENT '最近一次执行状态',
  `replace_param_type` varchar(255) DEFAULT NULL COMMENT '增量时间格式',
  `reader_table` varchar(255) DEFAULT NULL COMMENT 'reader表名称',
  `primary_key` varchar(50) DEFAULT NULL COMMENT '增量表主键',
  `inc_start_id` varchar(20) DEFAULT NULL COMMENT '增量初始id',
  `increment_type` tinyint(4) DEFAULT '0' COMMENT '增量类型',
  `datasource_id` bigint(11) DEFAULT NULL COMMENT '数据源id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_info
-- ----------------------------

-- ----------------------------
-- Table structure for job_jdbc_datasource
-- ----------------------------
DROP TABLE IF EXISTS `job_jdbc_datasource`;
CREATE TABLE `job_jdbc_datasource` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `datasource_name` varchar(200) NOT NULL COMMENT '数据源名称',
  `datasource` varchar(45) NOT NULL COMMENT '数据源',
  `datasource_group` varchar(200) DEFAULT 'Default' COMMENT '数据源分组',
  `database_name` varchar(45) DEFAULT NULL COMMENT '数据库名',
  `jdbc_username` varchar(100) DEFAULT NULL COMMENT '用户名',
  `jdbc_password` varchar(200) DEFAULT NULL COMMENT '密码',
  `jdbc_url` varchar(500) DEFAULT NULL COMMENT 'jdbc url',
  `jdbc_driver_class` varchar(200) DEFAULT NULL COMMENT 'jdbc驱动类',
  `zk_adress` varchar(200) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0删除 1启用 2禁用',
  `create_by` varchar(20) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) DEFAULT NULL COMMENT '更新人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `comments` varchar(1000) DEFAULT NULL COMMENT '备注',
  `broker_ips` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='jdbc数据源配置';

-- ----------------------------
-- Records of job_jdbc_datasource
-- ----------------------------
INSERT INTO `job_jdbc_datasource` VALUES ('2', 'mysqlTest', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.8.124:3308/test?useUnicode=true&characterEncoding=utf-8&autoReconnect=true&useSSL=false&serverTimezone=Asia/Shanghai', null, null, '0', null, null, null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('3', 'kafkaTest', 'kafka', 'Default', 'nbTest2', null, null, null, null, '172.18.8.172:2181/kafka', '1', null, null, null, null, '[{\"name\":\"after_event_id\",\"type\":\"int\",\"desc\":\"\"},{\"name\":\"after_id\",\"type\":\"varchar\",\"desc\":\"\"},{\"name\":\"after_buy_id\",\"type\":\"varchar\",\"desc\":\"\"},{\"name\":\"after_goods_type\",\"type\":\"varchar\",\"desc\":\"\"},{\"name\":\"after_pay_time\",\"type\":\"bigint\",\"desc\":\"\"},{\"name\":\"after_buy_amount\",\"type\":\"double\",\"desc\":\"\"},{\"name\":\"after_but_way\",\"type\":\"\",\"desc\":\"varchar\"}]', 'demo.vision.software.dc:9092');
INSERT INTO `job_jdbc_datasource` VALUES ('4', 'demo', 'kafka', 'Default', null, null, null, null, null, '172.18.8.172:2181/kafka', '1', null, null, null, null, ' [{\"name\":\"cameraId\",\"type\":\"varchar\",\"desc\":\"\"},{\"name\":\"cameraName\",\"type\":\"varchar\",\"desc\":\"\"}]', 'demo.vision.software.dc:9092');
INSERT INTO `job_jdbc_datasource` VALUES ('5', 'json嵌套', 'kafka', 'Default', null, null, null, null, null, '172.18.8.172:2181/kafka', '1', null, null, null, null, ' [{\"name\":\"cameraId\",\"type\":\"varchar\",\"desc\":\"\"},{\"name\":\"cameraName\",\"type\":\"varchar\",\"desc\":\"\"},{\"name\":\"result\",\"type\":\"ARRAY<ROW<carImage STRING>>\",\"desc\":\"\"}]', 'demo.vision.software.dc:9092');
INSERT INTO `job_jdbc_datasource` VALUES ('6', 'kafkaTest', 'kafka', 'Default', 'nbTest2', null, null, null, null, '172.18.8.172:2181/kafka', '0', null, '2021-08-24 11:15:54', null, null, '{\"name\":\"after_but_way\",\"type\":\"\",\"desc\":\"varchar\"}]', null);
INSERT INTO `job_jdbc_datasource` VALUES ('7', 'kafkatest2', 'kafka', 'Default', 'nbTest2', null, null, null, null, '172.18.8.172:2181/kafka', '1', null, '2021-08-24 15:32:43', null, null, ' [{\"name\":\"cameraId\",\"type\":\"varchar\",\"desc\":\"\"},{\"name\":\"cameraName\",\"type\":\"varchar\",\"desc\":\"\"},{\"name\":\"result\",\"type\":\"ARRAY<ROW<carImage STRING>>\",\"desc\":\"\"}]', null);
INSERT INTO `job_jdbc_datasource` VALUES ('8', 'source', 'kafka11', 'Default', null, null, null, null, null, null, '1', null, null, null, null, '[{\"name\":\"a.id[0]\",\"type\":\"int\",\"desc\":\"id\"},{\"name\":\"b\",\"type\":\"varchar\",\"desc\":\"\"}]', 'demo.vision.software.dc:9092');
INSERT INTO `job_jdbc_datasource` VALUES ('9', 'side', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.8.124:3308/test?useUnicode=true&characterEncoding=utf-8&autoReconnect=true&useSSL=false&serverTimezone=Asia/Shanghai', null, null, '0', null, null, null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('10', 'sinkz', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.8.124:3309/test?useUnicode=true&characterEncoding=utf-8&autoReconnect=true&useSSL=false&serverTimezone=Asia/Shanghai', null, null, '1', null, null, null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('11', 'mysql-binlog', 'mysql', 'Default', 'binlog_db', 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db?useUnicode=true&characterEncoding=utf-8&autoReconnect=true&useSSL=false&serverTimezone=Asia/Shanghai', null, null, '0', null, null, null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('12', '154test', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db', 'com.mysql.jdbc.Driver', null, '0', null, null, null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('18', '卡夫123', 'kafka', 'Default', null, null, null, null, null, null, '0', null, '2021-08-27 17:15:50', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('19', '123456', 'kafka', 'Default', null, null, null, null, null, '111111', '1', null, '2021-08-30 15:22:02', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('20', 'oooooppp', 'kafka', 'Default', null, null, null, null, null, '222', '1', null, '2021-08-30 15:23:46', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('21', '妹妹', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db', null, null, '0', null, '2021-08-30 15:26:18', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('22', 'well', 'mysql', 'Default', null, '', '', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-08-30 15:33:30', null, null, '', null);
INSERT INTO `job_jdbc_datasource` VALUES ('23', 'well', 'mysql', 'Default', null, '', '', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-08-30 15:34:54', null, null, '', null);
INSERT INTO `job_jdbc_datasource` VALUES ('24', 'well', 'mysql', 'Default', null, '', '', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-08-30 15:36:23', null, null, '', null);
INSERT INTO `job_jdbc_datasource` VALUES ('25', 'well2', 'mysql', 'Default', null, '', '', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-08-30 15:41:23', null, null, '', null);
INSERT INTO `job_jdbc_datasource` VALUES ('26', 'gg is smd ', 'kafka', 'Default', null, null, null, null, null, null, '1', null, '2021-08-30 17:54:35', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('27', 'hhhhh', 'kafka', 'Default', null, null, null, null, null, null, '1', null, '2021-08-31 08:25:14', null, null, '', 'kafka');
INSERT INTO `job_jdbc_datasource` VALUES ('28', '154test', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db', 'com.mysql.jdbc.Driver', null, '1', null, '2021-08-31 16:18:34', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('29', '154test', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db', 'com.mysql.jdbc.Driver', null, '1', null, '2021-08-31 16:18:49', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('30', '154test', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db', 'com.mysql.jdbc.Driver', null, '1', null, '2021-08-31 16:18:53', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('31', '154data', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-02 08:15:55', null, null, '', null);
INSERT INTO `job_jdbc_datasource` VALUES ('32', 'gg is smd', 'kafka', 'Default', null, null, null, null, null, null, '0', null, '2021-09-02 09:16:35', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('33', 'gg is smd', 'kafka', 'Default', null, null, null, null, null, null, '1', null, '2021-09-02 09:21:14', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('34', 'well-ms', 'mysql', 'Default', null, 'well', '123456', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '1', null, '2021-09-02 09:49:26', null, null, '', null);
INSERT INTO `job_jdbc_datasource` VALUES ('35', '222222222222222222222222222', 'mysql', 'string', 'string', 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/db-record', 'com.mysql.jdbc.Driver', 'string', '1', null, '2021-09-02 11:52:25', null, null, 'string', 'string');
INSERT INTO `job_jdbc_datasource` VALUES ('36', '124mysql', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.8.124:3308/test?charset=utf8', 'com.mysql.jdbc.Driver', null, '1', null, '2021-09-04 09:13:41', null, null, '', null);
INSERT INTO `job_jdbc_datasource` VALUES ('37', 'test5', 'kafka', 'Default', null, null, null, null, null, '172.18.8.172:2181/kafka', '1', null, '2021-09-06 09:30:11', null, null, '测试5', 'demo.vision.software.dc:9092');
INSERT INTO `job_jdbc_datasource` VALUES ('38', 'test6', 'kafka', 'Default', null, null, null, null, null, '172.18.8.172:2181/kafka', '0', null, '2021-09-06 09:32:11', null, null, '测试6', 'demo.vision.software.dc:9092');
INSERT INTO `job_jdbc_datasource` VALUES ('39', '222222222222222222222222222', 'mysql', 'string', 'string', 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/db-record', 'com.mysql.jdbc.Driver', 'string', '0', null, '2021-09-06 11:21:17', null, null, 'string', 'string');
INSERT INTO `job_jdbc_datasource` VALUES ('40', '154test1', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db', 'com.mysql.jdbc.Driver', null, '1', null, '2021-09-06 11:48:36', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('41', '154test12', 'mysql', 'Default', null, 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/binlog_db', 'com.mysql.jdbc.Driver', null, '1', null, '2021-09-06 11:49:03', null, null, null, null);
INSERT INTO `job_jdbc_datasource` VALUES ('42', '2222222222222222222222222223333333333333333', 'mysql', 'string', 'string', 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/db-record', 'com.mysql.jdbc.Driver', 'string', '0', null, '2021-09-06 14:42:58', null, null, 'string', 'string');
INSERT INTO `job_jdbc_datasource` VALUES ('43', '222222222222222222222222222333333333333333', 'mysql', 'string', 'string', 'root', '123456', 'jdbc:mysql://172.18.42.154:3306/db-record', 'com.mysql.jdbc.Driver', 'string', '0', null, '2021-09-06 14:46:39', null, null, 'string', 'string');
INSERT INTO `job_jdbc_datasource` VALUES ('44', '333333333333333333333', 'mysql', 'Default', null, '3333', '123456', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 14:47:51', null, null, '3333', null);
INSERT INTO `job_jdbc_datasource` VALUES ('45', '3333333', 'mysql', 'Default', null, '333', '123456', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 14:48:51', null, null, '3333', null);
INSERT INTO `job_jdbc_datasource` VALUES ('46', '33333334444', 'mysql', 'Default', null, '333', '123456', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 14:49:27', null, null, '3333', null);
INSERT INTO `job_jdbc_datasource` VALUES ('47', '444444444', 'mysql', 'Default', null, '444', '444444', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 14:52:17', null, null, '444', null);
INSERT INTO `job_jdbc_datasource` VALUES ('48', '44444444455555', 'mysql', 'Default', null, '444', '444444', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 14:52:34', null, null, '444', null);
INSERT INTO `job_jdbc_datasource` VALUES ('49', '444444444', 'mysql', 'Default', null, '444', '444444', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 14:53:38', null, null, '444444', null);
INSERT INTO `job_jdbc_datasource` VALUES ('50', '555555555555555', 'mysql', 'Default', null, '444', '444444', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 14:53:50', null, null, '444444', null);
INSERT INTO `job_jdbc_datasource` VALUES ('51', '4444444444444', 'mysql', 'Default', null, '4444', '44444', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 15:03:00', null, null, '4444', null);
INSERT INTO `job_jdbc_datasource` VALUES ('52', '4444', 'mysql', 'Default', null, '44444', '444', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 15:03:29', null, null, '4444', null);
INSERT INTO `job_jdbc_datasource` VALUES ('53', '55555555', 'mysql', 'Default', null, '4444', '444', 'jdbc:mysql://{host}:{port}/{database}', 'com.mysql.jdbc.Driver', null, '0', null, '2021-09-06 15:07:31', null, null, '4444', null);
INSERT INTO `job_jdbc_datasource` VALUES ('54', '7777', 'hbase', 'Default', null, null, null, null, null, '172.18.8.172:2181/hbase', '0', null, '2021-09-06 15:09:46', null, null, '666666', null);
INSERT INTO `job_jdbc_datasource` VALUES ('55', '6', 'mongodb', 'Default', '6', null, null, 'mongodb://[username:password@]host1[:port1][,...hostN[:portN]]][/[database][?options]]', null, null, '0', null, '2021-09-06 15:10:27', null, null, '6', null);
INSERT INTO `job_jdbc_datasource` VALUES ('56', '9999', 'clickhouse', 'Default', null, '88', '8888', 'jdbc:clickhouse://{host}:{port}/{database}', 'ru.yandex.clickhouse.ClickHouseDriver', null, '0', null, '2021-09-06 15:11:11', null, null, '8888', null);
INSERT INTO `job_jdbc_datasource` VALUES ('57', '555555', 'kafka', 'Default', null, null, null, null, null, '172.18.8.172:2181/kafka', '0', null, '2021-09-06 15:32:13', null, null, '555', 'demo.vision.software.dc:9092');

-- ----------------------------
-- Table structure for job_lock
-- ----------------------------
DROP TABLE IF EXISTS `job_lock`;
CREATE TABLE `job_lock` (
  `lock_name` varchar(50) NOT NULL COMMENT '锁名称',
  PRIMARY KEY (`lock_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_lock
-- ----------------------------
INSERT INTO `job_lock` VALUES ('schedule_lock');

-- ----------------------------
-- Table structure for job_log
-- ----------------------------
DROP TABLE IF EXISTS `job_log`;
CREATE TABLE `job_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job_group` int(11) NOT NULL COMMENT '执行器主键ID',
  `job_id` int(11) NOT NULL COMMENT '任务，主键ID',
  `job_desc` varchar(255) DEFAULT NULL,
  `executor_address` varchar(255) DEFAULT NULL COMMENT '执行器地址，本次执行的地址',
  `executor_handler` varchar(255) DEFAULT NULL COMMENT '执行器任务handler',
  `executor_param` varchar(512) DEFAULT NULL COMMENT '执行器任务参数',
  `executor_sharding_param` varchar(20) DEFAULT NULL COMMENT '执行器任务分片参数，格式如 1/2',
  `executor_fail_retry_count` int(11) DEFAULT '0' COMMENT '失败重试次数',
  `trigger_time` datetime DEFAULT NULL COMMENT '调度-时间',
  `trigger_code` int(11) NOT NULL COMMENT '调度-结果',
  `trigger_msg` text COMMENT '调度-日志',
  `handle_time` datetime DEFAULT NULL COMMENT '执行-时间',
  `handle_code` int(11) NOT NULL COMMENT '执行-状态',
  `handle_msg` text COMMENT '执行-日志',
  `alarm_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败',
  `process_id` varchar(20) DEFAULT NULL COMMENT 'flinkx进程Id',
  `max_id` bigint(20) DEFAULT NULL COMMENT '增量表max id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `I_trigger_time` (`trigger_time`) USING BTREE,
  KEY `I_handle_code` (`handle_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_log
-- ----------------------------

-- ----------------------------
-- Table structure for job_log_report
-- ----------------------------
DROP TABLE IF EXISTS `job_log_report`;
CREATE TABLE `job_log_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trigger_day` datetime DEFAULT NULL COMMENT '调度-时间',
  `running_count` int(11) NOT NULL DEFAULT '0' COMMENT '运行中-日志数量',
  `suc_count` int(11) NOT NULL DEFAULT '0' COMMENT '执行成功-日志数量',
  `fail_count` int(11) NOT NULL DEFAULT '0' COMMENT '执行失败-日志数量',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `i_trigger_day` (`trigger_day`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_log_report
-- ----------------------------
INSERT INTO `job_log_report` VALUES ('20', '2019-12-07 00:00:00', '0', '0', '0');
INSERT INTO `job_log_report` VALUES ('21', '2019-12-10 00:00:00', '77', '52', '23');
INSERT INTO `job_log_report` VALUES ('22', '2019-12-11 00:00:00', '9', '2', '11');
INSERT INTO `job_log_report` VALUES ('23', '2019-12-13 00:00:00', '9', '48', '74');
INSERT INTO `job_log_report` VALUES ('24', '2019-12-12 00:00:00', '10', '8', '30');
INSERT INTO `job_log_report` VALUES ('25', '2019-12-14 00:00:00', '78', '45', '66');
INSERT INTO `job_log_report` VALUES ('26', '2019-12-15 00:00:00', '24', '76', '9');
INSERT INTO `job_log_report` VALUES ('27', '2019-12-16 00:00:00', '23', '85', '10');

-- ----------------------------
-- Table structure for job_logglue
-- ----------------------------
DROP TABLE IF EXISTS `job_logglue`;
CREATE TABLE `job_logglue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_id` int(11) NOT NULL COMMENT '任务，主键ID',
  `glue_type` varchar(50) DEFAULT NULL COMMENT 'GLUE类型',
  `glue_source` mediumtext COMMENT 'GLUE源代码',
  `glue_remark` varchar(128) NOT NULL COMMENT 'GLUE备注',
  `add_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_logglue
-- ----------------------------

-- ----------------------------
-- Table structure for job_permission
-- ----------------------------
DROP TABLE IF EXISTS `job_permission`;
CREATE TABLE `job_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '权限名',
  `description` varchar(11) DEFAULT NULL COMMENT '权限描述',
  `url` varchar(255) DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_permission
-- ----------------------------

-- ----------------------------
-- Table structure for job_project
-- ----------------------------
DROP TABLE IF EXISTS `job_project`;
CREATE TABLE `job_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'key',
  `name` varchar(100) DEFAULT NULL COMMENT 'project name',
  `description` varchar(200) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL COMMENT 'creator id',
  `flag` tinyint(4) DEFAULT '1' COMMENT '0 not available, 1 available',
  `create_time` datetime DEFAULT NULL COMMENT 'create time',
  `update_time` datetime DEFAULT NULL COMMENT 'update time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_project
-- ----------------------------

-- ----------------------------
-- Table structure for job_registry
-- ----------------------------
DROP TABLE IF EXISTS `job_registry`;
CREATE TABLE `job_registry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registry_group` varchar(50) NOT NULL,
  `registry_key` varchar(191) NOT NULL,
  `registry_value` varchar(191) NOT NULL,
  `cpu_usage` double DEFAULT NULL,
  `memory_usage` double DEFAULT NULL,
  `load_average` double DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `i_g_k_v` (`registry_group`,`registry_key`,`registry_value`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_registry
-- ----------------------------

-- ----------------------------
-- Table structure for job_template
-- ----------------------------
DROP TABLE IF EXISTS `job_template`;
CREATE TABLE `job_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_group` int(11) NOT NULL COMMENT '执行器主键ID',
  `job_cron` varchar(128) NOT NULL COMMENT '任务执行CRON',
  `job_desc` varchar(255) NOT NULL,
  `add_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL COMMENT '修改用户',
  `alarm_email` varchar(255) DEFAULT NULL COMMENT '报警邮件',
  `executor_route_strategy` varchar(50) DEFAULT NULL COMMENT '执行器路由策略',
  `executor_handler` varchar(255) DEFAULT NULL COMMENT '执行器任务handler',
  `executor_param` varchar(512) DEFAULT NULL COMMENT '执行器参数',
  `executor_block_strategy` varchar(50) DEFAULT NULL COMMENT '阻塞处理策略',
  `executor_timeout` int(11) NOT NULL DEFAULT '0' COMMENT '任务执行超时时间，单位秒',
  `executor_fail_retry_count` int(11) NOT NULL DEFAULT '0' COMMENT '失败重试次数',
  `glue_type` varchar(50) NOT NULL COMMENT 'GLUE类型',
  `glue_source` mediumtext COMMENT 'GLUE源代码',
  `glue_remark` varchar(128) DEFAULT NULL COMMENT 'GLUE备注',
  `glue_updatetime` datetime DEFAULT NULL COMMENT 'GLUE更新时间',
  `child_jobid` varchar(255) DEFAULT NULL COMMENT '子任务ID，多个逗号分隔',
  `trigger_last_time` bigint(13) NOT NULL DEFAULT '0' COMMENT '上次调度时间',
  `trigger_next_time` bigint(13) NOT NULL DEFAULT '0' COMMENT '下次调度时间',
  `job_json` text COMMENT 'flinkx运行脚本',
  `jvm_param` varchar(200) DEFAULT NULL COMMENT 'jvm参数',
  `project_id` int(11) DEFAULT NULL COMMENT '所属项目Id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_template
-- ----------------------------

-- ----------------------------
-- Table structure for job_user
-- ----------------------------
DROP TABLE IF EXISTS `job_user`;
CREATE TABLE `job_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '账号',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `role` varchar(50) DEFAULT NULL COMMENT '角色：0-普通用户、1-管理员',
  `permission` varchar(255) DEFAULT NULL COMMENT '权限：执行器ID列表，多个逗号分割',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `i_username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of job_user
-- ----------------------------
INSERT INTO `job_user` VALUES ('1', 'admin', '$2a$10$2KCqRbra0Yn2TwvkZxtfLuWuUP5KyCWsljO/ci5pLD27pqR3TV1vy', 'ROLE_ADMIN', null);

-- ----------------------------
-- Table structure for kafka
-- ----------------------------
DROP TABLE IF EXISTS `kafka`;
CREATE TABLE `kafka` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kafka
-- ----------------------------
INSERT INTO `kafka` VALUES ('16', 'topic3', '[{\"name\":\"a.id[0]\",\"type\":\"int\",\"desc\":\"id\"},{\"name\":\"b\",\"type\":\"varchar\",\"desc\":\"\"}]', '19', null, null, null, null);
INSERT INTO `kafka` VALUES ('17', 'topic4', '[{\"name\":\"a.id[0]\",\"type\":\"int\",\"desc\":\"id\"},{\"name\":\"b\",\"type\":\"varchar\",\"desc\":\"\"}]', '19', null, null, null, null);
INSERT INTO `kafka` VALUES ('18', 'topic3', '[{\"name\":\"a.id[0]\",\"type\":\"int\",\"desc\":\"id\"},{\"name\":\"b\",\"type\":\"varchar\",\"desc\":\"\"}]', '20', null, null, null, null);
INSERT INTO `kafka` VALUES ('19', 'topic4', '[{\"name\":\"a.id[0]\",\"type\":\"int\",\"desc\":\"id\"},{\"name\":\"b\",\"type\":\"varchar\",\"desc\":\"\"}]', '20', null, null, null, null);
INSERT INTO `kafka` VALUES ('22', 'topic1', 'topic1 ', '27', null, null, null, null);
INSERT INTO `kafka` VALUES ('27', 'region-invade', 'test5', '37', null, null, null, null);
INSERT INTO `kafka` VALUES ('28', 'test', 'test5', '37', null, null, null, null);
INSERT INTO `kafka` VALUES ('29', 'face-match', 'test5', '37', null, null, null, null);
INSERT INTO `kafka` VALUES ('33', 'k3', '123456', '33', null, null, null, null);
INSERT INTO `kafka` VALUES ('34', 'k4', '123456', '33', null, null, null, null);

-- ----------------------------
-- Table structure for log_filter
-- ----------------------------
DROP TABLE IF EXISTS `log_filter`;
CREATE TABLE `log_filter` (
  `code_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '错误码ID号',
  `log_code` varchar(10) NOT NULL COMMENT '日志错误码',
  `code_type` int(2) NOT NULL COMMENT '错误码类型',
  `compare_text` varchar(1000) NOT NULL COMMENT '错误码识别文本',
  `operate_type` int(2) NOT NULL COMMENT '操作类型',
  `log_notice` varchar(255) DEFAULT NULL COMMENT '提示文本',
  `submit_time` datetime DEFAULT NULL COMMENT '提交时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`code_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='日志错误码表';

-- ----------------------------
-- Records of log_filter
-- ----------------------------
INSERT INTO `log_filter` VALUES ('1', '000000', '1', ' INFO - ', '2', '过滤Azkaban的日期日志', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('2', '000001', '1', 'chgrp: changing ownership of', '3', '过滤无用日志', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('3', '000002', '2', ' ERROR - ', '2', '过滤Azkaban的日期日志', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('4', '00000', '2', '未能识别的异常', '1', '未知问题，请查看详细日志信息。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('5', '10001', '2', '(?<=queue).*?(?=is not exists in YARN)', '1', '会话创建失败，队列#0#不存在，请检查任务队列设置是否正确。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('6', '20001', '2', '(?=.*本次申请资源 + 已占用任务队列资源 > 用户最大可申请资源，申请新Session不予通过)+(.*?)', '1', '会话创建失败，当前申请资源#0#，系统可用资源#2#，请检查资源配置是否合理', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('7', '20002', '2', '远程服务器没有足够资源实例化spark Session，通常是由于您设置【驱动内存】或【客户端内存】过高导致，建议kill脚本，调低参数后重新提交', '1', '会话创建失败，服务器资源不足，请稍后再试', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('8', '20003', '2', 'Caused by: java.io.FileNotFoundExecption', '1', '内存溢出，请去、检查脚本查询中是否有ds分区；2、增加内存配置；3、用hql执行；', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('9', '30001', '2', 'Permission denied: user=', '1', '表无访问权限，请申请开通权限', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('10', '40001', '2', '(?<=Database).*?(?=not found)', '1', '数据库#0#不存在，请检查引用的数据库是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('11', '40001', '2', '(?<=Database does not exist: ).*?(?=s)', '1', '数据库#0#不存在，请检查引用的数据库是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('12', '40002', '2', '(?<=Table or view).*?(?=not found in database)', '1', '表#0#不存在，请检查引用的表是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('13', '40002', '2', '(?<=Table or view not found:).*?(?=;)', '1', '表#0#不存在，请检查引用的表是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('14', '40002', '2', '(?<=Table not found \').*?(?=\')', '1', '表#0#不存在，请检查引用的表是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('15', '40003', '2', '(?<=cannot resolve).*?(?=given input columns)', '1', '字段#0#不存在，请检查引用的字段是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('16', '40003', '2', '(?<=Invalid table alias or column reference ).*?(?=s)', '1', '字段#0#不存在，请检查引用的字段是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('17', '40004', '2', '(?<=ds is not a valid partition column in table ).*?(?=s)', '1', '分区名#0#不存在，请检查引用的表是否为分区表。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('18', '40004', '2', '(?<=table is not partitioned but partition spec exists: ).*?(?=s)', '1', '分区名#0#不存在，请检查引用的表是否为分区表。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('19', '50001', '2', 'extraneous input \'\\)\'', '1', '括号不匹配，请检查脚本中括号是否前后匹配。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('20', '50001', '2', 'missing EOF at \'\\)\'', '1', '括号不匹配，请检查脚本中括号是否前后匹配。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('21', '50002', '2', '(?<=expressions).*?(?=is neither present in the group by, nor is it an aggregate funciton)', '1', '非聚合函数#0#必须写在group by中，请检查脚本中group by 语法。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('22', '50002', '2', '(?<=grouping expressions sequence is empty, and).*?(?=is not an aggregate funciton)', '1', '非聚合函数#0#必须写在group by中，请检查脚本中group by 语法。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('23', '50002', '2', '(?<=Expression not in GROUP BY key ).*?(?=s)', '1', '非聚合函数#0#必须写在group by中，请检查脚本中group by 语法。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('24', '50003', '2', '(?<=Undefined function:).*?(?=. This funciton is neither a registered)', '1', '未知函数#0#，请检查脚本中引用的函数是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');
INSERT INTO `log_filter` VALUES ('25', '50003', '2', '(?<=Invalid function ).*?(?=s)', '1', '未知函数#0#，请检查脚本中引用的函数是否有误。', '2021-08-09 08:36:46', '2021-08-09 08:36:46');

-- ----------------------------
-- Table structure for project_events
-- ----------------------------
DROP TABLE IF EXISTS `project_events`;
CREATE TABLE `project_events` (
  `project_id` int(11) NOT NULL,
  `event_type` tinyint(4) NOT NULL,
  `event_time` bigint(20) NOT NULL,
  `username` varchar(64) DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL,
  KEY `log` (`project_id`,`event_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of project_events
-- ----------------------------
INSERT INTO `project_events` VALUES ('1', '1', '1628471143707', 'superadmin', null);
INSERT INTO `project_events` VALUES ('1', '6', '1628471159224', 'superadmin', 'Uploaded project files zip gmall.zip');
INSERT INTO `project_events` VALUES ('2', '1', '1628471289921', 'superadmin', null);
INSERT INTO `project_events` VALUES ('2', '6', '1628471297333', 'superadmin', 'Uploaded project files zip gmall.zip');
INSERT INTO `project_events` VALUES ('1', '3', '1628473725880', 'hadoop', 'Permission for user hadoop set to ADMIN');
INSERT INTO `project_events` VALUES ('3', '1', '1628474054561', 'hadoop', null);
INSERT INTO `project_events` VALUES ('4', '1', '1628476229701', 'superadmin', null);
INSERT INTO `project_events` VALUES ('1', '6', '1628479858267', 'hadoop', 'Uploaded project files zip gmall.zip');
INSERT INTO `project_events` VALUES ('1', '7', '1628480336712', 'hadoop', 'Schedule test1.hdfs_to_mysql (1) to be run at (starting) 2021-08-09T11:38:56.675+08:00 with CronExpression {0 0 12 ? * * } has been added.');
INSERT INTO `project_events` VALUES ('1', '7', '1628480503235', 'hadoop', 'Schedule test1.hdfs_to_mysql (1) to be run at (starting) 2021-08-09T11:38:56.675+08:00 with CronExpression {0 0 12 ? * * } has been removed.');
INSERT INTO `project_events` VALUES ('1', '7', '1628480530130', 'hadoop', 'Schedule test1.hdfs_to_mysql (1) to be run at (starting) 2021-08-09T11:42:10.107+08:00 with CronExpression {0 0 12 ? * * } has been added.');
INSERT INTO `project_events` VALUES ('1', '7', '1628480675560', 'hadoop', 'Schedule test1.hdfs_to_mysql (1) to be run at (starting) 2021-08-09T11:42:10.107+08:00 with CronExpression {0 0 12 ? * * } has been removed.');
INSERT INTO `project_events` VALUES ('1', '7', '1628480712524', 'hadoop', 'Schedule test1.hdfs_to_mysql (1) to be run at (starting) 2021-08-09T11:45:12.508+08:00 with CronExpression {0 0 12 ? * 5 } has been added.');

-- ----------------------------
-- Table structure for project_files
-- ----------------------------
DROP TABLE IF EXISTS `project_files`;
CREATE TABLE `project_files` (
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `chunk` int(11) NOT NULL,
  `size` int(11) DEFAULT NULL,
  `file` longblob,
  PRIMARY KEY (`project_id`,`version`,`chunk`) USING BTREE,
  KEY `file_version` (`project_id`,`version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of project_files
-- ----------------------------
INSERT INTO `project_files` VALUES ('1', '1', '0', '1999', 0x504B030414000000080052452D525C5A30F8540000005C000000180000006F64735F746F5F6477645F73746172745F6C6F672E6A6F622DCB3D0E80200C40E19D843B3838CB09380B515A85445A426B8C31DEDD9FB8BDE17B7A54F4914B1909ACF9C3BB4D9A9B32390609CA017608A263D3B0F23248EAFA13F4B206B0220152CC283EC1FCE1E779993537504B03041400000008004C452D52459289885100000058000000110000006F64735F746F5F6477645F64622E6A6F622DCB4B0A80201446E1B9E01E1C34CE15B81651FF1B0ABEE81A11D1DE93687606DF195727135A29AE428A3F8C3E78D73E55DDC076348B13167EE5A85CCE6AB9311E29409D2AA886446C22B64FCE614A295E504B03040A000000000045452D528FE2D4903900000039000000110000006D7973716C5F746F5F686466732E6A6F62747970653D636F6D6D616E640D0A636F6D6D616E643D2F7573722F62696E2F6D7973716C5F746F5F686466732E736820616C6C20247B64747D504B03040A00000000003D452D521B5903BA370000003700000013000000686466735F746F5F6F64735F6C6F672E6A6F62747970653D636F6D6D616E640D0A636F6D6D616E643D2F7573722F62696E2F686466735F746F5F6F64735F6C6F672E736820247B64747D504B030414000000080036452D52F8C57E5B510000005600000012000000686466735F746F5F6F64735F64622E6A6F622DCB310AC0200C40D15DF00E0E9DEB093C8BA84951D0689B7490D2BB17A1DB1FFE9339D0A5DE5A20D0EA0F676FBE6C2C64331CECA5FB0EEC21EE9C4DA8D56C0FC8AB15E04002A454905D9B7CD6B52EF201504B03041400000008002F452D52C18C8E5D490000004C00000011000000686466735F746F5F6D7973716C2E6A6F622DCAC109C0200C00C0BFE00E9DA04EE02C624D8A42126D9352DCBE14FCDDE36C0E8CA5336701EF166278F40E479350E1D4643DF1D48B76AD5B26F20E70A0004A69A8115EFB4706FD00504B030414000000080029452D523A69B84A490000004B0000000E0000006477745F746F5F6164732E6A6F622DCA310A80300C05D0BDD03B3838DB13E42CA5F607ECD0B4984811F1EE2AB8BDE1D9D99972AB3509BCFB41E1D03DAC450286456B314117DDA6F982DDDE813B0B587261250CFDC61B1F504B030414000000080021452D521A63A71B480000004B0000000E0000006477735F746F5F6477742E6A6F622DCA310A80300C05D0BDD03B3838DB13E42C45FB0376685A4C2488787707DDDEF0EC1A4CA5B7B60A62F841E9D4236D55125CB3F50CB745F769BE614F0CE0C102965259098E6FE80B504B030414000000080013452D52B394BDA455000000630000000E0000006477645F746F5F6477732E6A6F624DCA4B0A80201446E179D01E1A348C5C816B11F5BF94900FBC3724A2BD87D0A0D939F0C95548FB1CA34D18872FB43AB92A17924283916CD078E57D9A6FC8330EA04209947C20D619DC458770CBEF586C1573E4ED05504B01023F0014000000080052452D525C5A30F8540000005C0000001800240000000000000020000000000000006F64735F746F5F6477645F73746172745F6C6F672E6A6F620A00200000000000010018000D0D89FB44E9D6010D0D89FB44E9D601D7360312DA24D601504B01023F001400000008004C452D5245928988510000005800000011002400000000000000200000008A0000006F64735F746F5F6477645F64622E6A6F620A00200000000000010018002E6561F444E9D6012E6561F444E9D6014E01A21DDA24D601504B01023F000A000000000045452D528FE2D490390000003900000011002400000000000000200000000A0100006D7973716C5F746F5F686466732E6A6F620A002000000000000100180091A2F6EC44E9D60191A2F6EC44E9D601184633E4D924D601504B01023F000A00000000003D452D521B5903BA3700000037000000130024000000000000002000000072010000686466735F746F5F6F64735F6C6F672E6A6F620A0020000000000001001800FCE059E544E9D601FCE059E544E9D6015C1166F6D924D601504B01023F0014000000080036452D52F8C57E5B51000000560000001200240000000000000020000000DA010000686466735F746F5F6F64735F64622E6A6F620A0020000000000001001800010A07DD44E9D601010A07DD44E9D60129088104DA24D601504B01023F001400000008002F452D52C18C8E5D490000004C00000011002400000000000000200000005B020000686466735F746F5F6D7973716C2E6A6F620A0020000000000001001800244FAAD444E9D601244FAAD444E9D6010AA2EA50DA24D601504B01023F0014000000080029452D523A69B84A490000004B0000000E00240000000000000020000000D30200006477745F746F5F6164732E6A6F620A0020000000000001001800F2F427CD44E9D601F2F427CD44E9D60102AF1645DA24D601504B01023F0014000000080021452D521A63A71B480000004B0000000E00240000000000000020000000480300006477735F746F5F6477742E6A6F620A0020000000000001001800CB5458C444E9D601CB5458C444E9D601EC994439DA24D601504B01023F0014000000080013452D52B394BDA455000000630000000E00240000000000000020000000BC0300006477645F746F5F6477732E6A6F620A0020000000000001001800EB96D6B544E9D601EB96D6B544E9D60144B7B92BDA24D601504B050600000000090009007C0300003D0400000000);
INSERT INTO `project_files` VALUES ('1', '2', '0', '1999', 0x504B030414000000080052452D525C5A30F8540000005C000000180000006F64735F746F5F6477645F73746172745F6C6F672E6A6F622DCB3D0E80200C40E19D843B3838CB09380B515A85445A426B8C31DEDD9FB8BDE17B7A54F4914B1909ACF9C3BB4D9A9B32390609CA017608A263D3B0F23248EAFA13F4B206B0220152CC283EC1FCE1E779993537504B03041400000008004C452D52459289885100000058000000110000006F64735F746F5F6477645F64622E6A6F622DCB4B0A80201446E1B9E01E1C34CE15B81651FF1B0ABEE81A11D1DE93687606DF195727135A29AE428A3F8C3E78D73E55DDC076348B13167EE5A85CCE6AB9311E29409D2AA886446C22B64FCE614A295E504B03040A000000000045452D528FE2D4903900000039000000110000006D7973716C5F746F5F686466732E6A6F62747970653D636F6D6D616E640D0A636F6D6D616E643D2F7573722F62696E2F6D7973716C5F746F5F686466732E736820616C6C20247B64747D504B03040A00000000003D452D521B5903BA370000003700000013000000686466735F746F5F6F64735F6C6F672E6A6F62747970653D636F6D6D616E640D0A636F6D6D616E643D2F7573722F62696E2F686466735F746F5F6F64735F6C6F672E736820247B64747D504B030414000000080036452D52F8C57E5B510000005600000012000000686466735F746F5F6F64735F64622E6A6F622DCB310AC0200C40D15DF00E0E9DEB093C8BA84951D0689B7490D2BB17A1DB1FFE9339D0A5DE5A20D0EA0F676FBE6C2C64331CECA5FB0EEC21EE9C4DA8D56C0FC8AB15E04002A454905D9B7CD6B52EF201504B03041400000008002F452D52C18C8E5D490000004C00000011000000686466735F746F5F6D7973716C2E6A6F622DCAC109C0200C00C0BFE00E9DA04EE02C624D8A42126D9352DCBE14FCDDE36C0E8CA5336701EF166278F40E479350E1D4643DF1D48B76AD5B26F20E70A0004A69A8115EFB4706FD00504B030414000000080029452D523A69B84A490000004B0000000E0000006477745F746F5F6164732E6A6F622DCA310A80300C05D0BDD03B3838DB13E42CA5F607ECD0B4984811F1EE2AB8BDE1D9D99972AB3509BCFB41E1D03DAC450286456B314117DDA6F982DDDE813B0B587261250CFDC61B1F504B030414000000080021452D521A63A71B480000004B0000000E0000006477735F746F5F6477742E6A6F622DCA310A80300C05D0BDD03B3838DB13E42C45FB0376685A4C2488787707DDDEF0EC1A4CA5B7B60A62F841E9D4236D55125CB3F50CB745F769BE614F0CE0C102965259098E6FE80B504B030414000000080013452D52B394BDA455000000630000000E0000006477645F746F5F6477732E6A6F624DCA4B0A80201446E179D01E1A348C5C816B11F5BF94900FBC3724A2BD87D0A0D939F0C95548FB1CA34D18872FB43AB92A17924283916CD078E57D9A6FC8330EA04209947C20D619DC458770CBEF586C1573E4ED05504B01023F0014000000080052452D525C5A30F8540000005C0000001800240000000000000020000000000000006F64735F746F5F6477645F73746172745F6C6F672E6A6F620A00200000000000010018000D0D89FB44E9D6010D0D89FB44E9D601D7360312DA24D601504B01023F001400000008004C452D5245928988510000005800000011002400000000000000200000008A0000006F64735F746F5F6477645F64622E6A6F620A00200000000000010018002E6561F444E9D6012E6561F444E9D6014E01A21DDA24D601504B01023F000A000000000045452D528FE2D490390000003900000011002400000000000000200000000A0100006D7973716C5F746F5F686466732E6A6F620A002000000000000100180091A2F6EC44E9D60191A2F6EC44E9D601184633E4D924D601504B01023F000A00000000003D452D521B5903BA3700000037000000130024000000000000002000000072010000686466735F746F5F6F64735F6C6F672E6A6F620A0020000000000001001800FCE059E544E9D601FCE059E544E9D6015C1166F6D924D601504B01023F0014000000080036452D52F8C57E5B51000000560000001200240000000000000020000000DA010000686466735F746F5F6F64735F64622E6A6F620A0020000000000001001800010A07DD44E9D601010A07DD44E9D60129088104DA24D601504B01023F001400000008002F452D52C18C8E5D490000004C00000011002400000000000000200000005B020000686466735F746F5F6D7973716C2E6A6F620A0020000000000001001800244FAAD444E9D601244FAAD444E9D6010AA2EA50DA24D601504B01023F0014000000080029452D523A69B84A490000004B0000000E00240000000000000020000000D30200006477745F746F5F6164732E6A6F620A0020000000000001001800F2F427CD44E9D601F2F427CD44E9D60102AF1645DA24D601504B01023F0014000000080021452D521A63A71B480000004B0000000E00240000000000000020000000480300006477735F746F5F6477742E6A6F620A0020000000000001001800CB5458C444E9D601CB5458C444E9D601EC994439DA24D601504B01023F0014000000080013452D52B394BDA455000000630000000E00240000000000000020000000BC0300006477645F746F5F6477732E6A6F620A0020000000000001001800EB96D6B544E9D601EB96D6B544E9D60144B7B92BDA24D601504B050600000000090009007C0300003D0400000000);
INSERT INTO `project_files` VALUES ('2', '1', '0', '1999', 0x504B030414000000080052452D525C5A30F8540000005C000000180000006F64735F746F5F6477645F73746172745F6C6F672E6A6F622DCB3D0E80200C40E19D843B3838CB09380B515A85445A426B8C31DEDD9FB8BDE17B7A54F4914B1909ACF9C3BB4D9A9B32390609CA017608A263D3B0F23248EAFA13F4B206B0220152CC283EC1FCE1E779993537504B03041400000008004C452D52459289885100000058000000110000006F64735F746F5F6477645F64622E6A6F622DCB4B0A80201446E1B9E01E1C34CE15B81651FF1B0ABEE81A11D1DE93687606DF195727135A29AE428A3F8C3E78D73E55DDC076348B13167EE5A85CCE6AB9311E29409D2AA886446C22B64FCE614A295E504B03040A000000000045452D528FE2D4903900000039000000110000006D7973716C5F746F5F686466732E6A6F62747970653D636F6D6D616E640D0A636F6D6D616E643D2F7573722F62696E2F6D7973716C5F746F5F686466732E736820616C6C20247B64747D504B03040A00000000003D452D521B5903BA370000003700000013000000686466735F746F5F6F64735F6C6F672E6A6F62747970653D636F6D6D616E640D0A636F6D6D616E643D2F7573722F62696E2F686466735F746F5F6F64735F6C6F672E736820247B64747D504B030414000000080036452D52F8C57E5B510000005600000012000000686466735F746F5F6F64735F64622E6A6F622DCB310AC0200C40D15DF00E0E9DEB093C8BA84951D0689B7490D2BB17A1DB1FFE9339D0A5DE5A20D0EA0F676FBE6C2C64331CECA5FB0EEC21EE9C4DA8D56C0FC8AB15E04002A454905D9B7CD6B52EF201504B03041400000008002F452D52C18C8E5D490000004C00000011000000686466735F746F5F6D7973716C2E6A6F622DCAC109C0200C00C0BFE00E9DA04EE02C624D8A42126D9352DCBE14FCDDE36C0E8CA5336701EF166278F40E479350E1D4643DF1D48B76AD5B26F20E70A0004A69A8115EFB4706FD00504B030414000000080029452D523A69B84A490000004B0000000E0000006477745F746F5F6164732E6A6F622DCA310A80300C05D0BDD03B3838DB13E42CA5F607ECD0B4984811F1EE2AB8BDE1D9D99972AB3509BCFB41E1D03DAC450286456B314117DDA6F982DDDE813B0B587261250CFDC61B1F504B030414000000080021452D521A63A71B480000004B0000000E0000006477735F746F5F6477742E6A6F622DCA310A80300C05D0BDD03B3838DB13E42C45FB0376685A4C2488787707DDDEF0EC1A4CA5B7B60A62F841E9D4236D55125CB3F50CB745F769BE614F0CE0C102965259098E6FE80B504B030414000000080013452D52B394BDA455000000630000000E0000006477645F746F5F6477732E6A6F624DCA4B0A80201446E179D01E1A348C5C816B11F5BF94900FBC3724A2BD87D0A0D939F0C95548FB1CA34D18872FB43AB92A17924283916CD078E57D9A6FC8330EA04209947C20D619DC458770CBEF586C1573E4ED05504B01023F0014000000080052452D525C5A30F8540000005C0000001800240000000000000020000000000000006F64735F746F5F6477645F73746172745F6C6F672E6A6F620A00200000000000010018000D0D89FB44E9D6010D0D89FB44E9D601D7360312DA24D601504B01023F001400000008004C452D5245928988510000005800000011002400000000000000200000008A0000006F64735F746F5F6477645F64622E6A6F620A00200000000000010018002E6561F444E9D6012E6561F444E9D6014E01A21DDA24D601504B01023F000A000000000045452D528FE2D490390000003900000011002400000000000000200000000A0100006D7973716C5F746F5F686466732E6A6F620A002000000000000100180091A2F6EC44E9D60191A2F6EC44E9D601184633E4D924D601504B01023F000A00000000003D452D521B5903BA3700000037000000130024000000000000002000000072010000686466735F746F5F6F64735F6C6F672E6A6F620A0020000000000001001800FCE059E544E9D601FCE059E544E9D6015C1166F6D924D601504B01023F0014000000080036452D52F8C57E5B51000000560000001200240000000000000020000000DA010000686466735F746F5F6F64735F64622E6A6F620A0020000000000001001800010A07DD44E9D601010A07DD44E9D60129088104DA24D601504B01023F001400000008002F452D52C18C8E5D490000004C00000011002400000000000000200000005B020000686466735F746F5F6D7973716C2E6A6F620A0020000000000001001800244FAAD444E9D601244FAAD444E9D6010AA2EA50DA24D601504B01023F0014000000080029452D523A69B84A490000004B0000000E00240000000000000020000000D30200006477745F746F5F6164732E6A6F620A0020000000000001001800F2F427CD44E9D601F2F427CD44E9D60102AF1645DA24D601504B01023F0014000000080021452D521A63A71B480000004B0000000E00240000000000000020000000480300006477735F746F5F6477742E6A6F620A0020000000000001001800CB5458C444E9D601CB5458C444E9D601EC994439DA24D601504B01023F0014000000080013452D52B394BDA455000000630000000E00240000000000000020000000BC0300006477645F746F5F6477732E6A6F620A0020000000000001001800EB96D6B544E9D601EB96D6B544E9D60144B7B92BDA24D601504B050600000000090009007C0300003D0400000000);

-- ----------------------------
-- Table structure for project_flow_files
-- ----------------------------
DROP TABLE IF EXISTS `project_flow_files`;
CREATE TABLE `project_flow_files` (
  `project_id` int(11) NOT NULL,
  `project_version` int(11) NOT NULL,
  `flow_name` varchar(128) NOT NULL,
  `flow_version` int(11) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `flow_file` longblob,
  PRIMARY KEY (`project_id`,`project_version`,`flow_name`,`flow_version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of project_flow_files
-- ----------------------------

-- ----------------------------
-- Table structure for project_flows
-- ----------------------------
DROP TABLE IF EXISTS `project_flows`;
CREATE TABLE `project_flows` (
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `encoding_type` tinyint(4) DEFAULT NULL,
  `json` blob,
  PRIMARY KEY (`project_id`,`version`,`flow_id`) USING BTREE,
  KEY `flow_index` (`project_id`,`version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of project_flows
-- ----------------------------
INSERT INTO `project_flows` VALUES ('1', '1', 'hdfs_to_mysql', '1628471159140', '2', 0x1F8B0800000000000000C5564B4FE33010FE2F738E2A5EBB87DC5005078484B461F7B242919B9974034E1C628752AAFE77C6EE033B2DD22644E216CDFB9BF93C93159464040A23205EAD23A81BF54899991408F169048473D210FF5D81566D9311C4A050A746A5B8C01467108111CD9C0C2BACC42934AC23CF0117C6CA056ADFFA1FE62E4EB9D4CF32747022ABB336C77C6C099C3B70F2CAD2EC6052A9E6FF57DDD6CF84D6FB9A3BD6FB2881F53E4660DDA9D7F3089BF8A95307C3518CEB87087251C8B6A10995FCC1E362916EB38CB4F645E2ED49CC44752DD5E20F35BA5015CF7872C20996B5CD9CB382D351392344426B07712EA4A6085EF60E8E23B5DE84CC548585718AAA9532824AE19630522C55CB55F317BD1097F07343AF3AD922DD381C447854B3A4DB0BC788096BB83C0E4ACDCE985E6B662BE1AFB6324549AE3C4BDD0EBDBC3477D50D2730C2B45C265CDEDEA6C9EFE9F42A49C0A5BEDFB4225365292A7493390072321CC876A883A07C10624C303FFA83F9781CBD70047B604C0867FD2104EFAF178AEEFA1B13C8F99059EC1652CF59787B6C4C08174320ECB6674F08DEE21E13C2E9D79E774F3E1DDC886FDE54C1F1ED85A47BB6BF7926C78EE5D097EEFF510C85F5F0C965B2F779DA9030AAB1ACA65CB4D2529A7B40E8BAE04EF0FA1D5089B54EAA090000);
INSERT INTO `project_flows` VALUES ('1', '2', 'hdfs_to_mysql', '1628479858209', '2', 0x1F8B0800000000000000C5564B4FE33010FE2F738E2A1ECB1E7243151C101212D9DDCB0A456E6652024E1C62876EA9FADF19BB0FECB4489B10895B34EF6FE6F34C56509211288C8078B58EA06ED41365665220C4A71110CE4943FC77055AB54D461083429D1A95E202539C410446347332ACB012A7D0B08E3C075C182B17A87DEB47CC5D9C72A95F64E8E04456676D8EF9D8123877E0E495A5D9C1A452CDFFAFBAAD9F09ADF73577ACF75102EB7D8CC0BA53AFE71136F153A70E86A318D70F11E4A2906D43132AF983C7C522DD661969ED8BC4DBB39889EA5AAAC51F6A74A12A9EF1E484132C6B9B396705A7A372468884D60EE25C484D11BCEE1CCE1C476ABD0999A90A0BE314552B650495C22D61A458AA96ABE62F7A252EE1E7865E75B245BA713888F0A46649B7178E1113D670791C949A9D31FDAB99AD84F76D658A921C672D753BF4F2D2DC55379CC008D3729970797B9B26BFA7D3AB240197FAD7A615992A4B51A19BCC019093E140B6431D04E583106382B9E80FE6E371F4C211EC8131219CF58710BCBF5E28BAEB6F4C20E74366B15B483D67E1EDB13121FC180261B73D7B42F016F798104EBFF6BC7BF2E9E0467CF3A60A8E6F2F24DDB3FDCD3339762C87BE74FF8F6228AC874F2E93BDCFD38684518D6535E5A29596D2DC0342D7057782D7EFFE158AE9AA090000);
INSERT INTO `project_flows` VALUES ('2', '1', 'hdfs_to_mysql', '1628471297221', '2', 0x1F8B0800000000000000C5564B4FE33010FE2F738E2A1ECB1E7243151C101212D9DDCB0A456E6652024E1C62876EA9FADF19BB0FECB4489B10895B34EF6FE6F34C56509211288C8078B58EA06ED41365665220C4671110CE4943FC77055AB54D461083429D1A95E202539C410446347332ACB012A7D0B08E3C075C182B17A87DEB47CC5D9C72A95F64E8E04456676D8EF9D8123877E0E495A5D9C1A452CDFFAFBAAD9F09ADF73577ACF75102EB7D8CC0BA53AFE71136F153A70E86A318D70F11E4A2906D43132AF983C7C522DD661969ED8BC4DBB39889EA5AAAC51F6A74A12A884F27279C6059DBCC392B381D95334224B47610E7426A8AE075EFE03852EB4DC84C555818A7A85A2923A8146E0923C552B55C357FD12B71093F37F4AA932DD28DC3418427354BBABD708C98B086CBE3A0D4EC8CE95FCD6C25BC6F2B5394E4CAB3D4EDD0CB4B7357DD7002234CCB65C2E5ED6D9AFC9E4EAF92045CEA5F9B5664AA2C45856E3207404E8603D90E7510940F428C09E6A23F988FC7D10B47B007C68470D61F42F0FE7AA1E8AEBF31819C0F99C56E21F59C85B7C7C684F0630884DDF6EC09C15BDC634238FDDAF3EEC9A7831BF1CD9B2A38BEBD9074CFF637CFE4D8B11CFAD2FD3F8AA1B01E3EB94CF63E4F1B12463596D5948B565A4A730F085D17DC095EBF03F6275554AA090000);

-- ----------------------------
-- Table structure for project_permissions
-- ----------------------------
DROP TABLE IF EXISTS `project_permissions`;
CREATE TABLE `project_permissions` (
  `project_id` varchar(64) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `name` varchar(64) NOT NULL,
  `permissions` int(11) NOT NULL,
  `isGroup` tinyint(1) NOT NULL,
  `project_group` varchar(128) DEFAULT NULL,
  `group_permissions` varchar(128) DEFAULT NULL,
  `project_creator` tinyint(1) DEFAULT NULL COMMENT '是否项目创建人',
  PRIMARY KEY (`project_id`,`name`) USING BTREE,
  KEY `permission_nameindex` (`name`,`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of project_permissions
-- ----------------------------
INSERT INTO `project_permissions` VALUES ('1', '1628473725871', 'hadoop', '134217728', '0', null, null, null);
INSERT INTO `project_permissions` VALUES ('1', '1628471143679', 'superadmin', '134217728', '0', '', null, null);
INSERT INTO `project_permissions` VALUES ('2', '1628471289903', 'superadmin', '134217728', '0', '', null, null);
INSERT INTO `project_permissions` VALUES ('3', '1628474054544', 'hadoop', '134217728', '0', '', null, null);
INSERT INTO `project_permissions` VALUES ('4', '1628476229688', 'superadmin', '134217728', '1', null, null, null);

-- ----------------------------
-- Table structure for project_properties
-- ----------------------------
DROP TABLE IF EXISTS `project_properties`;
CREATE TABLE `project_properties` (
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `name` varchar(250) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `encoding_type` tinyint(4) DEFAULT NULL,
  `property` blob,
  PRIMARY KEY (`project_id`,`version`,`name`) USING BTREE,
  KEY `properties_index` (`project_id`,`version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of project_properties
-- ----------------------------
INSERT INTO `project_properties` VALUES ('1', '1', 'dwd_to_dws.job', '1628471159191', '2', 0x1F8B08000000000000004DCA410A80300C05D1AB487059ECBE9709D61F54D0B698888878770B82B89B8177919D4528D090D7B54F20F75520BFEBE6E39C3C0EB065C6A19D4E4D7BC1EE0A214512240DB368D519FA2230A2FB9D5ABF192F79A4FB0113B540756F000000);
INSERT INTO `project_properties` VALUES ('1', '1', 'dws_to_dwt.job', '1628471159196', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F453CA8BE34BF2E353CA4BF48A331454AA534A6A810A53520B52F35252F39233538B81AA53CA53208A8A956A0190874E0F57000000);
INSERT INTO `project_properties` VALUES ('1', '1', 'dwt_to_ads.job', '1628471159184', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F453CA4BE24BF2E313538AF58A331454AA534A6A810A53520B52F35252F39233538B81AA53CA8B418A806A956A0186DCA40157000000);
INSERT INTO `project_properties` VALUES ('1', '1', 'hdfs_to_mysql.job', '1628471159157', '2', 0x1F8B08000000000000003DCA310E80200C00C0AF98CE46763E4390D640520A5A8C21C6BF8B8BDB0D7743EB95C04228397B41987F5930A71E664D62226EEA5A71B9EBCE8BC6C9338F895449902424D2D1F16A5FF2A8F0BC7D8764EF58000000);
INSERT INTO `project_properties` VALUES ('1', '1', 'hdfs_to_ods_db.job', '1628471159211', '2', 0x1F8B08000000000000003DCB3B0E80201000D1AB908DA5919ECB1060D740C24F170B42BCBBD0D84D316F40EB9540812B29998CB0FFA5403E7C4B1BB2F478B26E4517648DF6602F4C8C621BD8DE09902A65A4EC02F154A9F315D7BD14BC1F2653010E62000000);
INSERT INTO `project_properties` VALUES ('1', '1', 'hdfs_to_ods_log.job', '1628471159164', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F43352D28AE34BF2E3F3538AE373F2D3F58A331454AA534A6A956A0156A5587F40000000);
INSERT INTO `project_properties` VALUES ('1', '1', 'mysql_to_hdfs.job', '1628471159204', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F4732B8B0B73E24BF2E33352D28AF58A33141273721454AA534A6A956A011281FEA242000000);
INSERT INTO `project_properties` VALUES ('1', '1', 'ods_to_dwd_db.job', '1628471159172', '2', 0x1F8B08000000000000003DCB4B0A80201446E1ADC8A561E4DCCD88FADF48F0451A11E2DE7B0C9A9DC1773AB5AB30297239469340F35F8AE45177697D921955B7AC7142C32E751326043175B4F17870E1044ECE737DA60DEB87DF0796C60DD0ADC10B62000000);
INSERT INTO `project_properties` VALUES ('1', '1', 'ods_to_dwd_start_log.job', '1628471159219', '2', 0x1F8B08000000000000003DCB4D0A80201040E1ABC4D03272EF65C49C2983FCC1998810EF9EB568F716EFAB207726D0E0520836224C7F69502717B5EC51256423C9E08586C5163147DA66F6C358515A2748992252743B71771ED7EF7F593FA13D5CE7780866000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'dwd_to_dws.job', '1628479858238', '2', 0x1F8B08000000000000004DCA410A80300C05D1AB487059ECBE9709D61F54D0B698888878770B82B89B8177919D4528D090D7B54F20F75520BFEBE6E39C3C0EB065C6A19D4E4D7BC1EE0A214512240DB368D519FA2230A2FB9D5ABF192F79A4FB0113B540756F000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'dws_to_dwt.job', '1628479858246', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F453CA8BE34BF2E353CA4BF48A331454AA534A6A810A53520B52F35252F39233538B81AA53CA53208A8A956A0190874E0F57000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'dwt_to_ads.job', '1628479858231', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F453CA4BE24BF2E313538AF58A331454AA534A6A810A53520B52F35252F39233538B81AA53CA8B418A806A956A0186DCA40157000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'hdfs_to_mysql.job', '1628479858218', '2', 0x1F8B08000000000000003DCA310E80200C00C0AF98CE46763E4390D640520A5A8C21C6BF8B8BDB0D7743EB95C04228397B41987F5930A71E664D62226EEA5A71B9EBCE8BC6C9338F895449902424D2D1F16A5FF2A8F0BC7D8764EF58000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'hdfs_to_ods_db.job', '1628479858257', '2', 0x1F8B08000000000000003DCB3B0E80201000D1AB908DA5919ECB1060D740C24F170B42BCBBD0D84D316F40EB9540812B29998CB0FFA5403E7C4B1BB2F478B26E4517648DF6602F4C8C621BD8DE09902A65A4EC02F154A9F315D7BD14BC1F2653010E62000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'hdfs_to_ods_log.job', '1628479858223', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F43352D28AE34BF2E3F3538AE373F2D3F58A331454AA534A6A956A0156A5587F40000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'mysql_to_hdfs.job', '1628479858253', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F4732B8B0B73E24BF2E33352D28AF58A33141273721454AA534A6A956A011281FEA242000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'ods_to_dwd_db.job', '1628479858227', '2', 0x1F8B08000000000000003DCB4B0A80201446E1ADC8A561E4DCCD88FADF48F0451A11E2DE7B0C9A9DC1773AB5AB30297239469340F35F8AE45177697D921955B7AC7142C32E751326043175B4F17870E1044ECE737DA60DEB87DF0796C60DD0ADC10B62000000);
INSERT INTO `project_properties` VALUES ('1', '2', 'ods_to_dwd_start_log.job', '1628479858262', '2', 0x1F8B08000000000000003DCB4D0A80201040E1ABC4D03272EF65C49C2983FCC1998810EF9EB568F716EFAB207726D0E0520836224C7F69502717B5EC51256423C9E08586C5163147DA66F6C358515A2748992252743B71771ED7EF7F593FA13D5CE7780866000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'dwd_to_dws.job', '1628471297289', '2', 0x1F8B08000000000000004DCA410A80300C05D1AB487059ECBE9709D61F54D0B698888878770B82B89B8177919D4528D090D7B54F20F75520BFEBE6E39C3C0EB065C6A19D4E4D7BC1EE0A214512240DB368D519FA2230A2FB9D5ABF192F79A4FB0113B540756F000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'dws_to_dwt.job', '1628471297300', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F453CA8BE34BF2E353CA4BF48A331454AA534A6A810A53520B52F35252F39233538B81AA53CA53208A8A956A0190874E0F57000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'dwt_to_ads.job', '1628471297272', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F453CA4BE24BF2E313538AF58A331454AA534A6A810A53520B52F35252F39233538B81AA53CA8B418A806A956A0186DCA40157000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'hdfs_to_mysql.job', '1628471297240', '2', 0x1F8B08000000000000003DCA310E80200C00C0AF98CE46763E4390D640520A5A8C21C6BF8B8BDB0D7743EB95C04228397B41987F5930A71E664D62226EEA5A71B9EBCE8BC6C9338F895449902424D2D1F16A5FF2A8F0BC7D8764EF58000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'hdfs_to_ods_db.job', '1628471297318', '2', 0x1F8B08000000000000003DCB3B0E80201000D1AB908DA5919ECB1060D740C24F170B42BCBBD0D84D316F40EB9540812B29998CB0FFA5403E7C4B1BB2F478B26E4517648DF6602F4C8C621BD8DE09902A65A4EC02F154A9F315D7BD14BC1F2653010E62000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'hdfs_to_ods_log.job', '1628471297250', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F43352D28AE34BF2E3F3538AE373F2D3F58A331454AA534A6A956A0156A5587F40000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'mysql_to_hdfs.job', '1628471297309', '2', 0x1F8B0800000000000000AB562AA92C4855B2524ACECFCD4DCC4B51D281B3AC94F44B8B8BF49332F3F4732B8B0B73E24BF2E33352D28AF58A33141273721454AA534A6A956A011281FEA242000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'ods_to_dwd_db.job', '1628471297262', '2', 0x1F8B08000000000000003DCB4B0A80201446E1ADC8A561E4DCCD88FADF48F0451A11E2DE7B0C9A9DC1773AB5AB30297239469340F35F8AE45177697D921955B7AC7142C32E751326043175B4F17870E1044ECE737DA60DEB87DF0796C60DD0ADC10B62000000);
INSERT INTO `project_properties` VALUES ('2', '1', 'ods_to_dwd_start_log.job', '1628471297326', '2', 0x1F8B08000000000000003DCB4D0A80201040E1ABC4D03272EF65C49C2983FCC1998810EF9EB568F716EFAB207726D0E0520836224C7F69502717B5EC51256423C9E08586C5163147DA66F6C358515A2748992252743B71771ED7EF7F593FA13D5CE7780866000000);

-- ----------------------------
-- Table structure for project_versions
-- ----------------------------
DROP TABLE IF EXISTS `project_versions`;
CREATE TABLE `project_versions` (
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `upload_time` bigint(20) NOT NULL,
  `uploader` varchar(64) NOT NULL,
  `file_type` varchar(16) DEFAULT NULL,
  `file_name` varchar(128) DEFAULT NULL,
  `md5` binary(16) DEFAULT NULL,
  `num_chunks` int(11) DEFAULT NULL,
  `resource_id` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`project_id`,`version`) USING BTREE,
  KEY `version_index` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of project_versions
-- ----------------------------
INSERT INTO `project_versions` VALUES ('1', '1', '1628471159106', 'superadmin', 'zip', 'gmall.zip', 0xF5A00643953DF0348D44934F4EBF8685, '1', null);
INSERT INTO `project_versions` VALUES ('1', '2', '1628479858183', 'hadoop', 'zip', 'gmall.zip', 0xF5A00643953DF0348D44934F4EBF8685, '1', null);
INSERT INTO `project_versions` VALUES ('2', '1', '1628471297185', 'superadmin', 'zip', 'gmall.zip', 0xF5A00643953DF0348D44934F4EBF8685, '1', null);

-- ----------------------------
-- Table structure for projects
-- ----------------------------
DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `modified_time` bigint(20) NOT NULL,
  `create_time` bigint(20) NOT NULL,
  `version` int(11) DEFAULT NULL,
  `last_modified_by` varchar(64) NOT NULL,
  `description` varchar(2048) DEFAULT NULL,
  `create_user` varchar(64) DEFAULT NULL COMMENT '项目创建人',
  `enc_type` tinyint(4) DEFAULT NULL,
  `settings_blob` longblob,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `project_id` (`id`) USING BTREE,
  KEY `project_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of projects
-- ----------------------------
INSERT INTO `projects` VALUES ('1', 'test1', '1', '1628479858214', '1628471143654', '2', 'hadoop', 'test1', 'superadmin', '2', 0x1F8B0800000000000000658C410AC2301045EF32EB6C12D35A730777BA12174367C480694266284AE9DD8D82A0B8FDEFBFB7406245424508CB6A60C2C4104059D4820162196B2C1AF3F4B5DE50749F295E22D351B8367445CAB93416098235307395B7E40C949AEF8FD74F209C3ECFF36FE610538B632ACDEEDDE0B7BBA11B9CF506C6CAA8FCC7ADF59BBEF3EB132A19D767C1000000);
INSERT INTO `projects` VALUES ('2', 'test2', '1', '1628471297229', '1628471289887', '1', 'superadmin', 'test2', 'superadmin', '2', 0x1F8B08000000000000006D8DB10EC2300C44FFC57396468826F90736981083551B618934516C10A8EABF13984062BD77EF6E81CC8684869096D5C18C992181B19A0707C43A35A92665FE4AAFA8B62B2467613A28B78EF456B92165993B1782E41DDCB9E9471C1CD4561ECF7757211DE182544A85D3EFD45E723FC05CBBB1F561330E3E8EDE4707536334FEC3430C615C5F668B66EBC5000000);
INSERT INTO `projects` VALUES ('3', 'test3', '1', '1628474054528', '1628474054528', null, 'hadoop', 'test3', 'hadoop', '2', 0x1F8B0800000000000000758C410AC2301045EFF2D759D436D5923BB8D395B8183A23064C1392A128A577370A822EDCFEF7FE5B10448949096E590D260A020795A21D0C58CA987D521FA7AFF54645F791FDC50B1F8BE48AAEC431A6CA3CC37506B3E4F23E350629C7FBE3E515B8D3C73CFF660E3ED4388504B7D9B683DDD9A6B77D3B188C5948E51F5F9FE085E87EC1000000);
INSERT INTO `projects` VALUES ('4', 't1', '1', '1628476229670', '1628476229670', null, 'superadmin', 'desc', 'superadmin', '2', 0x1F8B0800000000000000758C310EC2301004FFB2B50B124509F80F7450218A53EE1027E1D8B22F0814E5EF387414943BB3BB0B82183119C12FABC34441E0610D1C58CA983599C6A9A22D55F8A062C7C87A53E173915C4D999364E2A053F5CAF09DC35372F9EE760E29C7D77BEB16F80BEEC431265C7FAF4E1AA4188504DFF4EDBE1BFAB63DF4435D8F59C8E49F5F3F75AA8FF1C1000000);

-- ----------------------------
-- Table structure for properties
-- ----------------------------
DROP TABLE IF EXISTS `properties`;
CREATE TABLE `properties` (
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `value` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`name`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of properties
-- ----------------------------

-- ----------------------------
-- Table structure for triggers
-- ----------------------------
DROP TABLE IF EXISTS `triggers`;
CREATE TABLE `triggers` (
  `trigger_id` int(11) NOT NULL AUTO_INCREMENT,
  `trigger_source` varchar(128) DEFAULT NULL,
  `modify_time` bigint(20) NOT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `data` longblob,
  PRIMARY KEY (`trigger_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of triggers
-- ----------------------------
INSERT INTO `triggers` VALUES ('3', 'SimpleTimeTrigger', '1628480712519', '2', 0x1F8B0800000000000000AD545D6ED34010BE4AB44F80AAE284FE84BCA0B475445068AAA63C2054455B7B9C6C6BEFBABBEBD010E58943F40A3D00421C0821F516CCECC6499A848244FD64EFCC7EDF7C339F67C2AC168301E8432563618592AC3161126EECE110A2AB3391016BB0EA5EADBEBF13D4037AD816839B5C83312E9B1D7023224A743740F7ABDB30E2E9B3E79818F923C31A9F26E5C73BF36F249156325C260A2A41A55AABBCA9BCA8EC563021072D548C0159A4297E9B2B919F70E3419112A51580E716F1BF28491C4D23F8CBDE90CBC1900B0C25429BB52276EAC17EB5B61BD431419853880AAD851C2C0045BC5136518D73D81063D34742E718449160BBF2CCCF62A9747FD026C2572451153A22989EC8F21408A7BC3307C19E090D0B0C70DFCD88864B83384798E22213F60F927DF08371750C79AC548EA72936F6BD8A45325EBF567D4DE352D2E24471B2A887CFD926B3F772EA9BD17D8E930937D8700BAD547DF6353B097486EFDD7C863B6109176951EAC27BADF671BBF7B6DFEC74FA27DD5EAF7DD009F1660699D263D76BD6A0866CB1EB020AE8C00852D608D045228754480891830A20333935347690D6532201D90B11A5B2D884AE6C91755ABE08D648786A6011ECF0F5584934A3F63CA6882234789861B2E98E009D162FAECC34FAA81F5D2C0CBF4821F65F0976E9846B9E81757F19F5FE01A44FA3D7430DDC2AEA7A0C092F52CB56F057D817960D374C24D7EA12227BCC9D172C184BF65776087A694697EA629B7EE3EDE585413562A087EDA416413CBF40A5F214B4B3C711E45C673800C4FFF9E3DBAFDBEFF75FEFEE6FEFD85C61935267DD64EDE3569739600F7A0A568F1F2263ED2354C107A5134A0BADE14CE7029D25491A757AA6761827A66F553F1B9BEB943DD6A7E979F9FB3DBA5E6BBBB59DBDD9E25B5BAFA18C9F60B9AE52AC2E57EFC6BF6E54E78C275DA925A2DBA9AB5AFF63A31ACB6D41259F86CDA38F44201345E69BFE06E6AAD0F0F3060000);

-- ----------------------------
-- Table structure for user_variable
-- ----------------------------
DROP TABLE IF EXISTS `user_variable`;
CREATE TABLE `user_variable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(128) NOT NULL COMMENT '变量key名称',
  `description` varchar(256) NOT NULL COMMENT '变量描述',
  `value` varchar(256) NOT NULL COMMENT '变量值',
  `owner` varchar(64) NOT NULL COMMENT '创建人',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `key` (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户变量表';

-- ----------------------------
-- Records of user_variable
-- ----------------------------

-- ----------------------------
-- Table structure for user_variable_user
-- ----------------------------
DROP TABLE IF EXISTS `user_variable_user`;
CREATE TABLE `user_variable_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `v_id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户变量关系表';

-- ----------------------------
-- Records of user_variable_user
-- ----------------------------

-- ----------------------------
-- Table structure for wtss_permissions
-- ----------------------------
DROP TABLE IF EXISTS `wtss_permissions`;
CREATE TABLE `wtss_permissions` (
  `permissions_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `permissions_name` varchar(80) DEFAULT NULL COMMENT '权限名称',
  `permissions_value` int(11) DEFAULT NULL COMMENT '权限值',
  `permissions_type` tinyint(1) DEFAULT NULL COMMENT '权限类型',
  `description` varchar(100) DEFAULT NULL COMMENT '权限说明',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`permissions_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='权限表';

-- ----------------------------
-- Records of wtss_permissions
-- ----------------------------
INSERT INTO `wtss_permissions` VALUES ('1', 'ADMIN', '134217728', '1', '超级管理员权限', '1628469407', '1628469407');
INSERT INTO `wtss_permissions` VALUES ('2', 'READ', '1', '1', '读取权限', '1628469407', '1628469407');
INSERT INTO `wtss_permissions` VALUES ('3', 'WRITE', '2', '1', '写权限', '1628469407', '1628469407');
INSERT INTO `wtss_permissions` VALUES ('4', 'EXECUTE', '4', '1', '执行权限', '1628469407', '1628469407');
INSERT INTO `wtss_permissions` VALUES ('5', 'SCHEDULE', '8', '1', '执行定时调度权限', '1628469407', '1628469407');
INSERT INTO `wtss_permissions` VALUES ('6', 'METRICS', '16', '1', '监控权限', '1628469407', '1628469407');
INSERT INTO `wtss_permissions` VALUES ('7', 'CREATEPROJECTS', '1073741824', '1', '创建项目权限', '1628469407', '1628469407');
INSERT INTO `wtss_permissions` VALUES ('8', 'UPLOADPROJECTS', '32768', '1', '上传项目权限', '1628469407', '1628469407');

-- ----------------------------
-- Table structure for wtss_role
-- ----------------------------
DROP TABLE IF EXISTS `wtss_role`;
CREATE TABLE `wtss_role` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(80) DEFAULT NULL COMMENT '角色名称',
  `permissions_ids` varchar(80) DEFAULT NULL COMMENT '角色权限',
  `description` varchar(100) DEFAULT NULL COMMENT '角色说明',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of wtss_role
-- ----------------------------
INSERT INTO `wtss_role` VALUES ('1', 'admin', '1', '管理员角色', '1628469407', '1628469407');
INSERT INTO `wtss_role` VALUES ('2', 'user', '2,3,4,5,7,8', '普通用户角色', '1628469407', '1628469407');

-- ----------------------------
-- Table structure for wtss_user
-- ----------------------------
DROP TABLE IF EXISTS `wtss_user`;
CREATE TABLE `wtss_user` (
  `user_id` varchar(50) NOT NULL COMMENT '用户ID',
  `username` varchar(200) DEFAULT NULL COMMENT '用户登录名',
  `password` varchar(200) DEFAULT NULL COMMENT '用户登录密码',
  `full_name` varchar(200) DEFAULT NULL COMMENT '用户姓名',
  `department_id` int(10) DEFAULT NULL COMMENT '部门ID',
  `department_name` varchar(200) DEFAULT NULL COMMENT '部门',
  `email` varchar(200) DEFAULT NULL COMMENT '电子邮箱',
  `proxy_users` varchar(250) DEFAULT NULL COMMENT '代理用户',
  `role_id` int(11) DEFAULT NULL COMMENT '用户角色',
  `user_type` tinyint(1) DEFAULT NULL COMMENT '权限类型',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  `modify_type` varchar(50) DEFAULT NULL COMMENT '用户变更类型',
  `modify_info` varchar(300) DEFAULT NULL COMMENT '用户变更内容',
  `user_category` varchar(10) DEFAULT NULL COMMENT '用户种类',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of wtss_user
-- ----------------------------
INSERT INTO `wtss_user` VALUES ('wtss_hadoop', 'hadoop', '9A3887ACB63D1CE4C53034E7972DD830', 'hadoop', '9999999', '临时部门', '', 'hadoop', '1', '1', '1628472607109', '1628472634370', '0', 'Normal', 'test');
INSERT INTO `wtss_user` VALUES ('wtss_superadmin', 'superadmin', 'A4E43077D68F3E1F90AD69FF22058E59', 'superadmin', '9999999', '临时部门', '', 'hadoop', '1', '1', '1534408644414', '1534408644414', null, null, null);
