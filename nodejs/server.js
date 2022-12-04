"use strict";

const app = require("./app.js");

// Constants
const PORT = 8080;
const HOST = "0.0.0.0";

// Start the app
app.listen(PORT, HOST);

process.on("SIGINT", function () {
  // some other closing procedures go here
  process.exit(0);
});
