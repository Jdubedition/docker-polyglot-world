const app = require("./app");
const request = require("supertest");
const fs = require("fs");

// Mock the hostname function
jest.mock("os");
const hostnameMock = require("os").hostname;
hostnameMock.mockImplementation(() => "test-hostname");

describe("App", () => {
  describe("GET /", () => {
    it("should return a JSON object with a 'language', 'greeting', 'from', and 'implementation' property", (done) => {
      request(app)
        .get("/")
        .end((err, res) => {
          let data = require("../hello-world.json");
          let response = res.body;
          let languageExists = data.some(function (el) {
            return el.language === response.language;
          });
          let greetingExists = data.some(function (el) {
            return el.greeting === response.greeting;
          });
          expect(response).toHaveProperty("language");
          expect(response).toHaveProperty("greeting");
          expect(response).toHaveProperty("from");
          expect(response).toHaveProperty("implementation");
          expect(languageExists).toBe(true);
          expect(greetingExists).toBe(true);
          done();
        });
    });

    it("should return a JSON object with an error message", (done) => {
      // Define the behavior of the mock function
      hostnameMock.mockImplementation(() => {
        throw new Error("Error getting hostname");
      });
      request(app)
        .get("/")
        .end((err, res) => {
          expect(res.statusCode).toEqual(500);
          expect(res.type).toEqual("application/json");
          expect(res.body.error).toEqual("Error getting hostname");
          done();
        });
    });
  });
});
