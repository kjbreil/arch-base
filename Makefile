NS = kjbreil
VERSION ?= $(shell date +'%Y.%m.%d')

REPO = arch-base
NAME = arch-base
INSTANCE = default

PKGS=pacman
ROOTFS=/arch-root

.PHONY: image push push_latest shell run start stop rm release

image:
	docker build --no-cache --force-rm -t $(NS)/$(REPO):$(VERSION) .

push:
	docker push $(NS)/$(REPO):$(VERSION)

push_latest:
	docker push $(NS)/$(REPO):latest

shell:
	docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

default: image

release: image push push_latest

inside:
	mkdir -p $(ROOTFS)
	pacstrap -c -d -G $(ROOTFS) $(PKGS)
	rm -f root.tar.xz root.tar
	tar --numeric-owner --xattrs --acls -C "$(ROOTFS)" -c . | xz -f -vvv -9 -e --lzma2=dict=128MiB > root.tar.xz