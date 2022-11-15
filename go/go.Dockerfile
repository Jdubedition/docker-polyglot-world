FROM golang:1.19.3-alpine3.16

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY *.go ./

RUN go build -o /helloworld

EXPOSE 8080

CMD [ "/helloworld" ]
