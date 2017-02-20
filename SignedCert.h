#import <Foundation/Foundation.h>

@interface SignedCert : NSObject

@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *ttlDays;
@property (nonatomic) NSDate *expireDate;
@property (nonatomic) NSDate *createDate;

- (id)init: (NSDictionary*) plist;

@end
