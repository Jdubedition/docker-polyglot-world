from socket import gethostname
from starlette.applications import Starlette
from starlette.responses import JSONResponse, Response
from starlette.routing import Route
from starlette.status import HTTP_500_INTERNAL_SERVER_ERROR


async def homepage(request):
    try:
        hostname = gethostname()
    except Exception:
        return Response(status_code=HTTP_500_INTERNAL_SERVER_ERROR)
    return JSONResponse({"hello": "World", "from": hostname})


app = Starlette(
    debug=True,
    routes=[
        Route("/", homepage),
    ],
)
