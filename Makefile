#!/usr/bin/make -f
# Copyright (c) 2020 TurnKey GNU/Linux - https://www.turnkeylinux.org

ifndef RELEASE
$(error RELEASE not defined)
endif

DISTRO = $(shell dirname $(RELEASE))
CODENAME = $(shell basename $(RELEASE))

FAB_ARCH = $(shell dpkg --print-architecture)
MIRROR ?= http://deb.debian.org/debian
VARIANT ?= minbase
EXTRA_PKGS ?= gpg,gpg-agent
REMOVELIST ?= ./removelist

# build output path
O ?= build

.PHONY: all
all: $O/bootstrap.tar.gz

help:
	@echo '=== Configurable variables'
	@echo 'Resolution order:'
	@echo '1) command line (highest precedence)'
	@echo '2) product Makefile'
	@echo '3) environment variable'
	@echo '4) built-in default (lowest precedence)'
	@echo
	@echo '# Mandatory configuration variables:'
	@echo '  RELEASE                    $(value RELEASE)'
	@echo
	@echo '# Build context variables'
	@echo '  FAB_ARCH                   $(value FAB_ARCH)'
	@echo '  MIRROR                     $(value MIRROR)'
	@echo '  VARIANT                    $(value VARIANT)'
	@echo '  EXTRA_PKGS                 $(value EXTRA_PKGS)'
	@echo '  REMOVELIST                 $(value REMOVELIST)'
	@echo
	@echo '# Product output variables   [VALUE]'
	@echo '  O                          $(value O)/'
	@echo
	@echo '=== Usage'
	@echo '# remake target and the targets that depend on it'
	@echo '$$ make <target>'
	@echo
	@echo '# build a target (default: bootstrap.tar.gz)'
	@echo '$$ make [target] [O=path/to/build/dir]'
	@echo
	@echo '  clean            # clean all build targets'
	@echo '  bootstrap        # build bootstrap with debootstrap'
	@echo '  show-packages    # show packages installed in bootstrap'
	@echo '  removelist       # apply removelist'
	@echo '  bootstrap.tar.gz # build tarball from bootstrap'

.PHONY: clean
clean:
	rm -rf $O/bootstrap $O/bootstrap.tar.gz

.PHONY: show-packages
show-packages: $O/bootstrap
	fab-chroot build/bootstrap "dpkg -l | grep ^ii"

$O/bootstrap:
	debootstrap --arch=$(FAB_ARCH) --variant=$(VARIANT) --include=$(EXTRA_PKGS) $(CODENAME) $O/bootstrap $(MIRROR)

.PHONY: bootstrap
bootstrap: $O/bootstrap

.PHONY: removelist
removelist: $O/bootstrap
	fab-apply-removelist $(REMOVELIST) $O/bootstrap

$O/bootstrap.tar.gz: removelist
	tar -C $O/bootstrap -zcf $O/bootstrap.tar.gz .

.PHONY: bootstrap.tar.gz
bootstrap.tar.gz: $O/bootstrap.tar.gz
