#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################

arch	= $(shell uname -m)

alpine		= $(CURDIR)/etc/docker/images/alpine
alpine_reg	= $(shell <$(alpine) grep '^reg' | cut -f2)
alpine_user	= $(shell <$(alpine) grep '^user' | cut -f2)
alpine_repo	= $(shell <$(alpine) grep '^repo' | cut -f2)
alpine_lbl	= $(shell <$(alpine) grep '^lbl' | cut -f2)
alpine_digest	= $(shell <$(alpine) grep '^digest' | grep '$(arch)' | cut -f3)

make	= $(CURDIR)/etc/docker/images/make
reg	= $(shell <$(make) grep '^reg' | cut -f2)
user	= $(shell <$(make) grep '^user' | cut -f2)
repo	= $(shell <$(make) grep '^repo' | cut -f2)
repository = $(reg)/$(user)/$(repo)
lbl	= $(shell git describe --tags | sed 's/^v//')
lbl_	= $(lbl)_$(arch)
img	= $(repository):$(lbl)
img_	= $(repository):$(lbl_)

.PHONY: all
all: image

.PHONY: Dockerfile
Dockerfile: $(CURDIR)/etc/docker/images/alpine
	@echo '	Update Dockerfile ARGs';
	@sed -i \
		-e '/^ARG	ALPINE_REG=/s/=.*/="$(alpine_reg)"/' \
		-e '/^ARG	ALPINE_USER=/s/=.*/="$(alpine_user)"/' \
		-e '/^ARG	ALPINE_REPO=/s/=.*/="$(alpine_repo)"/' \
		-e '/^ARG	ALPINE_LBL=/s/=.*/="$(alpine_lbl)"/' \
		-e '/^ARG	ALPINE_DIGEST=/s/=.*/="$(alpine_digest)"/' \
		$(CURDIR)/$@;

.PHONY: image
image: Dockerfile $(make)
	@echo '	DOCKER image build	$(img_)';
	@docker image build -t '$(img_)' $(CURDIR);

.PHONY: image-push
image-push:
	@echo '	DOCKER image push	$(img_)';
	@docker image push '$(img_)'; 

.PHONY: image-manifest
image-manifest:
	@echo '	DOCKER manifest create	$(img)';
	@docker manifest create '$(img)' '$(img)_x86_64' '$(img)_aarch64';

.PHONY: image-manifest-push
image-manifest-push:
	@echo '	DOCKER manifest push	$(img)';
	@docker manifest push '$(img)';
