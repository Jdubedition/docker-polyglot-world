#build stage
FROM crystallang/crystal:1.6-alpine AS build

WORKDIR /app

COPY *.cr .
RUN crystal build --release --static hello_world.cr

# #run stage
FROM alpine:latest

WORKDIR /app

COPY --from=build /app/hello_world .

EXPOSE 8080

ENTRYPOINT [ "./hello_world" ]
