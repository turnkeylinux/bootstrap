RELEASE ?= debian/wheezy

define bootstrap/post
	@echo;
	@echo "Reminder: copy generated bootstrap to bootstraps folder";
	@echo "          eg. rsync --delete -Hac -v $O/bootstrap/ $(FAB_PATH)/bootstraps/$(shell basename $(RELEASE))-$(FAB_ARCH)/"
endef

FAB_SHARE_PATH ?= /usr/share/fab
include $(FAB_SHARE_PATH)/bootstrap.mk
