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
    
    NSString *error;
    NSPropertyListFormat format;
    
    id plist;
    
    plist = [NSPropertyListSerialization propertyListFromData:stringData
                                             mutabilityOption:NSPropertyListImmutable
                                                       format:&format
                                             errorDescription:&error];
    if(!plist){
        NSLog(@"%@", error);
    }
    
    return plist;
}
@end
