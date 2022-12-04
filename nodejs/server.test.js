const request = require("supertest");
const app = require("./app.js");

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

  it("should return a JSON object with a message and hostname", async () => {
    const res = await request(app).get("/");

    expect(res.statusCode).toEqual(200);
    expect(res.type).toEqual("application/json");
    expect(res.body.hello).toEqual("World");
    expect(res.body.from).toBeDefined();
  });
});
