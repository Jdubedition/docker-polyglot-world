#build stage
FROM golang:1.19.3-alpine3.16 AS build

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY *.go ./

RUN go build -o /helloworld

#run stage
FROM alpine:3.16

WORKDIR /app

COPY --from=build /helloworld .

EXPOSE 8080

ENTRYPOINT [ "./helloworld" ]
