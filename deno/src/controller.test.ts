import { assertEquals } from "https://deno.land/std@0.170.0/testing/asserts.ts";
import { handleRequest } from "./controller.ts";
import { stub } from "https://deno.land/std@0.170.0/testing/mock.ts";

Deno.test("handleRequest returns a Response with the correct body and headers", async () => {
  const response = await handleRequest();

  assertEquals(response.status, 200);
  assertEquals(response.headers.get("content-type"), "application/json");

  const body = await response.text();
  const bodyObject = JSON.parse(body);
  assertEquals(bodyObject, {
    hello: "World",
    from: Deno.hostname(),
  });
});

Deno.test("handleRequest returns a Response with the correct body and headers", async () => {
  // Create a stub for the Deno.hostname function
  const hostnameStub = stub(Deno, "hostname", () => "mock-hostname");

  // Call the handleRequest function
  const response = await handleRequest();

  // Assert that the function returned a Response with the correct body and headers
  assertEquals(response.status, 200);
  assertEquals(response.headers.get("content-type"), "application/json");

  const body = await response.text();
  const bodyObject = JSON.parse(body);
  assertEquals(bodyObject, {
    hello: "World",
    from: "mock-hostname",
  });

  hostnameStub.restore();
});

Deno.test("handleRequest returns a 500 error if Deno.hostname throws an exception", async () => {
  // Create a stub for the Deno.hostname function
  const hostnameStub = stub(Deno, "hostname", () => {
    throw new Error("Deno.hostname error");
  });

  // Call the handleRequest function
  const response = await handleRequest();

  // Assert that the function returned a 500 error
  assertEquals(response.status, 500);

  // Restore the original Deno.hostname function
  hostnameStub.restore();
});
