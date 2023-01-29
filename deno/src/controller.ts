import { readJson } from "https://deno.land/x/jsonfile@1.0.0/mod.ts";

export interface Greeting {
  language: string;
  greeting: string;
}

export async function handleRequest(): Promise<Response> {
  let hostName;
  try {
    hostName = Deno.hostname();
  } catch (_error) {
    return new Response("", { status: 500 });
  }

  const greetings = await readJson(
    "../hello-world.json",
  ) as Greeting[];
  const randomIndex = Math.floor(Math.random() * greetings.length);
  const selectedGreeting = greetings[randomIndex];

  const body = JSON.stringify({
    language: selectedGreeting.language,
    greeting: selectedGreeting.greeting,
    from: hostName,
    implementation: "Deno",
  });

  return new Response(body, {
    status: 200,
    headers: {
      "content-type": "application/json",
    },
  });
}
