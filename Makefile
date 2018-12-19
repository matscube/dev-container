NAME := dev-container
VERSION := 1.1
VERSION_TAG := $(NAME):$(VERSION)
LATEST_TAG := $(NAME):latest

.PHONY: build
build:
	docker build -t $(VERSION_TAG) .
	docker build -t $(LATEST_TAG) .

nocache:
	docker build -t $(VERSION_TAG) . --no-cache=true
	docker build -t $(LATEST_TAG) . --no-cache=true
	
