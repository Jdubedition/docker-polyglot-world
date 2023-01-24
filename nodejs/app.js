"use strict";

const express = require("express");
const os = require("os");
const fs = require("fs");

// App
const app = express();

app.use(function (req, res, next) {
  console.log(
    `INFO: ${req.ip} ${req.method} ${req.path} ${req.protocol} ${res.statusCode}`
  );
  next();
});

app.get("/", (req, res) => {
  try {
    const languages = JSON.parse(fs.readFileSync("../hello-world.json"));
    const random_language =
      languages[Math.floor(Math.random() * languages.length)];
    res.setHeader("Content-Type", "application/json");
    res.send(
      JSON.stringify({
        language: random_language.language,
        greeting: random_language.greeting,
        from: os.hostname(),
        implementation: "NodeJS",
      })
    );
  } catch (err) {
    res.status(500).send({ error: err.message });
  }
});

// Export app as a module
module.exports = app;
