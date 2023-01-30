#build stage
FROM crystallang/crystal:1.6-alpine AS build

WORKDIR /app

COPY crystal/*.cr .
COPY hello-world.json /
RUN crystal build --release --static hello_world.cr

# #run stage
FROM alpine:latest

WORKDIR /app

COPY --from=build /app/hello_world .
COPY --from=build /hello-world.json /

EXPOSE 8080

ENTRYPOINT [ "./hello_world" ]
