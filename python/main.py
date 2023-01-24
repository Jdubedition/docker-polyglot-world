import json
import random
from socket import gethostname
from starlette.applications import Starlette
from starlette.responses import JSONResponse, Response
from starlette.routing import Route
from starlette.status import HTTP_500_INTERNAL_SERVER_ERROR


async def homepage(request):
    try:
        hostname = gethostname()
        with open("../hello-world.json", "r") as f:
            languages = json.load(f)
        random_language = random.choice(languages)
    except Exception as e:
        return Response(status_code=HTTP_500_INTERNAL_SERVER_ERROR, content=str(e))
    return JSONResponse(
        {
            "language": random_language["language"],
            "greeting": random_language["greeting"],
            "from": hostname,
            "implementation": "Python",
        }
    )


app = Starlette(
    debug=True,
    routes=[
        Route("/", homepage),
    ],
)
