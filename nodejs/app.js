"use strict";

const express = require("express");
const os = require("os");

// App
const app = express();

app.use(function (req, res, next) {
  console.log(
    `INFO: ${req.ip} ${req.method} ${req.path} ${req.protocol} ${res.statusCode}`
  );
  next();
});

app.get("/", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.send(JSON.stringify({ hello: "World", from: os.hostname() }));
});

// Export app as a module
module.exports = app;
