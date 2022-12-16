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

## Building and running Docker images
Make sure you have [Docker Engine](https://docs.docker.com/engine/install/) installed.  You should also checkout my article, Are You Not Contained!, on [BountifulBytes](https://bountifulbytes.com/).

### Python
```text
docker build -t python-docker-polyglot-world -f python/python.Dockerfile python
```

```text
docker run -it -p 8080:80 python-docker-polyglot-world
```

### Go
```text
docker build -t go-docker-polyglot-world -f go/go.Dockerfile go
```

```test
docker run -it -p 8080:8080 go-docker-polyglot-world
```

### Node.js
```text
docker build -t nodejs-docker-polyglot-world -f nodejs/nodejs.Dockerfile nodejs
```

```text
docker run -it -p 8080:8080 nodejs-docker-polyglot-world
```

## Running applications without Docker

### Python
* Install Python
* Install a virtual environment ([pyenv](https://github.com/pyenv/pyenv-installer) is a good choice for this but others exist)
* Activate the virtual environment (if using pyenv: `pyenv activate <env-name>`)
* Install the dependencies `pip install -r python/requirements.txt`
* Run the application `uvicorn python.main:app --reload`

### Go
* Install Go
* Run the application `go run go/main.go`

### Node.js
* Install Node.js
* `cd nodejs`
* Install node dependencies `npm install`
* Run the application `node server.js`
