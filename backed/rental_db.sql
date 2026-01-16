/*
 Navicat Premium Dump SQL

 Source Server         : root
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : rental_db

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 16/01/2026 10:21:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for contract
-- ----------------------------
DROP TABLE IF EXISTS `contract`;
CREATE TABLE `contract`  (
  `contract_id` int NOT NULL AUTO_INCREMENT,
  `contract_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_id` int NULL DEFAULT NULL,
  `factory_id` int NULL DEFAULT NULL,
  `start_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `end_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `total_price` float NULL DEFAULT NULL,
  `status` int NULL DEFAULT 0,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `party_a` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '园区资产管理有限公司' COMMENT '甲方',
  `party_b` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '乙方',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '合同详细条款',
  `sign_date` datetime NULL DEFAULT NULL COMMENT '签订日期',
  `party_a_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '山西省太原市小店区坞城路92号' COMMENT '甲方地址',
  `party_a_legal_rep` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '王经理' COMMENT '甲方法人代表',
  `party_a_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0351-7010000' COMMENT '甲方电话',
  `party_b_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '乙方地址',
  `party_b_legal_rep` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '乙方法人代表',
  `party_b_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '乙方电话',
  `purpose` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '工业生产/仓储' COMMENT '租赁用途',
  `deposit` float NULL DEFAULT 0 COMMENT '履约保证金(元)',
  `payment_cycle` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '季度支付' COMMENT '支付方式(月付/季付/年付)',
  PRIMARY KEY (`contract_id`) USING BTREE,
  UNIQUE INDEX `contract_no`(`contract_no` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `factory_id`(`factory_id` ASC) USING BTREE,
  CONSTRAINT `contract_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `contract_ibfk_2` FOREIGN KEY (`factory_id`) REFERENCES `factory_info` (`factory_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of contract
-- ----------------------------
INSERT INTO `contract` VALUES (1, 'CTR20260113001', 2, 1, '2026-01-01', '2026-12-31', 540000, 1, '2026-01-01 10:00:00', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (2, 'CTR20260113002', 2, 2, '2026-02-01', '2027-02-01', 384000, 2, '2026-01-10 14:30:00', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (3, 'CTR20260113003', 2, 3, '2026-03-01', '2026-09-01', 48000, 1, '2026-01-12 09:15:00', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (4, 'CTR20260113004', 2, 4, '2026-05-01', '2027-05-01', 240000, 1, '2026-01-13 08:00:00', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (6, 'CTR20260120002', 2, 2, '2026-02-01', '2027-02-01', 60000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (9, 'CTR20260120005', 2, 1, '2026-05-01', '2027-05-01', 55000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (10, 'CTR101724224913145856', 2, 1, '2026-01-01', '2026-12-31', 540000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (11, 'CTR101724224913145857', 2, 2, '2026-02-01', '2027-02-01', 384000, 2, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (12, 'CTR101724224913145858', 2, 3, '2026-03-01', '2026-09-01', 48000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (13, 'CTR101724224913145859', 2, 4, '2026-05-01', '2027-05-01', 240000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (14, 'CTR101724224913145860', 2, 1, '2026-01-01', '2027-01-01', 50000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (17, 'CTR101724224913145861', 2, 1, '2026-01-01', '2026-12-31', 540000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (18, 'CTR101724224913145862', 2, 2, '2026-02-01', '2027-02-01', 384000, 2, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (19, 'CTR101724224913145863', 2, 3, '2026-03-01', '2026-09-01', 48000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (20, 'CTR101724224913145864', 2, 4, '2026-05-01', '2027-05-01', 240000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (21, 'CTR101724224913145865', 2, 1, '2026-01-01', '2027-01-01', 50000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (22, 'CTR101724224913145866', 2, 2, '2026-02-01', '2027-02-01', 60000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (23, 'CTR101724224913145867', 2, 3, '2026-03-01', '2027-03-01', 70000, 2, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (24, 'CTR101724224913145868', 2, 4, '2026-04-01', '2027-04-01', 80000, 0, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (25, 'CTR101724224913145869', 2, 1, '2026-05-01', '2027-05-01', 55000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (26, 'CTR101724224913145870', 2, 1, '2026-01-01', '2026-12-31', 540000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (32, 'CTR101724224913145871', 2, 1, '2026-01-01', '2026-12-31', 540000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (33, 'CTR101724224913145872', 2, 2, '2026-02-01', '2027-02-01', 384000, 2, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (34, 'CTR101724224913145873', 2, 3, '2026-03-01', '2026-09-01', 48000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (35, 'CTR101724224913145874', 2, 4, '2026-05-01', '2027-05-01', 240000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (36, 'CTR101724224913145875', 2, 1, '2026-01-01', '2027-01-01', 50000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (37, 'CTR101724224913145876', 2, 2, '2026-02-01', '2027-02-01', 60000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (38, 'CTR101724224913145877', 2, 3, '2026-03-01', '2027-03-01', 70000, 2, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (39, 'CTR101724224913145878', 2, 4, '2026-04-01', '2027-04-01', 80000, 0, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (40, 'CTR101724224913145879', 2, 1, '2026-05-01', '2027-05-01', 55000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (41, 'CTR101724224913145880', 2, 1, '2026-01-01', '2026-12-31', 540000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (42, 'CTR101724224913145881', 2, 2, '2026-02-01', '2027-02-01', 384000, 2, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (43, 'CTR101724224913145882', 2, 3, '2026-03-01', '2026-09-01', 48000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (44, 'CTR101724224913145883', 2, 4, '2026-05-01', '2027-05-01', 240000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (45, 'CTR101724224913145884', 2, 1, '2026-01-01', '2027-01-01', 50000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (46, 'CTR101724224913145885', 2, 1, '2026-01-01', '2026-12-31', 540000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (47, 'CTR101724224913145886', 2, 2, '2026-02-01', '2027-02-01', 384000, 2, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (48, 'CTR101724224913145887', 2, 3, '2026-03-01', '2026-09-01', 48000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (49, 'CTR101724224913145888', 2, 4, '2026-05-01', '2027-05-01', 240000, 1, '2026-01-13 16:44:24', '园区资产管理有限公司', NULL, NULL, NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (50, 'CTR101724224913145889', 2, 1, '2026-01-01', '2027-01-01', 50000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (51, 'CTR101724224913145890', 2, 2, '2026-02-01', '2027-02-01', 60000, 1, '2026-01-13 16:44:24', '园区管理方', '张三科技', '第一条：租赁物详情...', NULL, '山西省太原市小店区坞城路92号', '王经理', '0351-7010000', '太原市高新区科技街88号', '张三', '13800138000', '工业生产/仓储', 10000, '按季度支付');
INSERT INTO `contract` VALUES (63, 'CTR1768362393', 1, 14, '2026-03-01', '2027-03-01', 672000, 0, '2026-01-14 11:46:34', '园区资产管理方', 'guido', '第一条：租赁物详情...\n第二条：租金支付...', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `contract` VALUES (64, 'CTR202601158112', 2, 20, '2026-01-06', '2026-02-03', 15000, 1, '2026-01-15 10:14:35', '园区管理方', '李想', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1111', '111', NULL, NULL);
INSERT INTO `contract` VALUES (65, 'CTR202601156456', 2, 70, '2026-01-15', '2029-01-15', 42000, 1, '2026-01-15 11:44:21', '园区管理方', '李想', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '15855069654', '进行冷冻产品的存放', NULL, NULL);
INSERT INTO `contract` VALUES (66, 'CTR202601153232', 2, 64, '2026-01-15', '2027-01-15', 18000, 0, '2026-01-15 11:51:04', '园区管理方', '李想', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'addsa\'s\'d', 'asda\'s\'da\'s\'d', NULL, NULL);
INSERT INTO `contract` VALUES (67, 'CTR202601157617', 2, 70, '2026-01-15 00:00:00', '2027-01-15 00:00:00', 511000, 0, '2026-01-15 11:57:29', '园区管理方', '李想', '\n    【工业园区厂房租赁合同】\n\n    合同编号：CTR202601157617\n    出租方（甲方）：智慧工业园区管理中心\n    承租方（乙方）：李想\n    联系电话：sdaasd\n\n    一、租赁标的\n    甲方同意将位于 D区-D30 的厂房（D区-冷冻食品加工-D30）出租给乙方使用，建筑面积 1100.0 平方米。\n\n    二、租赁期限\n    自 2026-01-15 起至 2027-01-15 止。\n\n    三、租赁费用\n    每月租金人民币 42000.0 元。\n    合同期内预计总租金：511000.0 元。\n\n    四、租赁用途\n    乙方承诺租赁该厂房用于：dasda。\n\n    五、补充条款（由乙方申请时提出）\n    1. ASDAS\n2. ASDAS\n3. DSDSDS\n\n    六、违约责任\n    双方应严格遵守本合同，任何一方违约需承担法律责任。\n\n    签署日期：2026年01月15日\n    ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `contract` VALUES (68, 'CTR202601158986', 2, 68, '2026-01-15 00:00:00', '2027-01-15 00:00:00', 608333, 0, '2026-01-15 13:16:33', '园区管理方', '李想', '\n    【工业园区厂房租赁合同】\n\n    合同编号：CTR202601158986\n    出租方（甲方）：智慧工业园区管理中心\n    承租方（乙方）：李想\n    联系电话：15755069623\n\n    一、租赁标的\n    甲方同意将位于 B区-B45 的厂房（B区-快递中转场-B45）出租给乙方使用，建筑面积 3000.0 平方米。\n\n    二、租赁期限\n    自 2026-01-15 起至 2027-01-15 止。\n\n    三、租赁费用\n    每月租金人民币 50000.0 元。\n    合同期内预计总租金：608333.33 元。\n\n    四、租赁用途\n    乙方承诺租赁该厂房用于：1111。\n\n    五、补充条款（由乙方申请时提出）\n    1. 1111\n2. 1111\n3. 1111\n\n    六、违约责任\n    双方应严格遵守本合同，任何一方违约需承担法律责任。\n\n    签署日期：2026年01月15日\n    ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `contract` VALUES (69, 'CTR202601159405', 2, 70, '2026-01-15 00:00:00', '2027-01-15 00:00:00', 511000, 0, '2026-01-15 13:18:00', '园区管理方', '李想', '【工业园区厂房租赁合同】\n\n合同编号：CTR202601159405\n出租方（甲方）：智慧工业园区管理中心\n承租方（乙方）：李想\n联系电话：sdfds\'f\'s\'d\'f\'d\'s\n\n一、租赁标的\n甲方同意将位于 D区-D30 的厂房（D区-冷冻食品加工-D30）出租给乙方使用，建筑面积 1100.0 平方米。\n\n二、租赁期限\n自 2026-01-15 起至 2027-01-15 止。\n\n三、租赁费用\n每月租金人民币 42000.0 元。\n合同期内预计总租金：511000.0 元。\n\n四、租赁用途\n乙方承诺租赁该厂房用于：dffs\'d\'f。\n\n五、补充条款（由乙方申请时提出）\n1. fdsf\'s\'dfsd\n\n六、违约责任\n双方应严格遵守本合同，任何一方违约需承担法律责任。\n\n签署日期：2026年01月15日', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `contract` VALUES (70, 'CTR202601155892', 2, 70, '2026-01-15 00:00:00', '2027-01-15 00:00:00', 511000, 0, '2026-01-15 13:18:05', '园区管理方', '李想', '【工业园区厂房租赁合同】\n\n合同编号：CTR202601155892\n出租方（甲方）：智慧工业园区管理中心\n承租方（乙方）：李想\n联系电话：sdfds\'f\'s\'d\'f\'d\'s\n\n一、租赁标的\n甲方同意将位于 D区-D30 的厂房（D区-冷冻食品加工-D30）出租给乙方使用，建筑面积 1100.0 平方米。\n\n二、租赁期限\n自 2026-01-15 起至 2027-01-15 止。\n\n三、租赁费用\n每月租金人民币 42000.0 元。\n合同期内预计总租金：511000.0 元。\n\n四、租赁用途\n乙方承诺租赁该厂房用于：dffs\'d\'f。\n\n五、补充条款（由乙方申请时提出）\n1. d\'f\'s\'d\'f\n2. f\'s\'d\'f\'s\'dfsdfsd\n\n六、违约责任\n双方应严格遵守本合同，任何一方违约需承担法律责任。\n\n签署日期：2026年01月15日', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `contract` VALUES (71, 'CTR202601163130', 4, 10, '2026-01-16 00:00:00', '2027-01-16 00:00:00', 365000, 1, '2026-01-16 09:24:35', '园区管理方', 'yangmianqi', '【工业园区厂房租赁合同】\n\n合同编号：CTR202601163130\n出租方（甲方）：智慧工业园区管理中心\n承租方（乙方）：yangmianqi\n联系电话：15755069456\n\n一、租赁标的\n甲方同意将位于 工业园区A区-108号 的厂房（A区-108 闲置旧厂房（低价转租））出租给乙方使用，建筑面积 2000.0 平方米。\n\n二、租赁期限\n自 2026-01-16 起至 2027-01-16 止。\n\n三、租赁费用\n每月租金人民币 30000.0 元。\n合同期内预计总租金：365000.0 元。\n\n四、租赁用途\n乙方承诺租赁该厂房用于：测试。\n\n五、补充条款（由乙方申请时提出）\n1. 测试\n2. 测试\n3. 测试\n4. 测试\n5. 测试\n\n六、违约责任\n双方应严格遵守本合同，任何一方违约需承担法律责任。\n\n签署日期：2026年01月16日', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `contract` VALUES (72, 'CTR202601163086', 4, 4, '2026-01-16 00:00:00', '2027-01-16 00:00:00', 730000, 0, '2026-01-16 09:32:35', '园区管理方', 'yangmianqi', '【工业园区厂房租赁合同】\n\n合同编号：CTR202601163086\n出租方（甲方）：智慧工业园区管理中心\n承租方（乙方）：yangmianqi\n联系电话：16545878561\n\n一、租赁标的\n甲方同意将位于 工业园区D区-501号 的厂房（D区-501 独栋企业总部办公楼）出租给乙方使用，建筑面积 1200.0 平方米。\n\n二、租赁期限\n自 2026-01-16 起至 2027-01-16 止。\n\n三、租赁费用\n每月租金人民币 60000.0 元。\n合同期内预计总租金：730000.0 元。\n\n四、租赁用途\n乙方承诺租赁该厂房用于：12333。\n\n五、补充条款（由乙方申请时提出）\n1. 12345\n2. 12345\n3. 12345\n\n六、违约责任\n双方应严格遵守本合同，任何一方违约需承担法律责任。\n\n签署日期：2026年01月16日', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `contract` VALUES (73, 'CTR202601169824', 4, 10, '2026-01-16 00:00:00', '2027-01-16 00:00:00', 365000, 1, '2026-01-16 09:41:57', '园区管理方', 'yangmianqi', '【工业园区厂房租赁合同】\n\n合同编号：CTR202601169824\n出租方（甲方）：智慧工业园区管理中心\n承租方（乙方）：yangmianqi\n联系电话：15755069623\n\n一、租赁标的\n甲方同意将位于 工业园区A区-108号 的厂房（A区-108 闲置旧厂房（低价转租））出租给乙方使用，建筑面积 2000.0 平方米。\n\n二、租赁期限\n自 2026-01-16 起至 2027-01-16 止。\n\n三、租赁费用\n每月租金人民币 30000.0 元。\n合同期内预计总租金：365000.0 元。\n\n四、租赁用途\n乙方承诺租赁该厂房用于：sdad。\n\n五、补充条款（由乙方申请时提出）\n1. dasda\n2. asdasd\n3. dasdas\n\n六、违约责任\n双方应严格遵守本合同，任何一方违约需承担法律责任。\n\n签署日期：2026年01月16日', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for factory_comment
-- ----------------------------
DROP TABLE IF EXISTS `factory_comment`;
CREATE TABLE `factory_comment`  (
  `comment_id` int NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `factory_id` int NOT NULL COMMENT '厂房ID',
  `score` decimal(2, 1) NOT NULL COMMENT '评分(1.0-5.0)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评论内容',
  `is_audit` tinyint NULL DEFAULT 1 COMMENT '审核状态: 0-违规隐藏, 1-正常显示',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  PRIMARY KEY (`comment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '厂房评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of factory_comment
-- ----------------------------
INSERT INTO `factory_comment` VALUES (1, 1, 20, 4.0, '不错', 0, '2026-01-14 13:26:51');

-- ----------------------------
-- Table structure for factory_info
-- ----------------------------
DROP TABLE IF EXISTS `factory_info`;
CREATE TABLE `factory_info`  (
  `factory_id` int NOT NULL AUTO_INCREMENT COMMENT '厂房ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '厂房标题/名称',
  `area` decimal(10, 2) NOT NULL COMMENT '面积(平方米)',
  `price_per_month` decimal(10, 2) NOT NULL COMMENT '月租金(元)',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '具体位置',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '厂房详细描述',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '厂房图片地址(逗号分隔)',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态: 0-空闲, 1-已出租, 2-维护中',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览量(用于推荐算法热度)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `floor_height` float NULL DEFAULT 6 COMMENT '层高(米)',
  `power_supply` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '100KVA' COMMENT '配电容量',
  `floor_load` float NULL DEFAULT 2 COMMENT '地面承重(吨/平米)',
  `structure` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '钢结构' COMMENT '建筑结构(钢混/钢结构)',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '可环评,独门独院' COMMENT '特色标签(逗号分隔)',
  PRIMARY KEY (`factory_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '厂房信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of factory_info
-- ----------------------------
INSERT INTO `factory_info` VALUES (1, 'A区-101 标准化重型机械加工厂房', 2400.00, 88000.00, '工业园区A区-101号', '适合大型机械制造，带10吨行车，地面硬化处理。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 12, '500KVA', 5, '钢结构', '带行车,可环评,独门独院');
INSERT INTO `factory_info` VALUES (2, 'B区-205 生物医药研发洁净车间', 800.00, 45000.00, '工业园区B区-205号', '十万级洁净标准，适合生物医药、精密仪器企业入驻。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 6, '100KVA', 0.8, '框架结构', '洁净车间,排污许可,科研');
INSERT INTO `factory_info` VALUES (3, 'C区-303 电商物流云仓（带卸货平台）', 3500.00, 70000.00, '工业园区C区-303号', '位于园区主干道旁，9米挑高，双面卸货平台，适合快递物流。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 9, '100KVA', 3, '钢结构', '物流仓储,大层高,交通便利');
INSERT INTO `factory_info` VALUES (4, 'D区-501 独栋企业总部办公楼', 1200.00, 60000.00, '工业园区D区-501号', '花园式独栋办公，三层结构，带独立停车场，适合企业总部。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 3.8, '150KVA', 0.5, '框架结构', '精装修,企业总部,花园式');
INSERT INTO `factory_info` VALUES (5, 'A区-105 精密电子组装车间', 1500.00, 45000.00, '工业园区A区-105号', '环氧地坪漆，防静电地板，适合电子元器件生产。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2026-01-14 11:05:13', 6, '100KVA', 2, '框架结构', '防静电,电子厂,无尘');
INSERT INTO `factory_info` VALUES (6, 'E区-606 小型初创企业孵化器', 300.00, 6000.00, '工业园区E区-606号', '租金优惠，拎包入驻，共享会议室，适合初创团队。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 3.5, '50KVA', 0.5, '框架结构', '创业扶持,租金便宜,精装');
INSERT INTO `factory_info` VALUES (7, 'F区-701 汽车零部件压铸车间', 3000.00, 105000.00, '工业园区F区-701号', '重工业区，允许有噪音和震动，电力配置极高。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 10, '1200KVA', 8, '钢结构', '重工业,大电量,可环评');
INSERT INTO `factory_info` VALUES (8, 'G区-808 食品加工标准厂房', 1800.00, 63000.00, '工业园区G区-808号', '符合食品安全标准，拥有完善的给排水系统和排烟管道。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 6, '100KVA', 2, '框架结构', '食品级,给排水,燃气接入');
INSERT INTO `factory_info` VALUES (9, 'H区-901 智能仓储配送中心', 5000.00, 125000.00, '工业园区H区-901号', '现代化高标仓，金刚砂地面，配备自动化分拣线接口。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 12, '200KVA', 5, '钢结构', '高标仓,自动化,消防丙类');
INSERT INTO `factory_info` VALUES (10, 'A区-108 闲置旧厂房（低价转租）', 2000.00, 30000.00, '工业园区A区-108号', '设施稍旧，但租金极低，适合对环境要求不高的仓库堆场。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2026-01-14 11:05:13', 6, '100KVA', 2, '砖混结构', '特价房,可短租,露天堆场');
INSERT INTO `factory_info` VALUES (11, 'B区-210 医疗器械生产基地', 2200.00, 88000.00, '工业园区B区-210号', 'GMP标准设计，双回路供电，已通过消防验收。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 5, '400KVA', 1.5, '框架结构', 'GMP标准,双电源,证照齐');
INSERT INTO `factory_info` VALUES (12, 'C区-309 冷链物流冷库', 1000.00, 50000.00, '工业园区C区-309号', '专业冷冻冷藏库，温度可调范围-25℃至10℃。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 6, '300KVA', 3, '钢结构', '冷库,生鲜配送,恒温');
INSERT INTO `factory_info` VALUES (13, 'D区-505 创意产业园Loft办公', 600.00, 24000.00, '工业园区D区-505号', '6米挑高Loft结构，适合设计公司、广告传媒公司。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 6, '80KVA', 0.5, '框架结构', 'Loft,创意园,网红打卡');
INSERT INTO `factory_info` VALUES (14, 'A区-112 自动化机械手臂测试车间', 1600.00, 56000.00, '工业园区A区-112号', '全封闭无尘环境，适合精密设备调试和组装。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 8, '250KVA', 3, '钢结构', '高科技,自动化,机器人');
INSERT INTO `factory_info` VALUES (15, 'E区-608 跨境电商打包发货仓', 800.00, 20000.00, '工业园区E区-608号', '临近快递分拨中心，租金便宜，适合电商大促备货。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2026-01-14 11:05:13', 6, '100KVA', 2, '框架结构', '电商仓,快递便利,短期');
INSERT INTO `factory_info` VALUES (16, 'F区-705 五金模具加工厂', 1200.00, 36000.00, '工业园区F区-705号', '一层车间，门口空地大，方便货车进出，电力充足。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 7.5, '300KVA', 5, '钢结构', '五金加工,车辆进出,一楼');
INSERT INTO `factory_info` VALUES (17, 'G区-810 中央厨房预制菜车间', 2500.00, 100000.00, '工业园区G区-810号', '按照食品药品监督局标准建设，带污水处理池。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 5.5, '500KVA', 2, '框架结构', '中央厨房,预制菜,排污');
INSERT INTO `factory_info` VALUES (18, 'H区-909 新能源电池PACK产线', 4000.00, 160000.00, '工业园区H区-909号', '甲类厂房标准，防爆设计，适合锂电池组装。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 9, '800KVA', 4, '钢结构', '新能源,甲类防爆,高危');
INSERT INTO `factory_info` VALUES (19, 'D区-508 软件研发中心', 1000.00, 40000.00, '工业园区D区-508号', '现代化写字楼标准，中央空调，光纤入户。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 6, '100KVA', 0.4, '框架结构', '软件园,人才补贴,写字楼');
INSERT INTO `factory_info` VALUES (20, 'A区-120 综合维修车间', 500.00, 15000.00, '工业园区A区-120号', '适合做汽修、设备维护中心，带门口停车位。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 11:05:13', 5, '80KVA', 3, '砖混结构', '汽修,沿街,停车位');
INSERT INTO `factory_info` VALUES (21, 'A区标准重型机械厂房-101', 1200.00, 45000.00, 'A区-101', '位于园区A区核心位置，适合大型机械加工，配有10吨行车。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-01 10:00:00', 12, '380V/500KVA', 5, '钢结构', '独栋,重工业,带行车');
INSERT INTO `factory_info` VALUES (22, 'A区精密电子车间-102', 800.00, 28000.00, 'A区-102', '无尘车间设计，适合电子元件生产，温湿度可控。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2025-10-02 11:30:00', 6, '220V/200KVA', 2, '框架结构', '无尘,电子,精装修');
INSERT INTO `factory_info` VALUES (23, 'B区物流仓储中心-B01', 2000.00, 35000.00, 'B区-B01', '超大开间，带卸货平台，紧邻高速路口，物流周转极佳。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-03 09:15:00', 9, '220V/100KVA', 3, '钢混结构', '高层高,卸货平台,物流');
INSERT INTO `factory_info` VALUES (24, 'B区小型加工车间-B05', 300.00, 8500.00, 'B区-B05', '适合初创企业，租金低，配套齐全，拎包入住。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-05 14:00:00', 4.5, '380V/50KVA', 1.5, '砖混结构', '低租金,初创,配套全');
INSERT INTO `factory_info` VALUES (25, 'C区生物医药研发楼-C03', 1500.00, 52000.00, 'C区-C03', '符合GMP标准，配备实验室排风系统，适合生物医药研发。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-08 16:20:00', 5, '双路供电', 2.5, '框架结构', 'GMP标准,实验室,研发');
INSERT INTO `factory_info` VALUES (26, 'A区通用标准厂房-105', 1000.00, 22000.00, 'A区-105', '标准厂房，采光好，通风佳，适合各类轻工业。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2025-10-10 10:00:00', 8, '380V/300KVA', 3, '钢结构', '采光好,通用性强');
INSERT INTO `factory_info` VALUES (27, 'D区食品加工车间-D02', 950.00, 30000.00, 'D区-D02', '已通过环评，配备污水处理接口，适合食品加工企业。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-12 09:00:00', 6.5, '380V/200KVA', 2, '框架结构', '可办环评,排污口,食品');
INSERT INTO `factory_info` VALUES (28, 'E区科技孵化器办公室-E10', 150.00, 6000.00, 'E区-E10', '现代化办公环境，共享会议室，适合科技类初创团队。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-15 13:00:00', 3.5, '220V', 0.5, '写字楼', '精装修,办公,孵化器');
INSERT INTO `factory_info` VALUES (29, 'A区大型组装车间-108', 3500.00, 68000.00, 'A区-108', '超大面积，双层结构，适合汽车零部件组装。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-18 15:30:00', 10, '380V/800KVA', 8, '钢结构', '超大面积,重工业');
INSERT INTO `factory_info` VALUES (30, 'B区冷链仓储库-B08', 1200.00, 42000.00, 'B区-B08', '配备专业冷库设施，温度可调，适合生鲜冷链。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2025-10-20 08:45:00', 7, '双路供电', 3, '钢混结构', '冷库,生鲜,冷链');
INSERT INTO `factory_info` VALUES (31, 'C区化学试剂仓库-C05', 800.00, 55000.00, 'C区-C05', '具备危化品存储资质，防爆设计，安全合规。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-22 11:00:00', 6, '防爆电路', 2, '特种结构', '危化品,防爆,合规');
INSERT INTO `factory_info` VALUES (32, 'A区二层轻纺车间-201', 1000.00, 15000.00, 'A区-201', '位于二楼，有货梯，适合服装纺织加工，租金实惠。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-25 09:30:00', 4.5, '380V/100KVA', 1, '框架结构', '二楼,货梯,服装');
INSERT INTO `factory_info` VALUES (33, 'E区总部独栋办公楼-E01', 2000.00, 90000.00, 'E区-E01', '企业总部首选，独立院落，环境优美，提升企业形象。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-10-28 14:20:00', 4, '独立变压器', 0.8, '独栋别墅', '独栋,花园,总部');
INSERT INTO `factory_info` VALUES (34, 'B区电商云仓-B12', 1500.00, 26000.00, 'B区-B12', '专为电商设计，流水线打包台，快递车直达。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2025-11-01 10:10:00', 8, '220V', 2, '钢结构', '电商,快递直发,流水线');
INSERT INTO `factory_info` VALUES (35, 'D区中央厨房车间-D06', 1100.00, 38000.00, 'D区-D06', '现有装修，燃气接入，隔油池已做好，接手即用。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-03 16:00:00', 5.5, '燃气接入', 2.5, '框架结构', '燃气,中央厨房,现房');
INSERT INTO `factory_info` VALUES (36, 'A区高跨度钢构厂房-112', 1800.00, 50000.00, 'A区-112', '跨度30米无立柱，空间利用率极高，适合大型设备。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-05 09:00:00', 14, '380V/400KVA', 6, '钢结构', '大跨度,无立柱');
INSERT INTO `factory_info` VALUES (37, 'C区新材料研发中心-C08', 1300.00, 48000.00, 'C区-C08', '高科技园区内，享受政策补贴，适合新材料行业。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-08 13:45:00', 5, '双回路', 3, '框架结构', '政策补贴,高新');
INSERT INTO `factory_info` VALUES (38, 'B区五金加工车间-B15', 600.00, 18000.00, 'B区-B15', '允许有噪音，周边无居民区，适合五金冲压。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2025-11-10 10:30:00', 7, '380V/250KVA', 4, '砖混结构', '五金,允许噪音');
INSERT INTO `factory_info` VALUES (39, 'E区创意设计工作室-E05', 200.00, 7500.00, 'E区-E05', 'LOFT结构，艺术氛围浓厚，适合设计、广告公司。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-12 15:00:00', 5.5, '220V', 0.5, 'LOFT', 'LOFT,创意,设计');
INSERT INTO `factory_info` VALUES (40, 'A区智能制造示范基地-118', 3000.00, 72000.00, 'A区-118', '园区标杆项目，智能化管理，配套宿舍食堂。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-15 08:30:00', 9, '380V/1000KVA', 5, '钢混结构', '标杆项目,配套全,智能');
INSERT INTO `factory_info` VALUES (41, 'B区-小型仓储-B20', 100.00, 3000.00, 'B区-B20', '经济型小仓库，适合存放杂物或做中转仓。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-18 11:15:00', 4, '220V', 1, '简易结构', '便宜,小仓库');
INSERT INTO `factory_info` VALUES (42, 'C区-精密仪器检测室-C12', 600.00, 35000.00, 'C区-C12', '防震地基处理，恒温恒湿，适合精密检测。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-20 14:40:00', 4.5, '稳压电源', 2, '框架结构', '防震,恒温,检测');
INSERT INTO `factory_info` VALUES (43, 'D区-饮料灌装生产线-D09', 1500.00, 45000.00, 'D区-D09', '原有生产线遗留，水源充足，适合饮料生产。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2025-11-22 09:50:00', 8, '380V', 4, '钢结构', '水源足,灌装');
INSERT INTO `factory_info` VALUES (44, 'A区-汽修美容中心-A03', 500.00, 20000.00, 'A区-A03', '临街铺面，带有展示区和维修工位，车流量大。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-25 10:00:00', 6, '380V', 3, '框架结构', '临街,汽修,展示');
INSERT INTO `factory_info` VALUES (45, 'E区-数据中心机房-E08', 1000.00, 80000.00, 'E区-E08', '双路市电+发电机，精密空调，适合做IDC机房。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-11-28 16:30:00', 5, '双路+UPS', 10, '框架结构', '高承重,双路电,IDC');
INSERT INTO `factory_info` VALUES (46, 'B区-家具生产厂房-B25', 1600.00, 32000.00, 'B区-B25', '消防等级高，喷淋系统完备，适合木工家具生产。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-01 09:10:00', 7.5, '380V', 3, '钢结构', '消防高,喷淋,家具');
INSERT INTO `factory_info` VALUES (47, 'C区-医疗器械洁净车间-C15', 900.00, 40000.00, 'C区-C15', '十万级洁净度，环氧地坪，适合医疗器械组装。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-03 13:20:00', 5.5, '净化系统', 2, '框架结构', '十万级洁净,医疗');
INSERT INTO `factory_info` VALUES (48, 'A区-注塑车间-125', 800.00, 25000.00, 'A区-125', '配有冷却水塔接口，电容足够，适合注塑机。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2025-12-05 15:50:00', 6, '380V/600KVA', 4, '砖混结构', '大电容,冷却水');
INSERT INTO `factory_info` VALUES (49, 'D区-印刷包装厂-D12', 1100.00, 28000.00, 'D区-D12', '一层承重好，适合放置大型印刷机，隔音处理。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-08 10:40:00', 6.5, '380V', 5, '框架结构', '承重好,印刷,包装');
INSERT INTO `factory_info` VALUES (50, 'E区-网红直播基地-E12', 400.00, 12000.00, 'E区-E12', '多隔间设计，隔音好，光纤入户，适合直播带货。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-10 14:10:00', 3.5, '220V', 0.5, '写字楼', '直播,隔音,光纤');
INSERT INTO `factory_info` VALUES (51, 'A区-机械臂调试中心-130', 1000.00, 36000.00, 'A区-130', '高净空，适合机器人手臂调试与展示。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-12 09:00:00', 10, '380V', 3, '钢结构', '机器人,高净空');
INSERT INTO `factory_info` VALUES (52, 'B区-跨境电商分拣仓-B30', 2200.00, 46000.00, 'B区-B30', '邻近保税区，通关便利，适合跨境电商。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-15 11:30:00', 9, '220V', 2, '钢构', '保税,分拣,跨境');
INSERT INTO `factory_info` VALUES (53, 'C区-芯片封装测试厂-C20', 1500.00, 95000.00, 'C区-C20', '防微震设计，超净车间，适合半导体封测。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2025-12-18 16:00:00', 6, '多路供电', 3, '框架', '芯片,半导体,防震');
INSERT INTO `factory_info` VALUES (54, 'D区-预制菜加工中心-D15', 1000.00, 33000.00, 'D区-D15', '低温作业环境，食品级装修，适合预制菜生产。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-20 08:50:00', 5, '380V', 2.5, '框架', '预制菜,低温');
INSERT INTO `factory_info` VALUES (55, 'A区-新能源电池组装车间-135', 1800.00, 58000.00, 'A区-135', '防火等级甲级，独立排气，适合锂电池组装。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-22 13:10:00', 8, '380V/800KVA', 4, '钢混', '新能源,防火,锂电');
INSERT INTO `factory_info` VALUES (56, 'E区-培训教室-E15', 120.00, 4500.00, 'E区-E15', '多媒体设备齐全，适合企业做员工技能培训。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-25 10:20:00', 3.5, '220V', 0.5, '写字楼', '培训,会议,多媒体');
INSERT INTO `factory_info` VALUES (57, 'B区-服装打板室-B35', 200.00, 6000.00, 'B区-B35', '采光极佳，配套裁床，适合服装设计打板。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2025-12-28 15:40:00', 4, '220V', 1, '砖混', '打板,服装,采光');
INSERT INTO `factory_info` VALUES (58, 'C区-检验检测认证中心-C25', 800.00, 28000.00, 'C区-C25', '独立办公楼层，适合第三方检测机构入驻。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2026-01-01 09:30:00', 4.5, '稳压', 2, '框架', '第三方检测,办公');
INSERT INTO `factory_info` VALUES (59, 'A区-模具制造车间-140', 700.00, 24000.00, 'A区-140', '地面加固，适合放置数控加工中心和磨床。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-03 14:00:00', 6.5, '380V/300KVA', 5, '砖混', '模具,承重,数控');
INSERT INTO `factory_info` VALUES (60, 'D区-饮料仓库-D20', 800.00, 15000.00, 'D区-D20', '避光通风，适合存放饮料、酒水等快消品。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-05 11:00:00', 7, '220V', 3, '钢构', '饮料,仓库,避光');
INSERT INTO `factory_info` VALUES (61, 'E区-联合办公工位-E20', 10.00, 800.00, 'E区-E20', '按工位出租，灵活性高，适合自由职业者。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-06 09:00:00', 3, '220V', 0.5, '开放式', '联合办公,工位,便宜');
INSERT INTO `factory_info` VALUES (62, 'A区-无人机试飞基地-145', 1000.00, 40000.00, 'A区-145', '带室外试飞场地，空域已申请，适合无人机企业。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-07 15:30:00', 6, '380V', 2, '钢混', '无人机,试飞场');
INSERT INTO `factory_info` VALUES (63, 'B区-化妆品分装车间-B40', 600.00, 22000.00, 'B区-B40', '洁净度高，流水线布局，适合化妆品分装。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-08 10:45:00', 5, '220V', 2, '框架', '化妆品,洁净,分装');
INSERT INTO `factory_info` VALUES (64, 'C区-环保设备展示厅-C30', 400.00, 18000.00, 'C区-C30', '临街落地窗，适合大型环保设备展示与销售。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-09 13:50:00', 5.5, '380V', 3, '框架', '展厅,临街,环保');
INSERT INTO `factory_info` VALUES (65, 'D区-特产加工坊-D25', 150.00, 5000.00, 'D区-D25', '小面积加工间，适合地方特产手工制作。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-10 16:10:00', 4, '220V', 1.5, '砖混', '特产,手工,小面积');
INSERT INTO `factory_info` VALUES (66, 'A区-重型钢构厂房-150', 4000.00, 88000.00, 'A区-150', '带20吨行车，地面承重10吨，适合重型装备制造。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-11 08:30:00', 15, '380V/1200KVA', 10, '钢结构', '重型装备,大行车');
INSERT INTO `factory_info` VALUES (67, 'E区-软件开发中心-E25', 250.00, 11000.00, 'E区-E25', '安静舒适，网速快，适合软件外包团队。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1, 0, '2026-01-12 11:20:00', 3.5, '220V', 0.5, '写字楼', '软件,安静,网速快');
INSERT INTO `factory_info` VALUES (68, 'B区-快递中转场-B45', 3000.00, 50000.00, 'B区-B45', '多月台设计，场地开阔，适合快递分拨。', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-13 14:00:00', 8, '380V', 4, '钢构', '快递,中转,多月台');
INSERT INTO `factory_info` VALUES (69, 'C区-生物发酵车间-C35', 900.00, 36000.00, 'C区-C35', '恒温发酵环境，配备蒸汽管道接口。', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-13 16:30:00', 6, '蒸汽接口', 3, '框架', '发酵,蒸汽,生物');
INSERT INTO `factory_info` VALUES (70, 'D区-冷冻食品加工-D30', 1100.00, 42000.00, 'D区-D30', '低温冷藏+加工一体化，适合速冻食品。', 'https://images.unsplash.com/photo-1537432376769-00f5c2f4c8d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 0, 0, '2026-01-14 09:00:00', 6, '380V', 3, '框架', '冷冻,食品,一体化');

-- ----------------------------
-- Table structure for sys_collection
-- ----------------------------
DROP TABLE IF EXISTS `sys_collection`;
CREATE TABLE `sys_collection`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `factory_id` int NOT NULL COMMENT '厂房ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_factory`(`user_id` ASC, `factory_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_collection
-- ----------------------------
INSERT INTO `sys_collection` VALUES (1, 4, 1, '2026-01-15 18:52:32');
INSERT INTO `sys_collection` VALUES (2, 2, 1, '2026-01-15 18:52:40');
INSERT INTO `sys_collection` VALUES (3, 2, 2, '2026-01-15 18:52:42');
INSERT INTO `sys_collection` VALUES (4, 2, 3, '2026-01-15 18:52:42');
INSERT INTO `sys_collection` VALUES (5, 2, 4, '2026-01-15 18:52:43');
INSERT INTO `sys_collection` VALUES (6, 2, 5, '2026-01-15 18:52:44');
INSERT INTO `sys_collection` VALUES (7, 2, 21, '2026-01-15 18:53:01');
INSERT INTO `sys_collection` VALUES (8, 4, 6, '2026-01-15 18:56:08');
INSERT INTO `sys_collection` VALUES (9, 4, 5, '2026-01-15 18:56:09');
INSERT INTO `sys_collection` VALUES (10, 2, 10, '2026-01-16 09:22:22');
INSERT INTO `sys_collection` VALUES (11, 2, 9, '2026-01-16 09:22:22');
INSERT INTO `sys_collection` VALUES (12, 2, 8, '2026-01-16 09:22:23');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容(富文本)',
  `publisher` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'admin' COMMENT '发布人',
  `publish_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '🎉 2026年第一季度厂房租金优惠政策说明', '为支持中小企业发展，园区决定对2026年第一季度新签约的租户实行租金9折优惠。优惠范围包括A区和B区的所有标准厂房。具体申请流程请咨询园区服务中心，或在个人中心直接提交租赁申请，备注“季度优惠”。', 'admin', '2026-01-15 09:30:58', '2026-01-10 09:00:00');
INSERT INTO `sys_notice` VALUES (2, '📢 关于园区A区电路检修的停电通知', '尊敬的各位租户：为了保障园区电力供应的稳定性，我们计划于2026年1月15日（周四）上午10:00至下午14:00对A区变电站进行例行检修。期间A区-101至A区-120号厂房将暂停供电。请相关企业提前做好生产安排，给您带来的不便敬请谅解。', 'admin', '2026-01-15 09:30:58', '2026-01-12 14:30:00');
INSERT INTO `sys_notice` VALUES (3, '🔒 2026年度春季消防安全大检查日程安排', '安全生产重于泰山。园区安保部将于本月20日起开展春季消防安全大检查。检查重点包括：消防通道是否畅通、灭火器材是否过期、电气线路是否老化等。请各租户配合检查工作，提前自查自纠，共同维护园区安全环境。', 'admin', '2026-01-15 09:30:58', '2026-01-13 08:00:00');
INSERT INTO `sys_notice` VALUES (4, '🚛 园区物流车辆出入管理新规定', '为了缓解园区早晚高峰拥堵情况，自2月1日起，大型货运车辆（载重5吨以上）禁止在早高峰（7:30-9:00）和晚高峰（17:30-19:00）从东门进出。请各物流车辆改道西门或北门通行。感谢您的配合！', 'admin', '2026-01-15 09:30:58', '2026-01-14 10:15:00');
INSERT INTO `sys_notice` VALUES (5, '🛠️ D区公共食堂装修完毕重新开业通知', '经过一个月的升级改造，D区公共食堂将于下周一（1月19日）正式重新开业！新食堂增加了自选菜品区和面点窗口，环境更舒适，价格更亲民。欢迎各位员工前来品尝！开业前三天全场8.8折。', 'admin', '2026-01-15 09:30:58', '2026-01-14 11:00:00');
INSERT INTO `sys_notice` VALUES (6, '1111', '1111', 'admin', '2026-01-15 09:32:54', '2026-01-15 09:32:55');

-- ----------------------------
-- Table structure for sys_payment
-- ----------------------------
DROP TABLE IF EXISTS `sys_payment`;
CREATE TABLE `sys_payment`  (
  `payment_id` int NOT NULL AUTO_INCREMENT COMMENT '支付ID',
  `contract_id` int NOT NULL COMMENT '关联合同ID',
  `amount` decimal(10, 2) NOT NULL COMMENT '支付金额',
  `pay_type` tinyint NULL DEFAULT 1 COMMENT '支付方式: 1-支付宝, 2-微信, 3-银行转账',
  `pay_status` tinyint NULL DEFAULT 1 COMMENT '支付状态: 0-未支付, 1-支付成功, 2-支付失败',
  `pay_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支付时间',
  `pay_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '在线支付',
  PRIMARY KEY (`payment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支付记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_payment
-- ----------------------------
INSERT INTO `sys_payment` VALUES (1, 64, 15000.00, 1, 1, '2026-01-15 10:18:53', '在线钱包');
INSERT INTO `sys_payment` VALUES (2, 65, 42000.00, 1, 1, '2026-01-15 11:49:06', '在线钱包');
INSERT INTO `sys_payment` VALUES (3, 71, 365000.00, 1, 1, '2026-01-16 09:32:09', '在线钱包');
INSERT INTO `sys_payment` VALUES (4, 73, 365000.00, 1, 1, '2026-01-16 10:07:08', '在线钱包');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名/账号',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '加密后的密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `role` tinyint NULL DEFAULT 1 COMMENT '角色: 0-管理员, 1-普通用户(租户)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '1jdzWuniG6UMtoa3T6uNLA==', 'guido', NULL, NULL, NULL, 0, '2026-01-13 13:33:20', '2026-01-13 14:29:02');
INSERT INTO `sys_user` VALUES (2, 'user', '1jdzWuniG6UMtoa3T6uNLA==', '李想', NULL, NULL, NULL, 1, '2026-01-13 14:29:12', '2026-01-14 11:06:04');
INSERT INTO `sys_user` VALUES (3, 'tenant_li', '1jdzWuniG6UMtoa3T6uNLA==', '李四 (物流仓储)', NULL, NULL, NULL, 1, '2026-01-13 16:39:32', '2026-01-13 16:39:32');
INSERT INTO `sys_user` VALUES (4, 'user2', '1jdzWuniG6UMtoa3T6uNLA==', 'yangmianqi', NULL, NULL, NULL, 1, '2026-01-13 19:13:13', '2026-01-13 19:13:13');
INSERT INTO `sys_user` VALUES (5, 'manager_zhang', '1jdzWuniG6UMtoa3T6uNLA==', '张经理(运营)', '13900139000', NULL, NULL, 1, '2026-01-15 10:40:30', '2026-01-15 17:26:54');
INSERT INTO `sys_user` VALUES (6, 'tech_abc', '1jdzWuniG6UMtoa3T6uNLA==', 'ABC科技发展有限公司', '13612345678', NULL, NULL, 1, '2026-01-15 10:40:30', '2026-01-15 10:40:29');
INSERT INTO `sys_user` VALUES (7, 'food_tian', '1jdzWuniG6UMtoa3T6uNLA==', '天天食品加工厂', '13612345679', NULL, NULL, 1, '2026-01-15 10:40:30', '2026-01-15 10:40:29');
INSERT INTO `sys_user` VALUES (8, 'logistics_sf', '1jdzWuniG6UMtoa3T6uNLA==', '顺风速运园区网点', '13612345680', NULL, NULL, 1, '2026-01-15 10:40:30', '2026-01-15 10:40:29');

-- ----------------------------
-- Table structure for user_favorite
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite`;
CREATE TABLE `user_favorite`  (
  `favorite_id` int NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `factory_id` int NOT NULL COMMENT '厂房ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`) USING BTREE,
  UNIQUE INDEX `idx_user_factory`(`user_id` ASC, `factory_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_favorite
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
