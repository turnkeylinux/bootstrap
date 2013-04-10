RELEASE ?= debian/squeeze

ifndef BT
ifeq ('$(shell hostname)', 'backstage')
BT = /turnkey/private/buildtasks
else
BT = /turnkey/buildtasks
endif
endif

TARGET_RSYNC = $(FAB_PATH)/bootstraps/$(shell basename $(RELEASE))/
TARGET_RELEASE = build/bootstrap-$(shell basename $(RELEASE))-$(FAB_ARCH).tar.gz

define bootstrap/post
	@echo;
	@echo "Tip: make release"
	@echo;
	@echo "Tip: copy generated bootstrap to bootstraps folder";
	@echo "     eg. rsync --delete -Hac -v $O/bootstrap/ $(TARGET_RSYNC)"
endef

release: bootstrap.tar.gz
	ln $O/bootstrap.tar.gz $(TARGET_RELEASE)
	BT_CONFIG=$(BT)/config $(BT)/bin/generate-signature $(TARGET_RELEASE)


FAB_SHARE_PATH ?= /usr/share/fab
include $(FAB_SHARE_PATH)/bootstrap.mk
