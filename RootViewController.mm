#import "RootViewController.h"

@implementation RootViewController {
	UIWindow *window;
	UILabel *label1;
	UILabel *label2;

	UIView *topSpace;
	UIView *bottomSpace;
}

- (instancetype)initWithWindow:(UIWindow *)parent {
	self = [super init];
	window = parent;
	return self;
}

- (void)loadView {
	NSFileManager *filemgr;
	NSString *expireDate = @"-1";
	NSDate *date;

	filemgr = [[NSFileManager alloc] init];
	[filemgr changeCurrentDirectoryPath:@"/var/MobileDevice/ProvisioningProfiles/"];

	NSArray *dirContents = [filemgr contentsOfDirectoryAtPath:[filemgr currentDirectoryPath] error:nil];

	NSLog(@"[CertRemainTime] Now browsing %@", [filemgr currentDirectoryPath]);

	for (NSString *fullFileName in dirContents) {
		if ([expireDate isEqual:@"-1"]) expireDate = @"-2";
		NSLog(@"[CertRemainTime] Reading plist file %@", fullFileName);
		NSError *err;
		NSString *stringContent = [NSString stringWithContentsOfFile:fullFileName encoding:NSASCIIStringEncoding error:&err];
		if (err > 0) NSLog(@"[CertRemainTime] Err %@", err);
		if ([stringContent rangeOfString:@"<plist version=\"1.0\">"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the start of the plist file");
			continue;
		}
		if ([stringContent rangeOfString:@"</plist>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the end of the plist file");
			continue;
		}
		stringContent = [stringContent componentsSeparatedByString:@"<plist version=\"1.0\">"][1];
		stringContent = [stringContent componentsSeparatedByString:@"</plist>"][0];
		if ([stringContent rangeOfString:@"<key>AppIDName</key>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the AppIDName key");
			continue;
		}
		if ([stringContent rangeOfString:@"<string>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the AppIDName string begining");
			continue;
		}
		if ([stringContent rangeOfString:@"</string>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the AppIDName string end");
			continue;
		}
		NSString *appIdName = [stringContent componentsSeparatedByString:@"<key>AppIDName</key>"][1];
		appIdName = [appIdName componentsSeparatedByString:@"<string>"][1];
		appIdName = [appIdName componentsSeparatedByString:@"</string>"][0];
		NSLog(@"[CertRemainTime] AppIDName = %@", appIdName);
		if ([stringContent rangeOfString:@"<key>ExpirationDate</key>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the ExpirationDate key");
			continue;
		}
		if ([stringContent rangeOfString:@"<date>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the ExpirationDate date begining");
			continue;
		}
		if ([stringContent rangeOfString:@"</date>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the ExpirationDate date end");
			continue;
		}
		NSString *expireDateTemp = [stringContent componentsSeparatedByString:@"<key>ExpirationDate</key>\n"][1];
		expireDateTemp = [expireDateTemp componentsSeparatedByString:@"<date>"][1];
		expireDateTemp = [expireDateTemp componentsSeparatedByString:@"</date>"][0];
		NSLog(@"[CertRemainTime] ExpirationDate = %@", expireDateTemp);

		if ([appIdName rangeOfString:@"yalu"].location != NSNotFound || 
			[appIdName rangeOfString:@"mach_portal"].location != NSNotFound || 
			[appIdName rangeOfString:@"mach-portal"].location != NSNotFound || 
			[appIdName rangeOfString:@"machportal"].location != NSNotFound || 
			[appIdName rangeOfString:@"mach portal"].location != NSNotFound || 
			[appIdName rangeOfString:@"home depot"].location != NSNotFound || 
			[appIdName rangeOfString:@"homedepot"].location != NSNotFound || 
			[appIdName rangeOfString:@"home_depot"].location != NSNotFound || 
			[appIdName rangeOfString:@"home-depot"].location != NSNotFound || 
			[appIdName rangeOfString:@"Home Depot"].location != NSNotFound)
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
			[dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
			NSDate *dateTemp = [dateFormat dateFromString:expireDateTemp];
			if (date <= 0 || [dateTemp compare:date] == NSOrderedDescending) {
				date = dateTemp;
				NSLog(@"[CertRemainTime] New date ! %@", date);
			}
		}
	}

	if (date > 0) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
		NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
		date = [date dateByAddingTimeInterval:timeZoneSeconds];
		[dateFormat setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
		expireDate = [dateFormat stringFromDate:date];
	}

	NSLog(@"[CertRemainTime] Final date %@", date);
	NSLog(@"[CertRemainTime] Human readable date %@", expireDate);

	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[[self view] setBackgroundColor:[UIColor whiteColor]];

	/* Label */
	label1 = [[UILabel alloc] init];
	label1.font = [UIFont boldSystemFontOfSize: 45.0f];
	label1.textColor = [UIColor blackColor];
	label1.backgroundColor = [UIColor clearColor];
	label1.textAlignment = NSTextAlignmentCenter;
	if ([expireDate isEqual:@"-1"]) [label1 setText:@"no cert found"];
	else if ([expireDate isEqual:@"-2"]) [label1 setText:@"no cert"];
	else [label1 setText:@"jb will expire on"];
	[label1 sizeToFit];
	label1.translatesAutoresizingMaskIntoConstraints = NO;
	[label1 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label1];

	label2 = [[UILabel alloc] init];
	label2.font = [UIFont boldSystemFontOfSize: 15.0f];
	label2.textColor = [UIColor blackColor];
	label2.backgroundColor = [UIColor clearColor];
	label2.textAlignment = NSTextAlignmentCenter;
	if ([expireDate isEqual:@"-1"]) [label2 setText:@"(really, no cert at all)"];
	else if ([expireDate isEqual:@"-2"]) [label2 setText:@"gave info about your jb"];
	else [label2 setText:expireDate];
	[label2 sizeToFit];
	label2.translatesAutoresizingMaskIntoConstraints = NO;
	[label2 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label2];

	/* Spaces */
	topSpace = [[UIView alloc] init];
	bottomSpace = [[UIView alloc] init];
	topSpace.translatesAutoresizingMaskIntoConstraints = NO;
	bottomSpace.translatesAutoresizingMaskIntoConstraints = NO;
	[[self view] addSubview:topSpace];
	[[self view] addSubview:bottomSpace];

	/* Constraints */
	NSDictionary *viewDict = NSDictionaryOfVariableBindings(label1, label2, topSpace, bottomSpace);

	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label1
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label2
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	[self.view addConstraints: [NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-[topSpace(==bottomSpace)][label1]-50-[label2][bottomSpace]-|"
		options:0
		metrics:nil
		views:viewDict
	]];
}

@end