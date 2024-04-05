APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ghcr.io/bohdan99i
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=windows
TARGETARCH=arm64

linux:
	$(MAKE) image TARGETOS=linux TARGETARCH=${TARGETARCH}

windows:
	$(MAKE) image TARGETOS=windows TARGETARCH=${TARGETARCH}

macos:
	$(MAKE) image TARGETOS=darwin TARGETARCH=${TARGETARCH}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o tbot -ldflags "-X=github.com/Bohdan99I/tbot/cmd.appVersion=$(VERSION)"

image:
	docker build . -t $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH) 


push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)

clean:
	rm -rf tbot
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)
