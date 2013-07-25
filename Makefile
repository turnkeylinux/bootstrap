ifndef RELEASE
$(error RELEASE not defined, e.g., debian/wheezy)
endif

define bootstrap/post
	@echo "Tip: copy generated bootstrap to bootstraps folder";
	@echo "     eg. rsync --delete -Hac -v $O/bootstrap/ $(FAB_PATH)/bootstraps/$(shell basename $(RELEASE))/"
endef

FAB_SHARE_PATH ?= /usr/share/fab
include $(FAB_SHARE_PATH)/bootstrap.mk
