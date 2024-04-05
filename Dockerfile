FROM golang:1.22.1 as builder

WORKDIR /go/src/app
COPY . .

RUN make build 

FROM alpine:latest
WORKDIR /
COPY --from=builder /go/src/app/tbot .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./tbot"]
