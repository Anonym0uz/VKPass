ARCHS = armv7 arm64
TARGET_IPHONEOS_DEPLOYMENT_VERSION=7.0
export THEOS_DEVICE_IP=192.168.0.103
include theos/makefiles/common.mk
GO_EASY_ON_ME = 1
export SDKVERSION=11.2

BUNDLE_NAME = VKPassPrefs
VKPassPrefs_FILES = VKPassPrefs.mm \
VKPrefsPasscode.mm \
UIAlertView+Sheet/UIAlertView+Blocks.m \
$(shell find Passcode -name '*.m') \
$(shell find FBEncrypt -name '*.m') \
VKPassLP.m
VKPassPrefs_INSTALL_PATH = /Library/PreferenceBundles
VKPassPrefs_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation Security LocalAuthentication
VKPassPrefs_PRIVATE_FRAMEWORKS = Preferences Foundation Security CaptiveNetwork SystemConfiguration MobileWiFi
ADDITIONAL_OBJCFLAGS = -Wno-error

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/VKPassPrefs.plist$(ECHO_END)
