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
### One at a time (Python example)
```text
docker build -t python-docker-polyglot-world -f python/python.Dockerfile python && docker run -it -p 8080:80 python-docker-polyglot-world
```

### All at once with Docker Compose
```text
docker compose up --build
```
