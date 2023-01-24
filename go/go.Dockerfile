#build stage
FROM golang:1.19.3-alpine3.16 AS build

WORKDIR /app

COPY go/go.mod ./
RUN go mod download

COPY go/*.go ./

RUN go build -o /helloworld

#run stage
FROM alpine:3.16

WORKDIR /app

COPY --from=build /helloworld .
# put the file in parent directory just like source repo
COPY hello-world.json /

EXPOSE 8080

ENTRYPOINT [ "./helloworld" ]
