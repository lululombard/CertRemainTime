include theos/makefiles/common.mk

ARCH = arm64-apple-ios7.0
APPLICATION_NAME = helloworld
helloworld_FILES = main.m helloworldApplication.mm RootViewController.mm
helloworld_FRAMEWORKS = UIKit CoreGraphics

ADDITIONAL_OBJCFLAGS = -fobjc-arc

BIN_ROOT = ../sdk/usr/bin
TARGET_LD = $(BIN_ROOT)/ld -arch arm64

include $(THEOS_MAKE_PATH)/application.mk
