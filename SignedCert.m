#import <Foundation/Foundation.h>
#import "SignedCert.h"

@implementation SignedCert : NSObject
- (id)init: (NSDictionary*) plist {
	self = [super init];
	if (self) {
		_appId = plist[@"AppIDName"];
		if ([_appId rangeOfString:@"CY- "].location != NSNotFound) {
			_appId = [_appId componentsSeparatedByString:@"CY- "][1];
		}
		if ([_appId rangeOfString:@"XC- "].location != NSNotFound) {
			_appId = [_appId componentsSeparatedByString:@"XC- "][1];
		}
		_appId = [_appId lowercaseString];
		_ttlDays = [plist[@"TimeToLive"] stringValue];
		_expireDate = [plist objectForKey:@"ExpirationDate"];
		_createDate = [plist objectForKey:@"CreationDate"];
	}
	return self;
}
@end
