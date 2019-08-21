## Define constants
VERSION=latest
TAG_PRE_BUILD_IMAGE=k8s-diag-pre
K8S_DIAG_IMAGE=k8s-diagnose
FULL_URL_IMAGE=registry.cn-hangzhou.aliyuncs.com/solomonxu/$(K8S_DIAG_IMAGE):$(VERSION)

## Check docker image pre-build-image if existed
pre-image-count := $(shell docker images | grep $(TAG_PRE_BUILD_IMAGE) | wc -l)
pre-image-id    := $(shell docker images | grep $(TAG_PRE_BUILD_IMAGE) | grep centos | awk '{print $$3}')
diag-image-id   := $(shell docker images | grep $(K8S_DIAG_IMAGE) | grep $(VERSION) | awk '{print $$3}')

## .PHONY
.PHONY: all image-pre

## Build all
all: pre-build-image
#	echo "This will make Docker image $(K8S_DIAG_IMAGE) ..."
	docker build -f Dockerfile -t $(K8S_DIAG_IMAGE):$(VERSION) .

## Build pre-build-image
pre-build-image:
	@if [ "$(pre-image-count)" = "0" ]; then \
#		echo "This will make Docker image centos:$(TAG_PRE_BUILD_IMAGE) ..."; \
		docker build -f Dockerfile.pre -t centos:$(TAG_PRE_BUILD_IMAGE) . ; \
	else \
#		echo "Docker image centos:$(TAG_PRE_BUILD_IMAGE) has existed. Omit step of pre-build-image."; \
		echo ""; \
	fi

## Cleanup images
cleanup: cleanup-diag
	@if [ -n "$(pre-image-id)" ]; then \
		echo "This will remove Docker image centos:$(TAG_PRE_BUILD_IMAGE) now, IMAGE ID: $(pre-image-id)."; \
		docker rmi $(pre-image-id) ; \
	fi
	
## Cleanup image k8s-diagnose
cleanup-diag:
	@if [ -n "$(diag-image-id)" ]; then \
		echo "This will remove Docker image $(K8S_DIAG_IMAGE) now, IMAGE ID: $(diag-image-id)."; \
		docker rmi $(diag-image-id) ; \
	fi
	
## Push to repository
push:
	docker tag $(K8S_DIAG_IMAGE):$(VERSION) $(FULL_URL_IMAGE)
	docker push $(FULL_URL_IMAGE)	