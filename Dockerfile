# syntax=docker/dockerfile:1
FROM golang:1.18 as builder

WORKDIR /go_server
COPY . .
RUN go mod tidy
RUN go get -d -v ./...
RUN GOOS=linux GOARCH=amd64 go build -o server ./

FROM gcr.io/distroless/base-debian11

ENV TZ Europe/Kiev

WORKDIR /packet_listener
WORKDIR ./bin
COPY --from=builder /go_server/server ./

CMD ["/packet_listener/bin/server"]