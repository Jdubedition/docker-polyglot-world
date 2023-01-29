import {
  assert,
  assertEquals,
} from "https://deno.land/std@0.170.0/testing/asserts.ts";
import { Greeting, handleRequest } from "./controller.ts";
import { stub } from "https://deno.land/std@0.170.0/testing/mock.ts";
import { readJson } from "https://deno.land/x/jsonfile@1.0.0/mod.ts";

Deno.test("handleRequest returns a Response with the correct body and headers", async () => {
  const greetings = await readJson("../hello-world.json") as Greeting[];

  const response = await handleRequest();

  assertEquals(response.status, 200);
  assertEquals(response.headers.get("content-type"), "application/json");

  const body = await response.text();
  const bodyObject = JSON.parse(body);

  let matchFound = false;
  for (const greeting of greetings) {
    if (
      bodyObject.greeting === greeting.greeting &&
      bodyObject.language === greeting.language
    ) {
      matchFound = true;
      break;
    }
  }

  assert(
    matchFound,
    "Response body does not match any greetings in hello-world.json",
  );
  assertEquals(bodyObject.from, Deno.hostname());
  assertEquals(bodyObject.implementation, "Deno");
});

Deno.test("handleRequest returns a Response with the correct body and headers", async () => {
  const hostnameStub = stub(Deno, "hostname", () => "mock-hostname");

  const response = await handleRequest();

  assertEquals(response.status, 200);
  assertEquals(response.headers.get("content-type"), "application/json");

  const body = await response.text();
  const bodyObject = JSON.parse(body);
  assertEquals(bodyObject.from, "mock-hostname");

  hostnameStub.restore();
});

Deno.test("handleRequest returns a 500 error if Deno.hostname throws an exception", async () => {
  const hostnameStub = stub(Deno, "hostname", () => {
    throw new Error("Deno.hostname error");
  });

  const response = await handleRequest();

  assertEquals(response.status, 500);

  hostnameStub.restore();
});
