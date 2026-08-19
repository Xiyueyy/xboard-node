VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
BUILD_TIME ?= $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
LDFLAGS := -s -w -X main.version=$(VERSION) -X main.buildTime=$(BUILD_TIME)
BUILD_TAGS := with_quic with_utls with_wireguard with_acme with_clash_api

.PHONY: build clean test docker install build-linux build-linux-arm64 build-all

build:
	go build -trimpath -ldflags "$(LDFLAGS)" -tags "$(BUILD_TAGS)" -o rua-edge ./cmd/rua-edge
	go build -trimpath -ldflags "$(LDFLAGS)" -o rua-edge-ctl ./cmd/rua-edge-ctl

build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags "$(LDFLAGS)" -tags "$(BUILD_TAGS)" -o rua-edge-linux-amd64 ./cmd/rua-edge
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags "$(LDFLAGS)" -o rua-edge-ctl-linux-amd64 ./cmd/rua-edge-ctl

build-linux-arm64:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -trimpath -ldflags "$(LDFLAGS)" -tags "$(BUILD_TAGS)" -o rua-edge-linux-arm64 ./cmd/rua-edge
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -trimpath -ldflags "$(LDFLAGS)" -o rua-edge-ctl-linux-arm64 ./cmd/rua-edge-ctl

build-all: build-linux build-linux-arm64

test:
	go test -race -count=1 ./...
	bash scripts/test-install-migration.sh

clean:
	rm -f rua-edge rua-edge-ctl rua-edge-linux-* rua-edge-ctl-linux-*

docker:
	docker build -t rua-edge:$(VERSION) -t rua-edge:latest .

install: build
	sudo cp rua-edge /usr/local/bin/
	sudo cp rua-edge-ctl /usr/local/bin/
	sudo mkdir -p /etc/rua-edge
	@if [ ! -f /etc/rua-edge/config.yml ]; then \
		sudo cp config.yml.example /etc/rua-edge/config.yml; \
		echo "Config copied to /etc/rua-edge/config.yml - please edit it"; \
	fi
