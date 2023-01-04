export async function handleRequest(): Promise<Response> {
  let hostName;
  try {
    hostName = Deno.hostname();
  } catch (_error) {
    return new Response("", { status: 500 });
  }

  const body = `{"hello":"World", "from":"${hostName}"}`;
  return await new Response(body, {
    status: 200,
    headers: {
      "content-type": "application/json",
    },
  });
}
