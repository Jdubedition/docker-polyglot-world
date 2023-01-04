import { handleRequest } from "./controller.ts";

export async function route(req: Request): Promise<Response> {
  const path = new URL(req.url).pathname;
  switch (path) {
    case "/": {
      switch (req.method) {
        case "GET":
          return await handleRequest();
        default:
          return new Response(null, { status: 405 });
      }
    }
    default:
      return new Response(null, { status: 404 });
  }
}
