# docker-polyglot-world

Welcome to the repository that shares multiple implementations of Hello World web server in different programming languages, wrapped by a Docker container.

Programming languages:
* Python
* Go
* JavaScript
* TypeScript
* Rust
* Crystal
* More to come...

## The setup
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine plus Docker Compose
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Building and running Docker images
### All at once with Docker Compose
```text
docker compose up --build
```
### Python (Starlette)
```text
docker build -t python-docker-polyglot-world -f python/python.Dockerfile python && docker run -it -p 8080:8080 python-docker-polyglot-world
```

### Go
```text
docker build -t go-docker-polyglot-world -f go/go.Dockerfile go && docker run -it -p 8080:8080 go-docker-polyglot-world
```

### Node.js (express)
```text
docker build -t nodejs-docker-polyglot-world -f nodejs/nodejs.Dockerfile nodejs  && docker run -it -p 8080:8080 nodejs-docker-polyglot-world
```

### Rust (hyper)
```text
docker build -t rust-docker-polyglot-world -f rust/rust.Dockerfile rust  && docker run -it -p 8080:8080 rust-docker-polyglot-world
```

### Deno
```text
docker build -t deno-docker-polyglot-world -f deno/deno.Dockerfile deno  && docker run -it -p 8080:8080 deno-docker-polyglot-world
```

### Crystal
```text
docker build -t crystal-docker-polyglot-world -f crystal/crystal.Dockerfile crystal  && docker run -it -p 8080:8080 crystal-docker-polyglot-world
```

## Developing with Docker containers

### Python
#### With OMZ and selecting name of the container
```text
docker run -d -it -v ~/docker-polyglot-world:/docker-polyglot-world --name docker-polyglot-world-python python:3.11.0 /docker-polyglot-world/utilities/use-omz.sh
```
#### With BASH
```text
docker run -d -it -v ~/docker-polyglot-world:/docker-polyglot-world python:3.11.0 /bin/bash
```

## Inspired By
* https://www.starlette.io/
* https://go.dev/doc/articles/wiki/
* https://expressjs.com/en/starter/hello-world.html
* https://hyper.rs/guides/1/server/hello-world/
* https://deno.land/manual@v1.28.3/examples/http_server
* https://crystal-lang.org/api/1.6.2/HTTP/Server.html
* https://docs.docker.com/build/building/multi-stage/
* https://code.visualstudio.com/docs/devcontainers/containers
* https://www.cyberciti.biz/faq/bash-check-if-file-does-not-exist-linux-unix/
* https://ohmyz.sh/#install
* https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
* https://github.com/features/copilot
