#import "CertUtils.h"

@implementation CertUtils
+ (NSDictionary *)provisioningProfileAtPath:(NSString *)path {
	NSError *err;
	NSString *stringContent = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&err];
	stringContent = [stringContent componentsSeparatedByString:@"<plist version=\"1.0\">"][1];
	stringContent = [NSString stringWithFormat:@"%@%@", @"<plist version=\"1.0\">", stringContent];
	stringContent = [stringContent componentsSeparatedByString:@"</plist>"][0];
	stringContent = [NSString stringWithFormat:@"%@%@", stringContent, @"</plist>"];
	
	NSData *stringData = [stringContent dataUsingEncoding:NSASCIIStringEncoding];
	
	NSError *error;
	NSPropertyListFormat format;
	
	id plist;
	
	plist = [NSPropertyListSerialization propertyListWithData:stringData options:/*unused*/0 format:&format error:&error];
	if (!plist)NSLog(@"%@", error);
	
	return plist;
}
@end