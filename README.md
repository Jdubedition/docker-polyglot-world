# docker-polyglot-world

Welcome to the repository that shares multiple implementations of Hello World web server in different programming languages, wrapped by a Docker container.

Programming languages:

- Python
- Go
- JavaScript
- TypeScript
- Rust
- Crystal
- More to come...

## The setup

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine plus Docker Compose
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [VSCode](https://code.visualstudio.com/download) with [Dev Containers](https://code.visualstudio.com/docs/remote/containers) extension

## Building and running Docker images

### All at once with Docker Compose

```text
docker compose --profile local-only up --build
```

### Python (Starlette)

```text
docker build -t python-docker-polyglot-world -f python/python.Dockerfile . && docker run -it -p 8080:8080 python-docker-polyglot-world
```

### Go

```text
docker build -t go-docker-polyglot-world -f go/go.Dockerfile . && docker run -it -p 8080:8080 go-docker-polyglot-world
```

### Node.js (express)

```text
docker build -t nodejs-docker-polyglot-world -f nodejs/nodejs.Dockerfile .  && docker run -it -p 8080:8080 nodejs-docker-polyglot-world
```

### Rust (hyper)

```text
docker build -t rust-docker-polyglot-world -f rust/rust.Dockerfile .  && docker run -it -p 8080:8080 rust-docker-polyglot-world
```

### Deno

```text
docker build -t deno-docker-polyglot-world -f deno/deno.Dockerfile .  && docker run -it -p 8080:8080 deno-docker-polyglot-world
```

### Crystal

```text
docker build -t crystal-docker-polyglot-world -f crystal/crystal.Dockerfile .  && docker run -it -p 8080:8080 crystal-docker-polyglot-world
```

## Developing with Docker containers

### Python

#### With OMZ and selecting name of the container

```text
docker run -d -it --network=host -v ~/docker-polyglot-world:/docker-polyglot-world --name docker-polyglot-world-python python:3.11.0 /docker-polyglot-world/utilities/use-omz.sh
```

#### With BASH

```text
docker run -d -it --network=host -v ~/docker-polyglot-world:/docker-polyglot-world python:3.11.0 /bin/bash
```

### Go

#### With OMZ and selecting name of the container

```text
docker run -d -it --network=host -v ~/docker-polyglot-world:/docker-polyglot-world --name docker-polyglot-world-go golang:1.19.3 /docker-polyglot-world/utilities/use-omz.sh
```

### Node.js

#### With OMZ and selecting name of the container

```text
docker run -d -it --network=host -v ~/docker-polyglot-world:/docker-polyglot-world --name docker-polyglot-world-nodejs node:19 /docker-polyglot-world/utilities/use-omz.sh
```

### Rust

#### With OMZ and selecting name of the container

```text
docker run -d -it --network=host -v ~/docker-polyglot-world:/docker-polyglot-world --name docker-polyglot-world-rust rust:1.65 /docker-polyglot-world/utilities/use-omz.sh
```

### Deno

#### With OMZ and selecting name of the container

```text
docker run -d -it --network=host -v ~/docker-polyglot-world:/docker-polyglot-world --name docker-polyglot-world-deno denoland/deno:1.28.1 /docker-polyglot-world/utilities/use-omz.sh
```

IMPORTANT! - After attaching to container:  Open the VS Code command palette with Ctrl+Shift+P, and run the Deno: Initialize Workspace Configuration command.


### Crystal

#### With OMZ and selecting name of the container

```text
docker run -d -it -v ~/docker-polyglot-world:/docker-polyglot-world --name docker-polyglot-world-crystal crystallang/crystal:1.6 /docker-polyglot-world/utilities/use-omz.sh
```

## Testing

### Unit tests

#### Python (Pytest in Dev Container)

```text
cd python
```

```text
pip install -r requirements.txt -r requirements-local.txt
```

```text
pytest
```

#### Go (Go test in Dev Container)

```text
cd go
```

```text
go test
```

#### Nodejs (Jest in Dev Container)

```text
cd nodejs
```

```text
yarn test
```

#### Rust (Rust test in Dev Container)

```text
cd rust/hello-world
```

```text
cargo test
```

#### Deno (Deno test in Dev Container)

```text
cd deno
```

```text
deno test --allow-sys
```

#### Crystal (Crystal test in Dev Container)

```text
cd crystal
```

```text
crystal spec *_spec.cr
```

## API testing

### Postman
* Install Postman
* Import polyglot-world.postman_collection.json
* Run collection

### Newman
* Use Nodejs dev container
* `npm install -g newman`
* Collection: `newman run polyglot-world.postman_collection.json`
* Collection with Cloudflare Tunnel: `newman run polyglot-world.postman_collection.js=on --env-var hostname=<<YOUR CLOUDFLARE TUNNEL HOSTNAME>>`
* Number and specific tests: `newman run polyglot-world.postman_collection.json -n 1 --folder Python`

## Supercharge With Cloudflare Tunnel (Optional)

* Create Cloudflare account
* Add your domain to Cloudflare
* Enable Cloudflare Tunnel
  * From the Cloudflare dashboard, click on the Zero Trust menu item
  * Click on the Access menu item
  * Click on Tunnels menu item
* Terraform Cloud
  * Create Terraform Cloud account
  * In Terraform Cloud, create a new workspace
    * Choose CLI-driven workflow
    * Name: `docker-polyglot-world`
  * Open Workspace settings and set Execution Mode to Local
* Copy `.env-template` to `.env` and set the variables within
  * In Terraform Cloud, click on your user profile icon and select User Settings
  * Click on Tokens menu item
  * Click on Create an API Token button
  * Copy the token to the `.env` file
* Copy `secret-template.tfvars` to `secret.tfvars` and set the variables within
  * Create an API token in Cloudflare with the permissions described here:  https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/deployment-guides/terraform/#3-create-a-cloudflare-api-token
  * On Cloudflare dashboard, click on your website
  * On the right side of the page, click copy the following IDs
    * Zone ID
    * Account ID
* `docker compose --profile cloudflare-tunnel up --build`
* If you want to remove Cloudflare Tunnel: `docker compose --profile destroy-cloudflare-tunnel up`

## Inspired By

- https://www.starlette.io/
- https://go.dev/doc/articles/wiki/
- https://expressjs.com/en/starter/hello-world.html
- https://hyper.rs/guides/1/server/hello-world/
- https://deno.land/manual@v1.28.3/examples/http_server
- https://crystal-lang.org/api/1.6.2/HTTP/Server.html
- https://docs.docker.com/build/building/multi-stage/
- https://code.visualstudio.com/docs/devcontainers/containers
- https://www.cyberciti.biz/faq/bash-check-if-file-does-not-exist-linux-unix/
- https://ohmyz.sh/#install
- https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
- https://github.com/features/copilot
- https://stackoverflow.com/questions/38136541/how-to-test-error-condition-for-this-function/38138024#38138024
- https://medium.com/@durgaswaroop/writing-better-tests-in-python-with-pytest-mock-part-2-92b828e1453c
- https://chat.openai.com/
- https://doc.rust-lang.org/book/ch11-03-test-organization.html
- https://stackoverflow.com/questions/63301838/how-to-read-the-response-body-as-a-string-in-rust-hyper
- https://medium.com/deno-the-complete-reference/unit-testing-of-http-server-in-deno-a03b1c028f92
- https://deno.land/manual@v1.29.1/basics/testing/mocking
- https://crystal-lang.org/reference/1.6/guides/testing.html
- https://github.com/crystal-lang/crystal/pull/11540
- https://www.postman.com/
- https://github.com/postmanlabs/newman
- https://hub.docker.com/_/nginx
- https://mixable.blog/hello-world-in-74-natural-languages/
- https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/
- https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/deployment-guides/terraform/
- https://hub.docker.com/r/cloudflare/cloudflared
- https://hub.docker.com/r/hashicorp/terraform
- https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables
- https://docs.docker.com/compose/compose-file/
