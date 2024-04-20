APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=bohdan99i
# REPOSITORY=bohdan99i/tbot
VERSION=$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o tbot -ldflags "-X="github.com/Bohdan99I/tbot/cmd.appVersion=${VERSION}-${TARGETOS}-${TARGETARCH}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf tbot
	docker rmi ${REGISTRY}/${REPOSITORY}:${VERSION}-${TARGETOS}-${TARGETARCH}