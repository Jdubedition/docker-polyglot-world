"use strict";

const express = require("express");
const os = require("os");

// Constants
const PORT = 8080;
const HOST = "0.0.0.0";

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

app.listen(PORT, HOST);

process.on("SIGINT", function () {
  // some other closing procedures go here
  process.exit(0);
});
