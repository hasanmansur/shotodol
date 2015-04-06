
include $(MODULE_DEPTH)/build/.config.mk
DIST_DIR=$(SHOTODOL_HOME)/dist

dist:
	mkdir -p $(DIST_DIR)/$(AROOP_MODULE_NAME)
	cp -rf include vapi $(DIST_DIR)/$(AROOP_MODULE_NAME)/
	if [ -e dynalib.so ] ; then \
		cp -f dynalib.so $(DIST_DIR)/$(AROOP_MODULE_NAME)/ ; \
	fi


