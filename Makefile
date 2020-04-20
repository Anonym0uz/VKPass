ARCHS =  arm64 armv7s
# TARGET_IPHONEOS_DEPLOYMENT_VERSION=7.0
export THEOS_DEVICE_IP=192.168.0.142
#export THEOS_DEVICE_IP=192.168.0.105
TARGET = iphone:latest:7.0
include theos/makefiles/common.mk
GO_EASY_ON_ME = 1
export SDKVERSION=10.3

TWEAK_NAME = VKPass
VKPass_FILES = Tweak.xm \
$(shell find FBEncrypt -name '*.m') \
$(shell find Passcode -name '*.m') \
VKPrefsPasscode.mm \
UIAlertView+Sheet/UIAlertView+Blocks.m \
VKPass.m \
VPBiometricAuthenticationFacade.m \
vkpassprefs/VKPassPrefs.mm \
vkpassprefs/VKPassLP.m
VKPass_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation Security LocalAuthentication
VKPass_PRIVATE_FRAMEWORKS = Preferences Foundation Security LocalAuthentication CaptiveNetwork SystemConfiguration MobileWiFi
ADDITIONAL_OBJCFLAGS = -Wno-error
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 VKClient"
SUBPROJECTS += vkpassprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
