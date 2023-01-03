const app = require("./app");
const request = require("supertest");
const os = require("os");

// Create a mock function that wraps the original os.hostname function
const hostnameMock = jest.spyOn(os, "hostname");

describe("App", () => {
  describe("GET /", () => {
    afterEach(() => {
      // Reset the mock after the test is finished
      hostnameMock.mockReset();
    });

    it("should return a JSON object with a 'hello' and 'from' property", (done) => {
      request(app)
        .get("/")
        .end((err, res) => {
          expect(res.body).toHaveProperty("hello");
          expect(res.body).toHaveProperty("from");
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
