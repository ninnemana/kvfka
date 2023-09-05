FROM golang:1.20.7-alpine AS builder

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh ca-certificates

COPY . /api
WORKDIR /api

ENV GO111MODULE=on
RUN go mod download

RUN CGO_ENABLED=0 go build -o /api/bin/api .

FROM alpine

RUN apk update && apk upgrade && \
    apk add --no-cache ca-certificates

COPY --from=builder /api/bin/api /api

EXPOSE 8080
EXPOSE 8081

ENTRYPOINT ["/api"]
