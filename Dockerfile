FROM golang:1.26-alpine AS builder
RUN apk add --no-cache git
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags "-s -w \
    -X main.version=$(git describe --tags --always --dirty 2>/dev/null || echo dev) \
    -X main.buildTime=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    -tags "with_quic with_utls with_wireguard with_acme with_clash_api" \
    -o rua-edge ./cmd/rua-edge

FROM alpine:3.20
RUN apk add --no-cache ca-certificates tzdata
COPY --from=builder /build/rua-edge /usr/local/bin/rua-edge
RUN mkdir -p /etc/rua-edge
WORKDIR /etc/rua-edge
ENTRYPOINT ["rua-edge"]
CMD ["-c", "/etc/rua-edge/config.yml"]
