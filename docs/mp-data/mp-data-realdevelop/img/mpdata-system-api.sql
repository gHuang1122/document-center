/*
Navicat MySQL Data Transfer

Source Server         : 172.18.42.160
Source Server Version : 50734
Source Host           : 172.18.42.160:23306
Source Database       : mpdata-system-api

Target Server Type    : MYSQL
Target Server Version : 50734
File Encoding         : 65001

Date: 2021-07-03 15:23:16
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for sys_application
-- ----------------------------
DROP TABLE IF EXISTS `sys_application`;
CREATE TABLE `sys_application` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建用户ID',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后更新用户ID',
  `name` varchar(64) NOT NULL COMMENT '子应用名称',
  `display_name` varchar(64) DEFAULT NULL COMMENT '菜单显示名称',
  `embed_type` varchar(64) DEFAULT NULL COMMENT '页面集成方式',
  `entry_url` varchar(64) NOT NULL COMMENT '子应用入口URL',
  `permission_scope` varchar(64) NOT NULL COMMENT '权限标识',
  `metadata` json DEFAULT NULL COMMENT '子应用元数据',
  `permission_id` varchar(64) DEFAULT NULL COMMENT '子应用对应的根权限ID',
  `root_path` varchar(255) NOT NULL COMMENT '页面根路径',
  `remarks` varchar(500) DEFAULT NULL COMMENT '备注',
  `order_index` int(11) DEFAULT NULL COMMENT '排列序号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permission_scope` (`permission_scope`) USING BTREE COMMENT '子应用权限标识唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sys_application
-- ----------------------------
INSERT INTO `sys_application` VALUES ('1316568552991358978', '2020-10-15 10:36:18', null, '2020-10-15 10:36:18', null, 'atlas', '元数据管理', 'qiankun', 'http://172.18.42.160:8081/atlas/', 'atlas', '{\"envFlag\": 7, \"orderIndex\": 2, \"useMainframeSideMenu\": false}', '1316568552957804545', '/atlas', null);
INSERT INTO `sys_application` VALUES ('1316921599819046914', '2020-10-16 09:59:11', null, '2020-10-16 09:59:11', null, 'datax-web', '调度平台', 'qiankun', 'http://172.18.42.160:28101', 'datax1', '{\"envFlag\": 3, \"orderIndex\": 1, \"useMainframeSideMenu\": true}', '1316921599789686786', '/datax-1', null);
INSERT INTO `sys_application` VALUES ('1318004311599452162', '2020-10-19 09:41:30', null, '2020-10-19 09:41:30', null, '数据质量', '数据质量', 'qiankun', 'http://172.18.42.160:28032', 'dqc', '{\"envFlag\": 3, \"orderIndex\": 3, \"useMainframeSideMenu\": false}', '1318004311586869250', '/dqc', null);
INSERT INTO `sys_application` VALUES ('1318010570289549313', '2020-10-19 10:06:22', null, '2020-10-19 10:06:22', null, 'datax-source', '数据接入', 'qiankun', 'http://172.18.42.160:28101/', 'dataxweb', '{\"envFlag\": 3, \"orderIndex\": 4, \"useMainframeSideMenu\": true}', '1318010570268577793', '/datax-2', null);
INSERT INTO `sys_application` VALUES ('1320894559324336130', '2020-10-27 09:06:19', null, '2020-10-27 09:06:19', null, 'offlineDev', '数据开发', 'qiankun', 'http://172.18.42.160:28051/', 'offlineDev', '{\"envFlag\": 3, \"useMainframeSideMenu\": true}', '1320894559286587393', '/offlineDev', null);
INSERT INTO `sys_application` VALUES ('1326423879484567553', '2020-11-11 15:17:51', null, '2020-11-11 15:17:51', null, 'visualis', '数据可视化', 'iframe', 'http://172.18.42.60:5002/dss/visualis/', 'visualis', '{\"envFlag\": 7, \"useMainframeSideMenu\": false}', '1326423879081914370', '/visualis', null);
INSERT INTO `sys_application` VALUES ('1326425657416478722', '2020-11-11 15:24:55', null, '2020-11-11 15:24:55', null, 'dataOperations', '数据运维', 'iframe', 'http://grafana.apps.k8s.software.dc/d/27_06B1Gk/dss?orgId=1', 'dataOperations', '{\"envFlag\": 7, \"useMainframeSideMenu\": false}', '1326425657395507202', '/dataOperations', null);
INSERT INTO `sys_application` VALUES ('1326438207331889153', '2020-11-11 16:14:47', null, '2020-11-11 16:14:47', null, 'dataService', '数据服务', 'qiankun', 'http://172.18.42.160:28031/', 'dataService', '{\"envFlag\": 7, \"useMainframeSideMenu\": true}', '1326438207281557506', '/dataServices', null);
INSERT INTO `sys_application` VALUES ('1326438936050266113', '2020-11-11 16:17:41', null, '2020-11-11 16:17:41', null, 'dataLabel', '数据标签', 'qiankun', 'http://172.18.42.160:28661/', 'data-label', '{\"envFlag\": 7, \"useMainframeSideMenu\": true}', '1326438936025100290', '/dataLabel', null);
INSERT INTO `sys_application` VALUES ('1328899687620931585', '2020-11-18 11:15:50', null, '2020-11-18 11:15:50', null, 'data-workflow', '数据工作流', 'qiankun', 'http://172.18.42.160:28051/', 'data-workflow', '{\"envFlag\": 3}', '1328899687604154369', '/dataWorkflow', null);
INSERT INTO `sys_application` VALUES ('1336200451202142209', '2020-12-08 14:46:28', null, '2020-12-08 14:46:28', null, 'standard', '数据标准', 'qiankun', 'http://172.18.42.160:28108/', 'standard-web', '{\"envFlag\": 3, \"useMainframeSideMenu\": true}', '1336200451172782081', '/standard', null);
INSERT INTO `sys_application` VALUES ('1347392737474314241', '2021-01-08 12:00:37', null, '2021-01-08 12:00:37', null, 'workflow-dispatch', '工作流调度', 'iframe', 'http://172.18.42.160:14024', 'workflow-dispatch', '{\"envFlag\": 0}', '1347392737415593985', '/workflowDispatch', null);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建用户ID',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后更新用户ID',
  `app_id` varchar(64) NOT NULL COMMENT '应用ID',
  `parent_id` varchar(64) DEFAULT NULL COMMENT '父菜单ID',
  `name` varchar(64) DEFAULT NULL COMMENT '菜单标签',
  `path` varchar(1024) DEFAULT NULL COMMENT '菜单路径',
  `icon` varchar(64) DEFAULT NULL COMMENT '菜单图标',
  `order_index` int(64) DEFAULT NULL COMMENT '菜单排序编号',
  `route_type` varchar(64) DEFAULT NULL COMMENT '路由跳转类型',
  `permission_key_path` varchar(255) DEFAULT NULL COMMENT '权限标识',
  `metadata` json DEFAULT NULL COMMENT '其他元数据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1321612511220346882', '2020-10-29 08:39:12', null, '2020-10-29 08:39:12', null, '1318004311599452162', '1337295060823207937', '概览', '/dqc/overview', null, '1', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1321624626777829377', '2020-10-29 09:27:20', null, '2020-10-29 09:27:20', null, '1318004311599452162', '1337295060823207937', '我的订阅', '/dqc/subscribe', null, '2', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1321626360250118145', '2020-10-29 09:34:14', null, '2020-10-29 09:34:14', null, '1318004311599452162', '1337295060823207937', '已配置规则', '/dqc/configuredRule', null, '3', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1321626436812943362', '2020-10-29 09:34:32', null, '2020-10-29 09:34:32', null, '1318004311599452162', '1337295060823207937', '规则配置', '/dqc/rule', null, '4', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1321626558573588481', '2020-10-29 09:35:01', null, '2020-10-29 09:35:01', null, '1318004311599452162', '1337295060823207937', '执行历史', '/dqc/history', null, '5', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1322061908412854273', '2020-10-30 14:24:56', null, '2020-10-30 14:24:56', null, '1318010570289549313', '1337295060865150977', '数据源管理', '/datax-2/datasource/datasource', null, '1', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1322091215503880194', '2020-10-30 16:21:24', null, '2020-10-30 16:21:24', null, '1318010570289549313', '1337295060865150977', '结构化数据接入', '/datax-2/jsonBuild', null, '2', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1322092068029722626', '2020-10-30 16:24:47', null, '2020-10-30 16:24:47', null, '1316921599819046914', '1337295060789653505', '执行器管理', '/datax-1/executor/executor', null, '1', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1322092375455428610', '2020-10-30 16:26:00', null, '2020-10-30 16:26:00', null, '1316921599819046914', '1337295060789653505', '任务模板', '/datax-1/jobTemplate/jobTemplate', null, '2', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1322092467600093186', '2020-10-30 16:26:22', null, '2020-10-30 16:26:22', null, '1316921599819046914', '1337295060789653505', '任务管理', '/datax-1/job/jobInfo', null, '3', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1322092579852251138', '2020-10-30 16:26:49', null, '2020-10-30 16:26:49', null, '1316921599819046914', '1337295060789653505', '日志管理', '/datax-1/jobLog/jobLog', null, '4', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1322092671330021378', '2020-10-30 16:27:11', null, '2020-10-30 16:27:11', null, '1316921599819046914', '1337295060789653505', '运行报表', '/datax-1/dashboard', null, '5', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1322092754775699457', '2020-10-30 16:27:31', null, '2020-10-30 16:27:31', null, '1316921599819046914', '1337295060789653505', '调度资源监控', '/datax-1/registry', null, '6', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1326424019381383169', '2020-11-11 15:18:25', null, '2020-11-11 15:18:25', null, '1326423879484567553', '1337295060940648449', '传感器数据', '/visualis/sensorData', '', '1', 'iframe', 'visualis');
INSERT INTO `sys_menu` VALUES ('1326425080905199617', '2020-11-11 15:22:38', null, '2020-11-11 15:22:38', null, '1370306190900248578', '1337295060974202881', '数据分级分类', '/data-secure', '', '1', 'none', 'data-secure');
INSERT INTO `sys_menu` VALUES ('1326425145140965378', '2020-11-11 15:22:53', null, '2020-11-11 15:22:53', null, '1370306190900248578', '1337295060974202881', '数据模块权限', '/data-secure', '', '2', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1326425216733540353', '2020-11-11 15:23:10', null, '2020-11-11 15:23:10', null, '1326424836146589698', '1337295060974202881', '数据安全规则', 'datasecurity/3', null, '3', 'none', null);
INSERT INTO `sys_menu` VALUES ('1326425741436776450', '2020-11-11 15:25:15', null, '2020-11-11 15:25:15', null, '1326425657416478722', '1337295061016145922', '运维概览', '/dataOperations/overview', '', '1', 'iframe', null);
INSERT INTO `sys_menu` VALUES ('1326425785489551361', '2020-11-11 15:25:26', null, '2020-11-11 15:25:26', null, '1326425657416478722', '1337295061016145922', '资源监控', 'dataOperations/2', null, '2', 'none', null);
INSERT INTO `sys_menu` VALUES ('1326425828225314818', '2020-11-11 15:25:36', null, '2020-11-11 15:25:36', null, '1326425657416478722', '1337295061016145922', '日志管理', 'dataOperations/3', null, '3', 'none', null);
INSERT INTO `sys_menu` VALUES ('1326437395243331585', '2020-11-11 16:11:34', null, '2020-11-11 16:11:34', null, '1318010570289549313', '1337295060865150977', '非结构化数据接入', '/datax-2/3', null, '3', 'none', null);
INSERT INTO `sys_menu` VALUES ('1326438400051769345', '2020-11-11 16:15:33', null, '2020-11-11 16:15:33', null, '1326438207331889153', '1337295061049700353', '数据', '/dataServices/dataServices/data', '', '1', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1326438628536479745', '2020-11-11 16:16:28', null, '2020-11-11 16:16:28', null, '1326438207331889153', '1337295061049700353', '数据服务', '/dataServices/dataServices/data-services', '', '2', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1326439056913330178', '2020-11-11 16:18:10', null, '2020-11-11 16:18:10', null, '1326438936050266113', '1337295061074866177', '主题管理', '/dataLabel/dataLabelThemes', null, '1', 'app_route', 'data-label');
INSERT INTO `sys_menu` VALUES ('1326439113637097473', '2020-11-11 16:18:23', null, '2020-11-11 16:18:23', null, '1326438936050266113', '1337295061074866177', '原子管理', '/dataLabel/dataLabelAtoms', null, '2', 'app_route', 'data-label');
INSERT INTO `sys_menu` VALUES ('1326439191688900610', '2020-11-11 16:18:42', null, '2020-11-11 16:18:42', null, '1326438936050266113', '1337295061074866177', '修饰类型管理', '/dataLabel/dataLabelDressTypes', null, '3', 'app_route', 'data-label');
INSERT INTO `sys_menu` VALUES ('1328856357512015873', '2020-11-18 08:23:39', null, '2020-11-18 08:23:39', null, '1326423879484567553', '1337295060940648449', '报警信息', '/visualis/alertInfo', '', '2', 'iframe', 'visualis');
INSERT INTO `sys_menu` VALUES ('1328856557026668546', '2020-11-18 08:24:27', null, '2020-11-18 08:24:27', null, '1328899687620931585', '1337295060907094017', '工作流开发', '/dataWorkflow', null, '1', 'app_route', 'data-workflow');
INSERT INTO `sys_menu` VALUES ('1332158955572817921', '2020-11-27 11:07:00', null, '2020-11-27 11:07:00', null, '1326423879484567553', '1337295060940648449', '出入信息', '/visualis/accessInfo', '', '3', 'iframe', 'visualis');
INSERT INTO `sys_menu` VALUES ('1334766707029700610', '2020-12-04 15:49:16', null, '2020-12-04 15:49:16', null, '1334764460560478210', '1337295061141975042', '项目管理', '/codegen/projects', null, '1', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1334766810058584066', '2020-12-04 15:49:41', null, '2020-12-04 15:49:41', null, '1334764460560478210', '1337295061141975042', '业务表管理', '/codegen/tables', null, '2', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1334766869689004034', '2020-12-04 15:49:55', null, '2020-12-04 15:49:55', null, '1334764460560478210', '1337295061141975042', '代码生成', '/codegen/codegen', null, '3', 'app_route', null);
INSERT INTO `sys_menu` VALUES ('1335760323889983489', '2020-12-07 09:37:33', null, '2020-12-07 09:37:33', null, '1335759024641404929', '1337295061183918081', '宠物管理', '/boilerplate/pets', null, '1', 'app_route', 'boilerplate:pet');
INSERT INTO `sys_menu` VALUES ('1336201621463289858', '2020-12-08 14:51:07', null, '2020-12-08 14:51:07', null, '1336200451202142209', '1337295061217472514', '标准文件', '/standard/welcome', null, '1', 'app_route', 'standard-web');
INSERT INTO `sys_menu` VALUES ('1337295060743516161', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1316568552991358978', null, '元数据管理', '/atlas', 'UnorderedList', '5', 'app_route', 'atlas');
INSERT INTO `sys_menu` VALUES ('1337295060789653505', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1316921599819046914', null, '调度平台', '/datax-1', null, '1', 'app_route', 'datax1');
INSERT INTO `sys_menu` VALUES ('1337295060823207937', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1318004311599452162', null, '数据质量', '/dqc', null, '3', 'app_route', 'dqc');
INSERT INTO `sys_menu` VALUES ('1337295060865150977', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1318010570289549313', null, '数据接入', '/datax-2', null, '2', 'app_route', 'dataxweb');
INSERT INTO `sys_menu` VALUES ('1337295060907094017', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1320894559324336130', null, '数据开发', '/offlineDev', null, '4', 'app_route', 'offlineDev');
INSERT INTO `sys_menu` VALUES ('1337295060940648449', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1326423879484567553', null, '数据可视化', '/visualis', '', '11', 'iframe', 'visualis');
INSERT INTO `sys_menu` VALUES ('1337295060974202881', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1370306190900248578', null, '数据安全', '/data-secure', '', '9', 'app_route', 'data-secure');
INSERT INTO `sys_menu` VALUES ('1337295061016145922', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1326425657416478722', null, '数据运维', '/dataOperations', '', '10', 'none', 'dataOperations');
INSERT INTO `sys_menu` VALUES ('1337295061049700353', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1326438207331889153', null, '数据服务', '/dataServices', null, '8', 'app_route', 'dataService');
INSERT INTO `sys_menu` VALUES ('1337295061074866177', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1326438936050266113', null, '数据标签', '/dataLabel', null, '7', 'app_route', 'data-label');
INSERT INTO `sys_menu` VALUES ('1337295061141975042', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1334764460560478210', null, '代码生成器', '/codegen', null, '13', 'app_route', 'codegen');
INSERT INTO `sys_menu` VALUES ('1337295061183918081', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1335759024641404929', null, '项目模板测试', '/boilerplate', null, '12', 'app_route', 'boilerplate');
INSERT INTO `sys_menu` VALUES ('1337295061217472514', '2020-12-11 15:16:03', null, '2020-12-11 15:16:03', null, '1336200451202142209', null, '数据标准', '/standard', null, '6', 'app_route', 'standard-web');
INSERT INTO `sys_menu` VALUES ('1340953908296101890', '2020-12-21 17:35:00', null, '2020-12-21 17:35:00', null, '1326438936050266113', '1337295061074866177', '修饰词管理', '/dataLabel/dataLabelDressWords', null, '4', 'app_route', 'data-label');
INSERT INTO `sys_menu` VALUES ('1340954014336495618', '2020-12-21 17:35:25', null, '2020-12-21 17:35:25', null, '1326438936050266113', '1337295061074866177', '派生类型', '/dataLabel/dataLabelDeriveIndicators', null, '5', 'app_route', 'data-label');
INSERT INTO `sys_menu` VALUES ('1347393020283650050', '2021-01-08 12:01:44', null, '2021-01-08 12:01:44', null, '1347392737474314241', '1337295060907094017', '工作流调度', '/workflowDispatch/entry', null, '2', 'iframe', 'workflow-dispatch');

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建用户ID',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后更新用户ID',
  `type` varchar(64) NOT NULL COMMENT '权限类型',
  `key_path` varchar(255) NOT NULL COMMENT '权限标识路径',
  `name` varchar(64) NOT NULL COMMENT '权限名称',
  `root_permission_id` varchar(64) DEFAULT NULL COMMENT '根权限ID',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES ('1', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'app', 'system', '系统功能', null, null);
INSERT INTO `sys_permission` VALUES ('1315929743287209986', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'composite', 'system:user', '系统用户管理', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743312375809', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'normal', 'system:user:list', '用户列表', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743337541634', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'normal', 'system:user:delete', '删除用户', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743358513154', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'normal', 'system:user:edit', '编辑用户', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743383678978', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'normal', 'system:user:detail', '用户详情', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743400456194', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'normal', 'system:user:add', '添加用户', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743421427714', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'composite', 'system:role', '系统角色管理', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743446593538', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'normal', 'system:role:delete', '删除角色', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743467565058', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'normal', 'system:role:add', '添加角色', '1', null);
INSERT INTO `sys_permission` VALUES ('1315929743505313794', '2020-10-13 16:17:54', null, '2020-10-13 16:17:54', null, 'normal', 'system:role:detail', '获取角色详情', '1', null);
INSERT INTO `sys_permission` VALUES ('1315930002142846978', '2020-10-13 16:18:56', null, '2020-10-13 16:18:56', null, 'normal', 'system:role:list', '获取角色列表', '1', null);
INSERT INTO `sys_permission` VALUES ('1315949702226644994', '2020-10-13 17:37:13', null, '2020-10-13 17:37:13', null, 'normal', 'system:role:edit', '编辑角色', '1', null);
INSERT INTO `sys_permission` VALUES ('1316268813720788994', '2020-10-14 14:45:15', null, '2020-10-14 14:45:15', null, 'normal', 'system:role:permission', '配置角色权限', '1', null);
INSERT INTO `sys_permission` VALUES ('1316268813766926337', '2020-10-14 14:45:15', null, '2020-10-14 14:45:15', null, 'normal', 'system:user:role', '配置用户角色', '1', null);
INSERT INTO `sys_permission` VALUES ('1316545639949090818', '2020-10-15 09:05:15', null, '2020-10-15 09:05:15', null, 'composite', 'system:application', '系统应用管理', '1', null);
INSERT INTO `sys_permission` VALUES ('1316557807914352641', '2020-10-15 09:53:37', null, '2020-10-15 09:53:37', null, 'normal', 'system:application:delete', '删除应用', '1', null);
INSERT INTO `sys_permission` VALUES ('1316557807968878593', '2020-10-15 09:53:37', null, '2020-10-15 09:53:37', null, 'normal', 'system:application:edit', '同步权限信息', '1', null);
INSERT INTO `sys_permission` VALUES ('1316557808002433025', '2020-10-15 09:53:37', null, '2020-10-15 09:53:37', null, 'normal', 'system:application:list', '获取应用列表', '1', null);
INSERT INTO `sys_permission` VALUES ('1316557808077930497', '2020-10-15 09:53:37', null, '2020-10-15 09:53:37', null, 'normal', 'system:application:add', '添加应用', '1', null);
INSERT INTO `sys_permission` VALUES ('1316557808103096322', '2020-10-15 09:53:37', null, '2020-10-15 09:53:37', null, 'normal', 'system:application:detail', '获取应用详情', '1', null);
INSERT INTO `sys_permission` VALUES ('1316568552957804545', '2020-10-15 10:36:18', null, '2020-10-15 10:36:18', null, 'app', 'atlas', '元数据管理', null, null);
INSERT INTO `sys_permission` VALUES ('1316921599789686786', '2020-10-16 09:59:11', null, '2020-10-16 09:59:11', null, 'app', 'datax1', '调度平台', null, null);
INSERT INTO `sys_permission` VALUES ('1318004311586869250', '2020-10-19 09:41:30', null, '2020-10-19 09:41:30', null, 'app', 'dqc', '数据质量', null, null);
INSERT INTO `sys_permission` VALUES ('1318010570268577793', '2020-10-19 10:06:22', null, '2020-10-19 10:06:22', null, 'app', 'dataxweb', '数据接入', null, null);
INSERT INTO `sys_permission` VALUES ('1320555071045373954', '2020-10-26 10:37:18', null, '2020-10-26 10:37:18', null, 'app', 'datax1', '111', null, null);
INSERT INTO `sys_permission` VALUES ('1320894559286587393', '2020-10-27 09:06:19', null, '2020-10-27 09:06:19', null, 'app', 'offlineDev', '数据开发', null, null);
INSERT INTO `sys_permission` VALUES ('1321343833539133442', '2020-10-28 14:51:34', null, '2020-10-28 14:51:34', null, 'composite', 'system:menu', '系统菜单管理', '1', null);
INSERT INTO `sys_permission` VALUES ('1321343833560104962', '2020-10-28 14:51:34', null, '2020-10-28 14:51:34', null, 'normal', 'system:menu:delete', '删除菜单', '1', null);
INSERT INTO `sys_permission` VALUES ('1321343833576882178', '2020-10-28 14:51:34', null, '2020-10-28 14:51:34', null, 'normal', 'system:menu:list', '获取菜单列表', '1', null);
INSERT INTO `sys_permission` VALUES ('1321343833593659393', '2020-10-28 14:51:34', null, '2020-10-28 14:51:34', null, 'normal', 'system:menu:add', '添加菜单', '1', null);
INSERT INTO `sys_permission` VALUES ('1321343833606242305', '2020-10-28 14:51:34', null, '2020-10-28 14:51:34', null, 'normal', 'system:menu:detail', '获取菜单详情', '1', null);
INSERT INTO `sys_permission` VALUES ('1321343833623019521', '2020-10-28 14:51:34', null, '2020-10-28 14:51:34', null, 'normal', 'system:menu:edit', '编辑菜单', '1', null);
INSERT INTO `sys_permission` VALUES ('1326423879081914370', '2020-11-11 15:17:51', null, '2020-11-11 15:17:51', null, 'app', 'visualis', '数据可视化', null, null);
INSERT INTO `sys_permission` VALUES ('1326424836117229570', '2020-11-11 15:21:39', null, '2020-11-11 15:21:39', null, 'app', 'datasecurity', '数据安全', null, null);
INSERT INTO `sys_permission` VALUES ('1326425657395507202', '2020-11-11 15:24:55', null, '2020-11-11 15:24:55', null, 'app', 'dataOperations', '数据运维', null, null);
INSERT INTO `sys_permission` VALUES ('1326438207281557506', '2020-11-11 16:14:47', null, '2020-11-11 16:14:47', null, 'app', 'dataService', '数据服务', null, null);
INSERT INTO `sys_permission` VALUES ('1326438936025100290', '2020-11-11 16:17:41', null, '2020-11-11 16:17:41', null, 'app', 'data-label', '数据标签', null, null);
INSERT INTO `sys_permission` VALUES ('1328899687604154369', '2020-11-18 11:15:50', null, '2020-11-18 11:15:50', null, 'app', 'data-workflow', '数据工作流', null, null);
INSERT INTO `sys_permission` VALUES ('1336200451172782081', '2020-12-08 14:46:28', null, '2020-12-08 14:46:28', null, 'app', 'standard-web', '数据标准', null, null);
INSERT INTO `sys_permission` VALUES ('1336597842034212865', '2020-12-09 17:05:33', null, '2020-12-09 17:05:33', null, 'composite', 'boilerplate:pet', '宠物管理', '1335759024603656194', null);
INSERT INTO `sys_permission` VALUES ('1336597842063572993', '2020-12-09 17:05:33', null, '2020-12-09 17:05:33', null, 'normal', 'boilerplate:pet:delete', '删除宠物', '1335759024603656194', null);
INSERT INTO `sys_permission` VALUES ('1336597842080350209', '2020-12-09 17:05:33', null, '2020-12-09 17:05:33', null, 'normal', 'boilerplate:pet:list', '获取宠物列表', '1335759024603656194', null);
INSERT INTO `sys_permission` VALUES ('1336597842105516033', '2020-12-09 17:05:33', null, '2020-12-09 17:05:33', null, 'normal', 'boilerplate:pet:detail', '获取宠物详情', '1335759024603656194', null);
INSERT INTO `sys_permission` VALUES ('1336597842122293249', '2020-12-09 17:05:33', null, '2020-12-09 17:05:33', null, 'normal', 'boilerplate:pet:edit', '编辑宠物', '1335759024603656194', null);
INSERT INTO `sys_permission` VALUES ('1336597842139070466', '2020-12-09 17:05:33', null, '2020-12-09 17:05:33', null, 'normal', 'boilerplate:pet:add', '添加宠物', '1335759024603656194', null);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建用户ID',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后更新用户ID',
  `role_key` varchar(255) NOT NULL COMMENT '角色标识',
  `name` varchar(255) DEFAULT NULL COMMENT '角色名称',
  `status_flag` int(64) NOT NULL DEFAULT '0' COMMENT '角色状态标识',
  `remarks` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_role_key` (`role_key`) USING BTREE COMMENT '角色标识唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统角色表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1316182259027460097', '2020-10-14 09:01:19', null, '2020-10-14 09:01:19', null, 'test-admin', '测试管理员', '0', '123');
INSERT INTO `sys_role` VALUES ('1334764189239341057', '2020-12-04 15:39:16', null, '2020-12-04 15:39:16', null, 'developer', '开发者', '0', null);

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建用户ID',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后更新用户ID',
  `role_id` varchar(64) NOT NULL COMMENT '角色ID',
  `permission_id` varchar(64) NOT NULL COMMENT '权限ID',
  `role_key` varchar(255) NOT NULL COMMENT '角色标识',
  `permission_key_path` varchar(255) NOT NULL COMMENT '权限标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
INSERT INTO `sys_role_permission` VALUES ('1336205568483708929', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1', 'test-admin', 'system');
INSERT INTO `sys_role_permission` VALUES ('1336205568492097538', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743287209986', 'test-admin', 'system:user');
INSERT INTO `sys_role_permission` VALUES ('1336205568492097539', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743312375809', 'test-admin', 'system:user:list');
INSERT INTO `sys_role_permission` VALUES ('1336205568492097540', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743337541634', 'test-admin', 'system:user:delete');
INSERT INTO `sys_role_permission` VALUES ('1336205568496291842', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743358513154', 'test-admin', 'system:user:edit');
INSERT INTO `sys_role_permission` VALUES ('1336205568496291843', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743383678978', 'test-admin', 'system:user:detail');
INSERT INTO `sys_role_permission` VALUES ('1336205568500486145', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743400456194', 'test-admin', 'system:user:add');
INSERT INTO `sys_role_permission` VALUES ('1336205568500486146', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743421427714', 'test-admin', 'system:role');
INSERT INTO `sys_role_permission` VALUES ('1336205568500486147', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743446593538', 'test-admin', 'system:role:delete');
INSERT INTO `sys_role_permission` VALUES ('1336205568504680449', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743467565058', 'test-admin', 'system:role:add');
INSERT INTO `sys_role_permission` VALUES ('1336205568504680450', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315929743505313794', 'test-admin', 'system:role:detail');
INSERT INTO `sys_role_permission` VALUES ('1336205568504680451', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315930002142846978', 'test-admin', 'system:role:list');
INSERT INTO `sys_role_permission` VALUES ('1336205568508874754', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1315949702226644994', 'test-admin', 'system:role:edit');
INSERT INTO `sys_role_permission` VALUES ('1336205568508874755', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316268813720788994', 'test-admin', 'system:role:permission');
INSERT INTO `sys_role_permission` VALUES ('1336205568508874756', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316268813766926337', 'test-admin', 'system:user:role');
INSERT INTO `sys_role_permission` VALUES ('1336205568513069057', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316545639949090818', 'test-admin', 'system:application');
INSERT INTO `sys_role_permission` VALUES ('1336205568513069058', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316557807914352641', 'test-admin', 'system:application:delete');
INSERT INTO `sys_role_permission` VALUES ('1336205568517263361', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316557807968878593', 'test-admin', 'system:application:edit');
INSERT INTO `sys_role_permission` VALUES ('1336205568521457666', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316557808002433025', 'test-admin', 'system:application:list');
INSERT INTO `sys_role_permission` VALUES ('1336205568521457667', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316557808077930497', 'test-admin', 'system:application:add');
INSERT INTO `sys_role_permission` VALUES ('1336205568521457668', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316557808103096322', 'test-admin', 'system:application:detail');
INSERT INTO `sys_role_permission` VALUES ('1336205568525651970', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316568552957804545', 'test-admin', 'atlas');
INSERT INTO `sys_role_permission` VALUES ('1336205568525651971', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1316921599789686786', 'test-admin', 'datax1');
INSERT INTO `sys_role_permission` VALUES ('1336205568525651972', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1318004311586869250', 'test-admin', 'dqc');
INSERT INTO `sys_role_permission` VALUES ('1336205568529846274', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1318010570268577793', 'test-admin', 'dataxweb');
INSERT INTO `sys_role_permission` VALUES ('1336205568529846275', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1320555071045373954', 'test-admin', 'datax1');
INSERT INTO `sys_role_permission` VALUES ('1336205568529846276', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1320894559286587393', 'test-admin', 'offlineDev');
INSERT INTO `sys_role_permission` VALUES ('1336205568534040578', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1321343833539133442', 'test-admin', 'system:menu');
INSERT INTO `sys_role_permission` VALUES ('1336205568534040579', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1321343833560104962', 'test-admin', 'system:menu:delete');
INSERT INTO `sys_role_permission` VALUES ('1336205568534040580', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1321343833576882178', 'test-admin', 'system:menu:list');
INSERT INTO `sys_role_permission` VALUES ('1336205568538234882', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1321343833593659393', 'test-admin', 'system:menu:add');
INSERT INTO `sys_role_permission` VALUES ('1336205568538234883', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1321343833606242305', 'test-admin', 'system:menu:detail');
INSERT INTO `sys_role_permission` VALUES ('1336205568538234884', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1321343833623019521', 'test-admin', 'system:menu:edit');
INSERT INTO `sys_role_permission` VALUES ('1336205568542429186', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1326423879081914370', 'test-admin', 'visualis');
INSERT INTO `sys_role_permission` VALUES ('1336205568542429187', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1326424836117229570', 'test-admin', 'datasecurity');
INSERT INTO `sys_role_permission` VALUES ('1336205568542429188', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1326425657395507202', 'test-admin', 'dataOperations');
INSERT INTO `sys_role_permission` VALUES ('1336205568546623490', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1326438207281557506', 'test-admin', 'dataService');
INSERT INTO `sys_role_permission` VALUES ('1336205568546623491', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1326438936025100290', 'test-admin', 'dataLabel');
INSERT INTO `sys_role_permission` VALUES ('1336205568546623492', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1328899687604154369', 'test-admin', 'data-workflow');
INSERT INTO `sys_role_permission` VALUES ('1336205568550817793', '2020-12-08 15:06:48', null, '2020-12-08 15:06:48', null, '1316182259027460097', '1336200451172782081', 'test-admin', 'standard-web');
INSERT INTO `sys_role_permission` VALUES ('1336850452393803778', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1', 'developer', 'system');
INSERT INTO `sys_role_permission` VALUES ('1336850452393803779', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743287209986', 'developer', 'system:user');
INSERT INTO `sys_role_permission` VALUES ('1336850452393803780', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743312375809', 'developer', 'system:user:list');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192385', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743337541634', 'developer', 'system:user:delete');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192386', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743358513154', 'developer', 'system:user:edit');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192387', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743383678978', 'developer', 'system:user:detail');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192388', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743400456194', 'developer', 'system:user:add');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192389', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743421427714', 'developer', 'system:role');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192390', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743446593538', 'developer', 'system:role:delete');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192391', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743467565058', 'developer', 'system:role:add');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192392', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315929743505313794', 'developer', 'system:role:detail');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192393', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315930002142846978', 'developer', 'system:role:list');
INSERT INTO `sys_role_permission` VALUES ('1336850452402192394', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1315949702226644994', 'developer', 'system:role:edit');
INSERT INTO `sys_role_permission` VALUES ('1336850452410580993', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1316268813720788994', 'developer', 'system:role:permission');
INSERT INTO `sys_role_permission` VALUES ('1336850452410580994', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1316268813766926337', 'developer', 'system:user:role');
INSERT INTO `sys_role_permission` VALUES ('1336850452410580995', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1316545639949090818', 'developer', 'system:application');
INSERT INTO `sys_role_permission` VALUES ('1336850452410580996', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1316557807914352641', 'developer', 'system:application:delete');
INSERT INTO `sys_role_permission` VALUES ('1336850452410580997', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1316557807968878593', 'developer', 'system:application:edit');
INSERT INTO `sys_role_permission` VALUES ('1336850452410580998', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1316557808002433025', 'developer', 'system:application:list');
INSERT INTO `sys_role_permission` VALUES ('1336850452410580999', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1316557808077930497', 'developer', 'system:application:add');
INSERT INTO `sys_role_permission` VALUES ('1336850452410581000', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1316557808103096322', 'developer', 'system:application:detail');
INSERT INTO `sys_role_permission` VALUES ('1336850452410581001', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1321343833539133442', 'developer', 'system:menu');
INSERT INTO `sys_role_permission` VALUES ('1336850452410581002', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1321343833560104962', 'developer', 'system:menu:delete');
INSERT INTO `sys_role_permission` VALUES ('1336850452410581003', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1321343833576882178', 'developer', 'system:menu:list');
INSERT INTO `sys_role_permission` VALUES ('1336850452418969601', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1321343833593659393', 'developer', 'system:menu:add');
INSERT INTO `sys_role_permission` VALUES ('1336850452418969602', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1321343833606242305', 'developer', 'system:menu:detail');
INSERT INTO `sys_role_permission` VALUES ('1336850452418969603', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1321343833623019521', 'developer', 'system:menu:edit');
INSERT INTO `sys_role_permission` VALUES ('1336850452418969604', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1334764460547895298', 'developer', 'codegen');
INSERT INTO `sys_role_permission` VALUES ('1336850452418969605', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1335759024603656194', 'developer', 'boilerplate');
INSERT INTO `sys_role_permission` VALUES ('1336850452418969606', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1336597842034212865', 'developer', 'boilerplate:pet');
INSERT INTO `sys_role_permission` VALUES ('1336850452418969607', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1336597842063572993', 'developer', 'boilerplate:pet:delete');
INSERT INTO `sys_role_permission` VALUES ('1336850452427358210', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1336597842080350209', 'developer', 'boilerplate:pet:list');
INSERT INTO `sys_role_permission` VALUES ('1336850452427358211', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1336597842105516033', 'developer', 'boilerplate:pet:detail');
INSERT INTO `sys_role_permission` VALUES ('1336850452427358212', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1336597842122293249', 'developer', 'boilerplate:pet:edit');
INSERT INTO `sys_role_permission` VALUES ('1336850452427358213', '2020-12-10 09:49:20', null, '2020-12-10 09:49:20', null, '1334764189239341057', '1336597842139070466', 'developer', 'boilerplate:pet:add');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建用户ID',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后更新用户ID',
  `username` varchar(64) NOT NULL COMMENT '用户账号',
  `nickname` varchar(64) DEFAULT NULL COMMENT '用户昵称',
  `password` varchar(255) NOT NULL COMMENT '用户密码(hash)',
  `status_flag` int(64) NOT NULL DEFAULT '0' COMMENT '用户状态标识',
  `avatar` varchar(255) DEFAULT NULL COMMENT '用户头像',
  `email` varchar(64) DEFAULT NULL COMMENT '用户邮箱',
  `gender` varchar(64) DEFAULT NULL COMMENT '用户性别',
  `metadata` json DEFAULT NULL COMMENT '用户元数据',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_username` (`username`) USING BTREE COMMENT '用户名唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统用户表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('0', '2020-10-10 17:32:41', null, '2020-10-10 17:32:41', null, 'admin', '超级管理员', '$2a$06$47zuyKPyTew5AnpMOVpR0O/HK90CRef95pAhLX/On4KqUt0g6CiYe', '1', null, null, null);
INSERT INTO `sys_user` VALUES ('1316270784842342401', '2020-10-14 14:53:05', null, '2020-10-14 14:53:05', null, 'user1', '演示用户1', '$2a$06$QxMALwQgf.zCnGXau4iTkOvR8bLoyOFu2g26kZNXdl7pcDCZHSgS6', '0', null, null, 'male');
INSERT INTO `sys_user` VALUES ('1334764094443876354', '2020-12-04 15:38:53', null, '2020-12-04 15:38:53', null, 'dev', 'developer', '$2a$06$JyaZi8xSY49aiOAbf2.N8e5xrI65Z1Qu5kBxOayQ245Dy3p1JXkry', '0', null, null, 'male');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建用户ID',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后更新用户ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '用户ID',
  `role_id` varchar(64) DEFAULT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES ('1316293085549862913', '2020-10-14 16:21:42', null, '2020-10-14 16:21:42', null, '1316270784842342401', '1316182259027460097');
INSERT INTO `sys_user_role` VALUES ('1334764220566597633', '2020-12-04 15:39:24', null, '2020-12-04 15:39:24', null, '1334764094443876354', '1334764189239341057');

-- ----------------------------
-- Table structure for table_template
-- ----------------------------
DROP TABLE IF EXISTS `table_template`;
CREATE TABLE `table_template` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建用户ID',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后更新用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of table_template
-- ----------------------------
