#import <Foundation/Foundation.h>
#import "SignedCert.h"

@implementation SignedCert : NSObject
- (id)init: (NSDictionary*) plist {
	self = [super init];
	if (self) {
		_appId = plist[@"AppIDName"];
		NSLog(@"[CertRemainTime] 1:_appId = %@", _appId);
		if ([_appId rangeOfString:@"CY- "].location != NSNotFound) { // Cydia impactor
			_appId = [_appId componentsSeparatedByString:@"CY- "][1];
			NSLog(@"[CertRemainTime] CY:_appId = %@", _appId);
		}
		if ([_appId rangeOfString:@"XC- "].location != NSNotFound) {
			_appId = [_appId componentsSeparatedByString:@"XC- "][1]; // Xcode
			NSLog(@"[CertRemainTime] XC:_appId = %@", _appId);
		}
		if ([_appId rangeOfString:@"dingshengapp"].location != NSNotFound) {
			_appId = @"Electra"; // TweakBox
			NSLog(@"[CertRemainTime] dingshengapp:_appId = %@", _appId);
			// If anyone can think of a better method than this, submit a PR with the relevant changes.
			// This method requires updating of Cert Time everytime a new enterprise account is used.
			// Perhaps I'll think of something better in the meantime.
			// - FaZe IlLuMiNaTi
		}
		_appId = [_appId lowercaseString];
		_ttlDays = [plist[@"TimeToLive"] stringValue];
		_expireDate = [plist objectForKey:@"ExpirationDate"];
		_createDate = [plist objectForKey:@"CreationDate"];
	}
	return self;
}
@end
