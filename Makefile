export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.4:13.0
export SYSROOT = $(THEOS)/sdks/iOS/14/iPhoneOS14.4.sdk
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

SUBPROJECTS += Tweak Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
