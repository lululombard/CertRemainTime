#import <Foundation/Foundation.h>
#import "SignedCert.h"

@implementation SignedCert : NSObject
- (id)init: (NSDictionary*) plist {
	self = [super init];
	if (self) {
		_appId = plist[@"AppIDName"];
		NSLog(@"[CertRemainTime] 1:_appId = %@", _appId);
		if ([_appId rangeOfString:@"CY- "].location != NSNotFound) { // Cydia impactor/Ext3nder/ReProvision
			_appId = [_appId componentsSeparatedByString:@"CY- "][1];
			NSLog(@"[CertRemainTime] CY:_appId = %@", _appId);
		}
		if ([_appId rangeOfString:@"XC- "].location != NSNotFound) {
			_appId = [_appId componentsSeparatedByString:@"XC- "][1]; // Xcode
			NSLog(@"[CertRemainTime] XC:_appId = %@", _appId);
		}
		if ([_appId rangeOfString:@"KYESoundsAPP"].location != NSNotFound) { 
			_appId = @"tweakbox"; // TweakBox - 13/3/2019
			NSLog(@"[CertRemainTime] KYESoundsAPP:_appId = %@", _appId);
		}
		_appId = [_appId lowercaseString];
		_ttlDays = [plist[@"TimeToLive"] stringValue];
		_expireDate = [plist objectForKey:@"ExpirationDate"];
		_createDate = [plist objectForKey:@"CreationDate"];
	}
	return self;
}
@end
