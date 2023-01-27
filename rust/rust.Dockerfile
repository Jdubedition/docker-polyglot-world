FROM rust:1.65 as builder
WORKDIR /usr/src/hello-world
COPY rust/hello-world .
COPY hello-world.json /
RUN cargo install --path .

FROM debian:buster-slim
RUN apt-get update && apt-get install -y && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/hello-world /usr/local/bin/hello-world
COPY hello-world.json /
EXPOSE 8080
CMD ["hello-world"]
