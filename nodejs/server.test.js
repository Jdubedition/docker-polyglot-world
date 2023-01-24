const request = require("supertest");
const app = require("./app.js");
const fs = require("fs");

const PORT = 8080;
const HOST = "0.0.0.0";

let server;

describe("GET /", () => {
  beforeAll(() => {
    // Start the server before running the tests
    server = app.listen(PORT, HOST);
  });

  afterAll(async () => {
    // Wait for the server to finish processing requests before closing it
    await new Promise((resolve) => server.close(resolve));
  });

  it("should return a JSON object with a 'language', 'greeting', 'from', and 'implementation' property", async () => {
    const res = await request(app).get("/");
    const languages = JSON.parse(fs.readFileSync("../hello-world.json"));
    const language = res.body.language;
    const greeting = res.body.greeting;

    expect(res.statusCode).toEqual(200);
    expect(res.type).toEqual("application/json");
    expect(res.body.from).toBeDefined();
    expect(res.body.implementation).toBeDefined();
    expect(
      languages.find((l) => l.language === language && l.greeting === greeting)
    ).toBeDefined();
  });
});
