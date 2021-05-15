/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MongoDB
 Source Server Version : 40202
 Source Host           : localhost:27017
 Source Schema         : febs_cloud_route

 Target Server Type    : MongoDB
 Target Server Version : 40202
 File Encoding         : 65001

 Date: 14/01/2020 11:04:22
*/


// ----------------------------
// Collection structure for blackList
// ----------------------------
db.getCollection("blackList").drop();
db.createCollection("blackList");

// ----------------------------
// Documents of blackList
// ----------------------------
db.getCollection("blackList").insert([ {
    _id: ObjectId("5e1425e7a548e77106e43b40"),
    ip: "",
    requestUri: "/**/actuator/**",
    requestMethod: "ALL",
    limitFrom: "",
    limitTo: "",
    location: "",
    status: "1",
    createTime: "2020-01-07 14:32:07",
    _class: "cc.mrbird.febs.gateway.entity.BlackList"
} ]);

// ----------------------------
// Collection structure for blockLog
// ----------------------------
db.getCollection("blockLog").drop();
db.createCollection("blockLog");

// ----------------------------
// Collection structure for rateLimitLog
// ----------------------------
db.getCollection("rateLimitLog").drop();
db.createCollection("rateLimitLog");

// ----------------------------
// Collection structure for rateLimitRule
// ----------------------------
db.getCollection("rateLimitRule").drop();
db.createCollection("rateLimitRule");

// ----------------------------
// Documents of rateLimitRule
// ----------------------------
db.getCollection("rateLimitRule").insert([ {
    _id: ObjectId("5e1abc9ef51708123d94b1f8"),
    requestUri: "/auth/captcha",
    requestMethod: "GET",
    limitFrom: "06:00:00",
    limitTo: "22:30:00",
    count: "3",
    intervalSec: "10",
    status: "1",
    createTime: "2020-01-12 14:28:46",
    _class: "cc.mrbird.febs.gateway.enhance.entity.RateLimitRule"
} ]);

// ----------------------------
// Collection structure for routeLog
// ----------------------------
db.getCollection("routeLog").drop();
db.createCollection("routeLog");

// ----------------------------
// Collection structure for routeUser
// ----------------------------
db.getCollection("routeUser").drop();
db.createCollection("routeUser");

// ----------------------------
// Documents of routeUser
// ----------------------------
db.getCollection("routeUser").insert([ {
    _id: ObjectId("5e1d2ee055165e6516c23057"),
    username: "Jack",
    password: "$2a$10$NBv548VFJ6OyTkxcHy9o5uRNaYSMPHWHW9fL3ZRlS1Hy5kxlR1qdy",
    roles: "user",
    createTime: "2020-01-14 11:00:48",
    _class: "cc.mrbird.febs.gateway.enhance.entity.RouteUser"
} ]);
db.getCollection("routeUser").insert([ {
    _id: ObjectId("5e1d2eee55165e6516c23058"),
    username: "admin",
    password: "$2a$10$WeUSapCOv8uDb2MrUu19cOo6O.Xb4PAJN/4GdAfIcgJ3SAWw.NY3m",
    roles: "admin",
    createTime: "2020-01-14 11:01:02",
    _class: "cc.mrbird.febs.gateway.enhance.entity.RouteUser"
} ]);
