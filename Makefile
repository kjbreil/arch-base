NS = kjbreil
VERSION ?= $(shell date +'%Y.%m.%d')

REPO = arch-base
NAME = arch-base
INSTANCE = default
VOLUMES = -v $(CURDIR):/opt/build

PKGS=pacman
ROOTFS=/arch-root


.PHONY: image push push_latest shell run start stop rm release

image:
	docker build -t $(NS)/$(REPO) -t $(NS)/$(REPO) -t $(NS)/$(REPO):$(VERSION) .

push:
	docker push $(NS)/$(REPO):$(VERSION)
	docker push $(NS)/$(REPO)

heim:
	docker tag $(NS)/$(REPO):$(VERSION) heimdall.norgenet.net:5000/$(REPO):$(VERSION)
	docker tag $(NS)/$(REPO):$(VERSION) heimdall.norgenet.net:5000/$(REPO)
	docker push heimdall.norgenet.net:5000/$(REPO):$(VERSION)
	docker push heimdall.norgenet.net:5000/$(REPO)

shell:
	docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO) /bin/bash

bshell:
	docker run --rm --name $(NAME)-$(INSTANCE) --privileged -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/arch-build /bin/bash

run:
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

rootfs:
	docker run --rm -ti --privileged -v $(CURDIR):/opt/build kjbreil/arch-build

default: image

release: image push push_latest

inside:
	mkdir -p $(ROOTFS)
	pacstrap -c -d -G $(ROOTFS) $(PKGS)
	tar --numeric-owner --xattrs --acls -C "$(ROOTFS)" -c . | xz -f -3 > root.tar.xz