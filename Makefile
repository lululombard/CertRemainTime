include $(THEOS)/makefiles/common.mk

ARCH = arm64-apple-ios7.0
APPLICATION_NAME = CertRemainTime
CertRemainTime_FILES = main.m certremaintimeApplication.mm RootViewController.mm
CertRemainTime_FRAMEWORKS = UIKit CoreGraphics

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
