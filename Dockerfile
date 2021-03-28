########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################


########################################################################
ARG	ALPINE_REG="docker.io"
ARG	ALPINE_USER="library"
ARG	ALPINE_REPO="alpine"
ARG	ALPINE_REPOSITORY="${ALPINE_REG}/${ALPINE_USER}/${ALPINE_REPO}"
ARG	ALPINE_LBL="3.13.3"
ARG	ALPINE_DIGEST="sha256:4266485e304a825d82c375d3584121b53c802e3540d6b520b212a9f0784d56f5"
########################################################################
FROM	"${ALPINE_REPOSITORY}:${ALPINE_LBL}@${ALPINE_DIGEST}" AS alpine
########################################################################
RUN	apk add make;
########################################################################
