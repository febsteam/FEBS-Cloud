/*
 Navicat Premium Data Transfer

 Source Server         : localhost_mysql
 Source Server Type    : MySQL
 Source Server Version : 50724
 Source Host           : localhost:3306
 Source Schema         : febs_nacos

 Target Server Type    : MySQL
 Target Server Version : 50724
 File Encoding         : 65001

 Date: 07/05/2020 15:19:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for config_info
-- ----------------------------
DROP TABLE IF EXISTS `config_info`;
CREATE TABLE `config_info` (
                               `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
                               `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
                               `group_id` varchar(255) COLLATE utf8_bin DEFAULT NULL,
                               `content` longtext COLLATE utf8_bin NOT NULL COMMENT 'content',
                               `md5` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'md5',
                               `gmt_create` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '创建时间',
                               `gmt_modified` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '修改时间',
                               `src_user` text COLLATE utf8_bin COMMENT 'source user',
                               `src_ip` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT 'source ip',
                               `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
                               `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '租户字段',
                               `c_desc` varchar(256) COLLATE utf8_bin DEFAULT NULL,
                               `c_use` varchar(64) COLLATE utf8_bin DEFAULT NULL,
                               `effect` varchar(64) COLLATE utf8_bin DEFAULT NULL,
                               `type` varchar(64) COLLATE utf8_bin DEFAULT NULL,
                               `c_schema` text COLLATE utf8_bin,
                               PRIMARY KEY (`id`) USING BTREE,
                               UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='config_info';

-- ----------------------------
-- Records of config_info
-- ----------------------------
BEGIN;
INSERT INTO `config_info` VALUES (8, 'febs-gateway.yaml', 'DEFAULT_GROUP', 'server:\r\n  port: 8301\r\nspring:\r\n  cloud:\r\n    gateway:\r\n      globalcors:\r\n        corsConfigurations:\r\n          \'[/**]\':\r\n            allowedOrigins: \"*\"\r\n            allowedMethods: \"*\"\r\n            allowedHeaders: \"*\"\r\n            allowCredentials: true\r\n      routes:\r\n        - id: FEBS-Auth-Social\r\n          uri: lb://FEBS-Auth\r\n          predicates:\r\n            - Path=/auth/social/**\r\n          filters:\r\n            - name: Hystrix\r\n              args:\r\n                name: socialfallback\r\n                fallbackUri: forward:/fallback/FEBS-Auth\r\n        - id: FEBS-Auth\r\n          uri: lb://FEBS-Auth\r\n          predicates:\r\n            - Path=/auth/**\r\n          filters:\r\n            - name: Hystrix\r\n              args:\r\n                name: authfallback\r\n                fallbackUri: forward:/fallback/FEBS-Auth            \r\n        - id: FEBS-Server-System\r\n          uri: lb://FEBS-Server-System\r\n          predicates:\r\n            - Path=/system/**\r\n          filters:\r\n            - name: Hystrix\r\n              args:\r\n                name: systemfallback\r\n                fallbackUri: forward:/fallback/FEBS-Server-System\r\n        - id: FEBS-Server-Generator\r\n          uri: lb://FEBS-Server-Generator\r\n          predicates:\r\n            - Path=/generator/**\r\n          filters:\r\n            - name: Hystrix\r\n              args:\r\n                name: generatorfallback\r\n                fallbackUri: forward:/fallback/FEBS-Server-Generator\r\n        - id: FEBS-Server-Job\r\n          uri: lb://FEBS-Server-Job\r\n          predicates:\r\n            - Path=/job/**\r\n          filters:\r\n            - name: Hystrix\r\n              args:\r\n                name: jobfallback\r\n                fallbackUri: forward:/fallback/FEBS-Server-Job\r\n        - id: FEBS-Server-test\r\n          uri: lb://FEBS-Server-Test\r\n          predicates:\r\n            - Path=/test/**\r\n          filters:\r\n            - name: Hystrix\r\n              args:\r\n                name: testfallback\r\n                fallbackUri: forward:/fallback/FEBS-Server-Test\r\n      loadbalancer:\r\n        use404: true\r\n      default-filters:\r\n        - StripPrefix=1\r\n        - FebsDocGatewayHeaderFilter\r\n  autoconfigure:\r\n    exclude: org.springframework.boot.autoconfigure.mongo.MongoReactiveAutoConfiguration,org.springframework.boot.autoconfigure.data.mongo.MongoReactiveRepositoriesAutoConfiguration,org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration\r\n    \r\n# 网关增强配置\r\n  # data:\r\n  #   mongodb:\r\n  #     authentication-database: admin\r\n  #     username: root\r\n  #     password: 123456\r\n  #     host: ${mongo.url}\r\n  #     port: 27017\r\n  #     database: febs_cloud_route\r\n\r\n  redis:\r\n    database: 3\r\n    host: ${redis.url}\r\n    port: 6379\r\n    lettuce:\r\n      pool:\r\n        min-idle: 8\r\n        max-idle: 500\r\n        max-active: 2000\r\n        max-wait: 10000\r\n    timeout: 5000\r\n\r\n# 网关增强配置\r\nfebs:\r\n  gateway:\r\n    enhance: false\r\n    jwt:\r\n      secret: 123456\r\n      expiration: 36000\r\n  doc:\r\n    gateway:\r\n      enable: true\r\n      resources: \"FEBS-Server-System,FEBS-Server-Test,FEBS-Auth,FEBS-Server-Generator,FEBS-Server-Job\"\r\n  log:\r\n    elk:\r\n      enable: false\r\n      enableLogForController: false\r\n      logstashHost: ${logstash.url}:4560\r\n\r\nhystrix:\r\n  command:\r\n    default:\r\n      execution:\r\n        isolation:\r\n          thread:\r\n            timeoutInMilliseconds: 10000\r\n    socialfallback:\r\n      execution:\r\n        isolation:\r\n          thread:\r\n            timeoutInMilliseconds: 60000    \r\n\r\nribbon:\r\n  eager-load:\r\n    enabled: true\r\n\r\nmanagement:\r\n  endpoint:\r\n    health:\r\n      show-details: ALWAYS\r\n  endpoints:\r\n    web:\r\n      exposure:\r\n        include: health,info,gateway\r\n\r\n', 'b8834a3889e78dda34d04dddba0e4b58', '2019-09-18 10:37:02', '2020-04-19 10:48:42', NULL, '127.0.0.1', '', '', 'FEBS-Gateway微服务配置', 'null', 'null', 'yaml', 'null');
INSERT INTO `config_info` VALUES (24, 'febs-server-test.yaml', 'DEFAULT_GROUP', 'server:\r\n  port: 8202\r\nspring:\r\n  datasource:\r\n    dynamic:\r\n      p6spy: true\r\n      hikari:\r\n        connection-timeout: 30000\r\n        max-lifetime: 1800000\r\n        max-pool-size: 15\r\n        min-idle: 5\r\n        connection-test-query: select 1\r\n        pool-name: FebsHikariCP\r\n      primary: base\r\n      datasource:\r\n        base:\r\n          username: root\r\n          password: 123456\r\n          driver-class-name: com.mysql.cj.jdbc.Driver\r\n          url: jdbc:mysql://${mysql.url}:3306/febs_cloud_base?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8\r\n  boot:\r\n    admin:\r\n      client:\r\n        url: http://${febs-admin}:8401\r\n        username: febs\r\n        password: 123456\r\n        instance:\r\n          prefer-ip: true\r\n\r\nfeign:\r\n  hystrix:\r\n    enabled: true\r\n\r\nhystrix:\r\n  shareSecurityContext: true\r\n  command:\r\n    default:\r\n      execution:\r\n        isolation:\r\n          thread:\r\n            timeoutInMilliseconds: 3000\r\nmybatis-plus:\r\n  type-aliases-package: cc.mrbird.febs.common.core.entity.system\r\n  mapper-locations: classpath:mapper/*.xml\r\n  configuration:\r\n    jdbc-type-for-null: null\r\n  global-config:\r\n    banner: false\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      id: ${spring.application.name}\r\n      user-info-uri: http://${febs-gateway}:8301/auth/user\r\n\r\ntx-lcn:\r\n  client:\r\n    manager-address: ${febs-tx-manager}:8888\r\n\r\ninfo:\r\n  app:\r\n    name: ${spring.application.name}\r\n    description: \"@project.description@\"\r\n    version: \"@project.version@\"\r\n\r\nmanagement:\r\n  endpoints:\r\n    web:\r\n      exposure:\r\n        include: \'*\'\r\n  endpoint:\r\n    health:\r\n      show-details: ALWAYS\r\nfebs:\r\n  doc:\r\n    enable: true\r\n    title: ${spring.application.name}文档\r\n    base-package: cc.mrbird.febs.server.test.controller\r\n    description: ${febs.doc.title}\r\n    name: MrBird\r\n    email: 852252810@qq.com\r\n    url: https://mrbird.cc\r\n    version: 2.2-RELEASE\r\n  log:\r\n    elk:\r\n      enable: false\r\n      enableLogForController: false\r\n      logstashHost: ${logstash.url}:4560\r\n  cloud:\r\n    security:\r\n      enable: true\r\n      anon-uris: /actuator/**,/v2/api-docs,/v2/api-docs-ext', 'ce0dcf61f4921751f9cf6926aa2f0f88', '2019-09-19 10:17:25', '2020-04-18 10:10:50', NULL, '0:0:0:0:0:0:0:1', '', '', 'FEBS-Server-Test微服务配置', 'null', 'null', 'yaml', 'null');
INSERT INTO `config_info` VALUES (29, 'febs-tx-manager.yaml', 'DEFAULT_GROUP', 'server:\r\n  port: 8501\r\nspring:\r\n  boot:\r\n    admin:\r\n      client:\r\n        url: http://${febs-admin}:8401\r\n        username: febs\r\n        password: 123456\r\n        instance:\r\n          prefer-ip: true\r\n  datasource:\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    url: jdbc:mysql://${mysql.url}:3306/febs_cloud_base?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8\r\n    username: root\r\n    password: 123456\r\n  redis:\r\n    database: 0\r\n    host: ${redis.url}\r\n    port: 6379\r\n    lettuce:\r\n      pool:\r\n        min-idle: 8\r\n        max-idle: 500\r\n        max-active: 2000\r\n        max-wait: 10000\r\n    timeout: 5000\r\n\r\ninfo:\r\n  app:\r\n    name: ${spring.application.name}\r\n    description: \"@project.description@\"\r\n    version: \"@project.version@\"\r\n\r\nmanagement:\r\n  endpoints:\r\n    web:\r\n      exposure:\r\n        include: \'*\'\r\n  endpoint:\r\n    health:\r\n      show-details: ALWAYS\r\n\r\ntx-lcn:\r\n  manager:\r\n    host: 0.0.0.0\r\n    # TM监听Socket端口.\r\n    port: 8888\r\n    # TM控制台密码\r\n    admin-key: 123456\r\n  logger:\r\n    # 开启日志记录\r\n    enabled: true\r\n    driver-class-name: ${spring.datasource.driver-class-name}\r\n    jdbc-url: ${spring.datasource.url}\r\n    username: ${spring.datasource.username}\r\n    password: ${spring.datasource.password}', 'd0650331753a7507ca99d431c3face17', '2020-04-16 09:12:35', '2020-04-18 10:11:24', NULL, '0:0:0:0:0:0:0:1', '', '', 'null', 'null', 'null', 'yaml', 'null');
INSERT INTO `config_info` VALUES (33, 'febs-server-generator.yaml', 'DEFAULT_GROUP', 'server:\r\n  port: 8203\r\nspring:\r\n  datasource:\r\n    dynamic:\r\n      p6spy: true\r\n      hikari:\r\n        connection-timeout: 30000\r\n        max-lifetime: 1800000\r\n        max-pool-size: 15\r\n        min-idle: 5\r\n        connection-test-query: select 1\r\n        pool-name: FebsHikariCP\r\n      primary: base\r\n      datasource:\r\n        base:\r\n          username: root\r\n          password: 123456\r\n          driver-class-name: com.mysql.cj.jdbc.Driver\r\n          url: jdbc:mysql://${mysql.url}:3306/febs_cloud_base?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8\r\n  boot:\r\n    admin:\r\n      client:\r\n        url: http://${febs-admin}:8401\r\n        username: febs\r\n        password: 123456\r\n        instance:\r\n          prefer-ip: true\r\n\r\nmybatis-plus:\r\n  type-aliases-package: cc.mrbird.febs.common.core.entity.system\r\n  mapper-locations: classpath:mapper/*.xml\r\n  configuration:\r\n    jdbc-type-for-null: null\r\n  global-config:\r\n    banner: false\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      id: ${spring.application.name}\r\n      user-info-uri: http://${febs-gateway}:8301/auth/user\r\n\r\ninfo:\r\n  app:\r\n    name: ${spring.application.name}\r\n    description: \"@project.description@\"\r\n    version: \"@project.version@\"\r\n\r\nmanagement:\r\n  endpoints:\r\n    web:\r\n      exposure:\r\n        include: \'*\'\r\n  endpoint:\r\n    health:\r\n      show-details: ALWAYS\r\n\r\nfebs:\r\n  doc:\r\n    enable: true\r\n    title: ${spring.application.name}文档\r\n    base-package: cc.mrbird.febs.server.generator.controller\r\n    description: ${febs.doc.title}\r\n    name: MrBird\r\n    email: 852252810@qq.com\r\n    url: https://mrbird.cc\r\n    version: 2.2-RELEASE\r\n  log:\r\n    elk:\r\n      enable: false\r\n      enableLogForController: false\r\n      logstashHost: ${logstash.url}:4560\r\n  cloud:\r\n    security:\r\n      enable: true\r\n      anon-uris: /actuator/**,/v2/api-docs,/v2/api-docs-ext', 'e6cc51aa230488d02a166b7de2a2e99f', '2020-04-16 11:03:11', '2020-04-19 10:55:06', NULL, '127.0.0.1', '', '', 'null', 'null', 'null', 'yaml', 'null');
INSERT INTO `config_info` VALUES (35, 'febs-server-job.yaml', 'DEFAULT_GROUP', 'server:\r\n  port: 8204\r\nspring:\r\n  jackson:\r\n    date-format: yyyy-MM-dd HH:mm:ss\r\n    time-zone: GMT+8\r\n  datasource:\r\n    dynamic:\r\n      # 是否开启 SQL日志输出，生产环境建议关闭，有性能损耗\r\n      p6spy: true\r\n      hikari:\r\n        connection-timeout: 30000\r\n        max-lifetime: 1800000\r\n        max-pool-size: 15\r\n        min-idle: 5\r\n        connection-test-query: select 1\r\n        pool-name: FebsHikariCP\r\n      # 配置默认数据源\r\n      primary: base\r\n      datasource:\r\n        # 数据源-1，名称为 base\r\n        base:\r\n          username: root\r\n          password: 123456\r\n          driver-class-name: com.mysql.cj.jdbc.Driver\r\n          url: jdbc:mysql://${mysql.url}:3306/febs_cloud_base?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8\r\n        # 数据源-2，名称为 job\r\n        job:\r\n          username: root\r\n          password: 123456\r\n          driver-class-name: com.mysql.cj.jdbc.Driver\r\n          url: jdbc:mysql://${mysql.url}:3306/febs_cloud_job?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8\r\n\r\n  boot:\r\n    admin:\r\n      client:\r\n        url: http://${febs-admin}:8401\r\n        username: febs\r\n        password: 123456\r\n        instance:\r\n          prefer-ip: true\r\n\r\nmybatis-plus:\r\n  type-aliases-package: cc.mrbird.febs.server.job.entity\r\n  mapper-locations: classpath:mapper/*.xml\r\n  configuration:\r\n    jdbc-type-for-null: null\r\n  global-config:\r\n    banner: false\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      id: ${spring.application.name}\r\n      user-info-uri: http://${febs-gateway}:8301/auth/user\r\n\r\ninfo:\r\n  app:\r\n    name: ${spring.application.name}\r\n    description: \"@project.description@\"\r\n    version: \"@project.version@\"\r\n\r\nmanagement:\r\n  endpoints:\r\n    web:\r\n      exposure:\r\n        include: \'*\'\r\n  endpoint:\r\n    health:\r\n      show-details: ALWAYS\r\nfebs:\r\n  doc:\r\n    enable: true\r\n    title: ${spring.application.name}文档\r\n    base-package: cc.mrbird.febs.server.job.controller\r\n    description: ${febs.doc.title}\r\n    name: MrBird\r\n    email: 852252810@qq.com\r\n    url: https://mrbird.cc\r\n    version: 2.2-RELEASE\r\n  log:\r\n    elk:\r\n      enable: false\r\n      enableLogForController: false\r\n      logstashHost: ${logstash.url}:4560\r\n  cloud:\r\n    security:\r\n      enable: true\r\n      anon-uris: /actuator/**,/v2/api-docs,/v2/api-docs-ext', 'bc5a3f62d3b16f47f4debc5e3ffc097f', '2020-04-16 11:31:54', '2020-04-19 10:55:21', NULL, '127.0.0.1', '', '', 'null', 'null', 'null', 'yaml', 'null');
INSERT INTO `config_info` VALUES (38, 'febs-admin.yaml', 'DEFAULT_GROUP', 'server:\n  port: 8401\n\nspring:\n  security:\n    user:\n      name: febs\n      password: 123456\n  boot:\n    admin:\n      ui:\n        title: ${spring.application.name}', '31a6f472776c2d374593f0ded91004af', '2020-04-16 13:56:54', '2020-04-16 13:56:54', NULL, '218.104.225.80', '', '', NULL, NULL, NULL, 'yaml', NULL);
INSERT INTO `config_info` VALUES (82, 'febs-server-system.yaml', 'DEFAULT_GROUP', 'server:\r\n  port: 8201\r\n    \r\nspring:\r\n  aop:\r\n    proxy-target-class: true\r\n  jackson:\r\n    date-format: yyyy-MM-dd HH:mm:ss\r\n    time-zone: GMT+8\r\n  boot:\r\n    admin:\r\n      client:\r\n        url: http://${febs-admin}:8401\r\n        username: febs\r\n        password: 123456\r\n        instance:\r\n          prefer-ip: true\r\n  freemarker:\r\n    check-template-location: false\r\n\r\n  datasource:\r\n    dynamic:\r\n      p6spy: true\r\n      hikari:\r\n        connection-timeout: 30000\r\n        max-lifetime: 1800000\r\n        max-pool-size: 15\r\n        min-idle: 5\r\n        connection-test-query: select 1\r\n        pool-name: FebsHikariCP\r\n      primary: base\r\n      datasource:\r\n        base:\r\n          username: root\r\n          password: 123456\r\n          driver-class-name: com.mysql.cj.jdbc.Driver\r\n          url: jdbc:mysql://${mysql.url}:3306/febs_cloud_base?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8\r\n\r\nmybatis-plus:\r\n  type-aliases-package: cc.mrbird.febs.common.core.entity.system\r\n  mapper-locations: classpath:mapper/*.xml\r\n  configuration:\r\n    jdbc-type-for-null: null\r\n  global-config:\r\n    banner: false\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      id: ${spring.application.name}\r\n      user-info-uri: http://${febs-gateway}:8301/auth/user\r\n\r\ninfo:\r\n  app:\r\n    name: ${spring.application.name}\r\n    description: \"@project.description@\"\r\n    version: \"@project.version@\"\r\n\r\nmanagement:\r\n  endpoints:\r\n    web:\r\n      exposure:\r\n        include: \'*\'\r\n  endpoint:\r\n    health:\r\n      show-details: ALWAYS\r\nfebs:\r\n  doc:\r\n    enable: true\r\n    title: ${spring.application.name}文档\r\n    base-package: cc.mrbird.febs.server.system.controller\r\n    description: ${febs.doc.title}\r\n    name: MrBird\r\n    email: 852252810@qq.com\r\n    url: https://mrbird.cc\r\n    version: 2.2-RELEASE\r\n  log:\r\n    elk:\r\n      enable: false\r\n      enableLogForController: false\r\n      logstashHost: ${logstash.url}:4560\r\n  cloud:\r\n    security:\r\n      enable: true\r\n      anon-uris: /actuator/**,/v2/api-docs,/v2/api-docs-ext\r\ntx-lcn:\r\n  client:\r\n    manager-address: ${febs-tx-manager}:8888', 'b6952e120408775e7494f7e4f8bd7047', '2020-04-18 10:00:56', '2020-04-19 10:54:40', NULL, '127.0.0.1', '', '', 'FEBS-Server-System微服务配置', 'null', 'null', 'yaml', 'null');
INSERT INTO `config_info` VALUES (83, 'febs-auth.yaml', 'DEFAULT_GROUP', 'server:\r\n  port: 8101\r\nspring:\r\n  datasource:\r\n    dynamic:\r\n      hikari:\r\n        connection-timeout: 30000\r\n        max-lifetime: 1800000\r\n        max-pool-size: 15\r\n        min-idle: 5\r\n        connection-test-query: select 1\r\n        pool-name: FebsHikariCP\r\n      primary: base\r\n      datasource:\r\n        base:\r\n          username: root\r\n          password: 123456\r\n          driver-class-name: com.mysql.cj.jdbc.Driver\r\n          url: jdbc:mysql://${mysql.url}:3306/febs_cloud_base?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8\r\n\r\n  jackson:\r\n    date-format: yyyy-MM-dd HH:mm:ss\r\n    time-zone: GMT+8\r\n  boot:\r\n    admin:\r\n      client:\r\n        url: http://${febs-admin}:8401\r\n        username: febs\r\n        password: 123456\r\n        instance:\r\n          prefer-ip: true\r\n\r\n  redis:\r\n    database: 0\r\n    host: ${redis.url}\r\n    port: 6379\r\n    lettuce:\r\n      pool:\r\n        min-idle: 8\r\n        max-idle: 500\r\n        max-active: 2000\r\n        max-wait: 10000\r\n    timeout: 5000\r\nmybatis-plus:\r\n  type-aliases-package: cc.mrbird.febs.common.core.entity.system\r\n  mapper-locations: classpath:mapper/*.xml\r\n  configuration:\r\n    jdbc-type-for-null: null\r\n  global-config:\r\n    banner: false\r\ninfo:\r\n  app:\r\n    name: ${spring.application.name}\r\n    description: \"@project.description@\"\r\n    version: \"@project.version@\"\r\n\r\nmanagement:\r\n  endpoints:\r\n    web:\r\n      exposure:\r\n        include: \'*\'\r\n  endpoint:\r\n    health:\r\n      show-details: ALWAYS\r\n\r\njustauth:\r\n  enabled: true\r\n  type:\r\n    github:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    gitee:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    tencent_cloud:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    dingtalk:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    qq:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    microsoft:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n  cache:\r\n    type: redis\r\n    prefix: \'FEBS::CLOUD::SOCIAL::STATE::\'\r\n    timeout: 1h\r\n\r\nfebs:\r\n  frontUrl: \'http://localhost:9527\'\r\n  doc:\r\n    enable: true\r\n    title: ${spring.application.name}文档\r\n    base-package: cc.mrbird.febs.auth.controller\r\n    description: ${febs.doc.title}\r\n    name: MrBird\r\n    email: 852252810@qq.com\r\n    url: https://mrbird.cc\r\n    version: 2.2-RELEASE\r\n  log:\r\n    elk:\r\n      enable: false\r\n      enableLogForController: false\r\n      logstashHost: ${logstash.url}:4560\r\n  cloud:\r\n    security:\r\n      enable: true\r\n      only-fetch-by-gateway: false\r\n      anon-uris: /actuator/**,/captcha,/social/**,/v2/api-docs,/v2/api-docs-ext,/login,/resource/**', '54c759d7da87b5c323593185e9c87b90', '2020-04-18 10:01:55', '2020-05-07 15:14:54', NULL, '0:0:0:0:0:0:0:1', '', '', 'FEBS-Auth微服务配置', 'null', 'null', 'yaml', 'null');
COMMIT;

-- ----------------------------
-- Table structure for config_info_aggr
-- ----------------------------
DROP TABLE IF EXISTS `config_info_aggr`;
CREATE TABLE `config_info_aggr` (
                                    `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
                                    `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
                                    `group_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'group_id',
                                    `datum_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'datum_id',
                                    `content` longtext COLLATE utf8_bin NOT NULL COMMENT '内容',
                                    `gmt_modified` datetime NOT NULL COMMENT '修改时间',
                                    `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
                                    `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '租户字段',
                                    PRIMARY KEY (`id`) USING BTREE,
                                    UNIQUE KEY `uk_configinfoaggr_datagrouptenantdatum` (`data_id`,`group_id`,`tenant_id`,`datum_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='增加租户字段';

-- ----------------------------
-- Records of config_info_aggr
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for config_info_beta
-- ----------------------------
DROP TABLE IF EXISTS `config_info_beta`;
CREATE TABLE `config_info_beta` (
                                    `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
                                    `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
                                    `group_id` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'group_id',
                                    `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT 'app_name',
                                    `content` longtext COLLATE utf8_bin NOT NULL COMMENT 'content',
                                    `beta_ips` varchar(1024) COLLATE utf8_bin DEFAULT NULL COMMENT 'betaIps',
                                    `md5` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'md5',
                                    `gmt_create` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '创建时间',
                                    `gmt_modified` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '修改时间',
                                    `src_user` text COLLATE utf8_bin COMMENT 'source user',
                                    `src_ip` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT 'source ip',
                                    `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '租户字段',
                                    PRIMARY KEY (`id`) USING BTREE,
                                    UNIQUE KEY `uk_configinfobeta_datagrouptenant` (`data_id`,`group_id`,`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='config_info_beta';

-- ----------------------------
-- Records of config_info_beta
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for config_info_tag
-- ----------------------------
DROP TABLE IF EXISTS `config_info_tag`;
CREATE TABLE `config_info_tag` (
                                   `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
                                   `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
                                   `group_id` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'group_id',
                                   `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT 'tenant_id',
                                   `tag_id` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'tag_id',
                                   `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT 'app_name',
                                   `content` longtext COLLATE utf8_bin NOT NULL COMMENT 'content',
                                   `md5` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'md5',
                                   `gmt_create` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '创建时间',
                                   `gmt_modified` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '修改时间',
                                   `src_user` text COLLATE utf8_bin COMMENT 'source user',
                                   `src_ip` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT 'source ip',
                                   PRIMARY KEY (`id`) USING BTREE,
                                   UNIQUE KEY `uk_configinfotag_datagrouptenanttag` (`data_id`,`group_id`,`tenant_id`,`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='config_info_tag';

-- ----------------------------
-- Records of config_info_tag
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for config_tags_relation
-- ----------------------------
DROP TABLE IF EXISTS `config_tags_relation`;
CREATE TABLE `config_tags_relation` (
                                        `id` bigint(20) NOT NULL COMMENT 'id',
                                        `tag_name` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'tag_name',
                                        `tag_type` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT 'tag_type',
                                        `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
                                        `group_id` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'group_id',
                                        `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT 'tenant_id',
                                        `nid` bigint(20) NOT NULL AUTO_INCREMENT,
                                        PRIMARY KEY (`nid`) USING BTREE,
                                        UNIQUE KEY `uk_configtagrelation_configidtag` (`id`,`tag_name`,`tag_type`) USING BTREE,
                                        KEY `idx_tenant_id` (`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='config_tag_relation';

-- ----------------------------
-- Records of config_tags_relation
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for group_capacity
-- ----------------------------
DROP TABLE IF EXISTS `group_capacity`;
CREATE TABLE `group_capacity` (
                                  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                  `group_id` varchar(128) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
                                  `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
                                  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
                                  `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
                                  `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
                                  `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
                                  `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
                                  `gmt_create` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '创建时间',
                                  `gmt_modified` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '修改时间',
                                  PRIMARY KEY (`id`) USING BTREE,
                                  UNIQUE KEY `uk_group_id` (`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='集群、各Group容量信息表';

-- ----------------------------
-- Records of group_capacity
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for his_config_info
-- ----------------------------
DROP TABLE IF EXISTS `his_config_info`;
CREATE TABLE `his_config_info` (
                                   `id` bigint(64) unsigned NOT NULL,
                                   `nid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                   `data_id` varchar(255) COLLATE utf8_bin NOT NULL,
                                   `group_id` varchar(128) COLLATE utf8_bin NOT NULL,
                                   `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT 'app_name',
                                   `content` longtext COLLATE utf8_bin NOT NULL,
                                   `md5` varchar(32) COLLATE utf8_bin DEFAULT NULL,
                                   `gmt_create` datetime NOT NULL DEFAULT '2010-05-05 00:00:00',
                                   `gmt_modified` datetime NOT NULL DEFAULT '2010-05-05 00:00:00',
                                   `src_user` text COLLATE utf8_bin,
                                   `src_ip` varchar(20) COLLATE utf8_bin DEFAULT NULL,
                                   `op_type` char(10) COLLATE utf8_bin DEFAULT NULL,
                                   `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '租户字段',
                                   PRIMARY KEY (`nid`) USING BTREE,
                                   KEY `idx_gmt_create` (`gmt_create`) USING BTREE,
                                   KEY `idx_gmt_modified` (`gmt_modified`) USING BTREE,
                                   KEY `idx_did` (`data_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='多租户改造';

-- ----------------------------
-- Records of his_config_info
-- ----------------------------
BEGIN;
INSERT INTO `his_config_info` VALUES (83, 85, 'febs-auth.yaml', 'DEFAULT_GROUP', '', 'server:\r\n  port: 8101\r\nspring:\r\n  datasource:\r\n    dynamic:\r\n      hikari:\r\n        connection-timeout: 30000\r\n        max-lifetime: 1800000\r\n        max-pool-size: 15\r\n        min-idle: 5\r\n        connection-test-query: select 1\r\n        pool-name: FebsHikariCP\r\n      primary: base\r\n      datasource:\r\n        base:\r\n          username: root\r\n          password: 123456\r\n          driver-class-name: com.mysql.cj.jdbc.Driver\r\n          url: jdbc:mysql://${mysql.url}:3306/febs_cloud_base?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8\r\n\r\n  jackson:\r\n    date-format: yyyy-MM-dd HH:mm:ss\r\n    time-zone: GMT+8\r\n  boot:\r\n    admin:\r\n      client:\r\n        url: http://${febs-admin}:8401\r\n        username: febs\r\n        password: 123456\r\n        instance:\r\n          prefer-ip: true\r\n\r\n  redis:\r\n    database: 0\r\n    host: ${redis.url}\r\n    port: 6379\r\n    lettuce:\r\n      pool:\r\n        min-idle: 8\r\n        max-idle: 500\r\n        max-active: 2000\r\n        max-wait: 10000\r\n    timeout: 5000\r\nmybatis-plus:\r\n  type-aliases-package: cc.mrbird.febs.common.core.entity.system\r\n  mapper-locations: classpath:mapper/*.xml\r\n  configuration:\r\n    jdbc-type-for-null: null\r\n  global-config:\r\n    banner: false\r\ninfo:\r\n  app:\r\n    name: ${spring.application.name}\r\n    description: \"@project.description@\"\r\n    version: \"@project.version@\"\r\n\r\nmanagement:\r\n  endpoints:\r\n    web:\r\n      exposure:\r\n        include: \'*\'\r\n  endpoint:\r\n    health:\r\n      show-details: ALWAYS\r\n\r\njustauth:\r\n  enabled: true\r\n  type:\r\n    github:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    gitee:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    tencent_cloud:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    dingtalk:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    qq:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n    microsoft:\r\n      client-id: \r\n      client-secret: \r\n      redirect-uri: \r\n  cache:\r\n    type: redis\r\n    prefix: \'FEBS::CLOUD::SOCIAL::STATE::\'\r\n    timeout: 1h\r\n\r\nfebs:\r\n  frontUrl: \'http://localhost:9527\'\r\n  doc:\r\n    enable: true\r\n    title: ${spring.application.name}文档\r\n    base-package: cc.mrbird.febs.auth.controller\r\n    description: ${febs.doc.title}\r\n    name: MrBird\r\n    email: 852252810@qq.com\r\n    url: https://mrbird.cc\r\n    version: 2.2-RELEASE\r\n  log:\r\n    elk:\r\n      enable: false\r\n      enableLogForController: false\r\n      logstashHost: ${logstash.url}:4560\r\n  cloud:\r\n    security:\r\n      enable: true\r\n      anon-uris: /actuator/**,/captcha,/social/**,/v2/api-docs,/v2/api-docs-ext', '7b15f74be22544569e21900500d08703', '2010-05-05 00:00:00', '2020-05-07 15:14:54', NULL, '0:0:0:0:0:0:0:1', 'U', '');
COMMIT;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
                         `username` varchar(50) NOT NULL,
                         `role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of roles
-- ----------------------------
BEGIN;
INSERT INTO `roles` VALUES ('febs', 'ROLE_ADMIN');
COMMIT;

-- ----------------------------
-- Table structure for tenant_capacity
-- ----------------------------
DROP TABLE IF EXISTS `tenant_capacity`;
CREATE TABLE `tenant_capacity` (
                                   `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                   `tenant_id` varchar(128) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Tenant ID',
                                   `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
                                   `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
                                   `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
                                   `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
                                   `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
                                   `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
                                   `gmt_create` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '创建时间',
                                   `gmt_modified` datetime NOT NULL DEFAULT '2010-05-05 00:00:00' COMMENT '修改时间',
                                   PRIMARY KEY (`id`) USING BTREE,
                                   UNIQUE KEY `uk_tenant_id` (`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='租户容量信息表';

-- ----------------------------
-- Records of tenant_capacity
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tenant_info
-- ----------------------------
DROP TABLE IF EXISTS `tenant_info`;
CREATE TABLE `tenant_info` (
                               `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
                               `kp` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'kp',
                               `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT 'tenant_id',
                               `tenant_name` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT 'tenant_name',
                               `tenant_desc` varchar(256) COLLATE utf8_bin DEFAULT NULL COMMENT 'tenant_desc',
                               `create_source` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'create_source',
                               `gmt_create` bigint(20) NOT NULL COMMENT '创建时间',
                               `gmt_modified` bigint(20) NOT NULL COMMENT '修改时间',
                               PRIMARY KEY (`id`) USING BTREE,
                               UNIQUE KEY `uk_tenant_info_kptenantid` (`kp`,`tenant_id`) USING BTREE,
                               KEY `idx_tenant_id` (`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='tenant_info';

-- ----------------------------
-- Records of tenant_info
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
                         `username` varchar(50) NOT NULL,
                         `password` varchar(500) NOT NULL,
                         `enabled` tinyint(1) NOT NULL,
                         PRIMARY KEY (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES ('febs', '$2a$10$NJRJ.JUIUVX5suXNFRuOFezX5nzQLxl86OyMNnA7yxH1zr94H/gBS', 1);
COMMIT;

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
                               `role` varchar(50) NOT NULL,
                               `resource` varchar(512) NOT NULL,
                               `action` varchar(8) NOT NULL,
                               UNIQUE KEY `uk_role_permission` (`role`,`resource`,`action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
