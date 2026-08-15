TARGET := iphone:clang:16.5:15.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardRounded
KeyboardRounded_FILES = Tweak.xm
KeyboardRounded_CFLAGS = -fobjc-arc
KeyboardRounded_FRAMEWORKS = UIKit QuartzCore

BUNDLE_NAME = KeyboardRoundedPrefs
KeyboardRoundedPrefs_FILES = KeyboardRoundedPrefs/KRRootListController.m
KeyboardRoundedPrefs_FRAMEWORKS = UIKit
KeyboardRoundedPrefs_PRIVATE_FRAMEWORKS = Preferences
KeyboardRoundedPrefs_CFLAGS = -fobjc-arc
KeyboardRoundedPrefs_INSTALL_PATH = /Library/PreferenceBundles
KeyboardRoundedPrefs_RESOURCE_DIRS = KeyboardRoundedPrefs/Resources
KeyboardRoundedPrefs_PLIST = KeyboardRoundedPrefs/Info.plist

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
