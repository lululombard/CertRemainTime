#import "RootViewController.h"

@implementation RootViewController {
	UIWindow *window;
	UILabel *label1; // Title
	UILabel *label2; // by blabla
	UILabel *label3; // State (remaining)
	UILabel *label4; // AppID
	UILabel *label5; // Expiration date
	UILabel *label6; // Installation date
	UILabel *label7; // TTL
	UILabel *footer;

	UIView *topSpace;
	UIView *bottomSpace;
}

- (instancetype)initWithWindow:(UIWindow *)parent {
	self = [super init];
	window = parent;
	return self;
}

- (NSString *)humanLocalizedDate:(NSDate *)date displayFormat:(NSString *)format {
	NSString *toReturn;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
	NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
	date = [date dateByAddingTimeInterval:timeZoneSeconds];
	[dateFormat setDateFormat:format];
	toReturn = [dateFormat stringFromDate:date];
	return toReturn;
}

- (void)loadView {
	NSFileManager *filemgr;
	NSString *defFormat = @"yyyy-MM-dd 'at' HH:mm";
	NSString *appId = @"-1";
	NSDate *now = [NSDate date];
	NSString *ttlDays;
	NSDate *expireDate;
	NSDate *createDate;
	//UIProgressView *progressView;

	filemgr = [[NSFileManager alloc] init];
	[filemgr changeCurrentDirectoryPath:@"/var/MobileDevice/ProvisioningProfiles/"];

	NSArray *dirContents = [filemgr contentsOfDirectoryAtPath:[filemgr currentDirectoryPath] error:nil];

	NSLog(@"[CertRemainTime] Now browsing %@", [filemgr currentDirectoryPath]);

	for (NSString *fullFileName in dirContents) {
		if ([appId isEqual:@"-1"]) appId = @"-2";
		NSLog(@"[CertRemainTime] Reading plist file %@", fullFileName);
		NSError *err;
		NSString *stringContent = [NSString stringWithContentsOfFile:fullFileName encoding:NSASCIIStringEncoding error:&err];
		if (err > 0) {
			NSLog(@"[CertRemainTime] Err %@", err);
			continue;
		}
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
		if ([appIdName rangeOfString:@"CY- "].location != NSNotFound) appIdName = [appIdName componentsSeparatedByString:@"CY- "][1];
		appIdName = [appIdName lowercaseString];
		NSLog(@"[CertRemainTime] AppIDName = %@", appIdName);
		if ([stringContent rangeOfString:@"<key>ExpirationDate</key>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the ExpirationDate key");
			continue;
		}
		NSString *expireDateTemp = [stringContent componentsSeparatedByString:@"<key>ExpirationDate</key>\n"][1];
		if ([expireDateTemp rangeOfString:@"<date>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the ExpirationDate date begining");
			continue;
		}
		if ([expireDateTemp rangeOfString:@"</date>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the ExpirationDate date end");
			continue;
		}
		expireDateTemp = [expireDateTemp componentsSeparatedByString:@"<date>"][1];
		expireDateTemp = [expireDateTemp componentsSeparatedByString:@"</date>"][0];
		NSLog(@"[CertRemainTime] ExpirationDate = %@", expireDateTemp);

		if ([stringContent rangeOfString:@"<key>CreationDate</key>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the CreationDate key");
			continue;
		}
		NSString *creationDateTemp = [stringContent componentsSeparatedByString:@"<key>CreationDate</key>\n"][1];
		if ([creationDateTemp rangeOfString:@"<date>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the CreationDate date begining");
			continue;
		}
		if ([creationDateTemp rangeOfString:@"</date>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the CreationDate date end");
			continue;
		}
		creationDateTemp = [creationDateTemp componentsSeparatedByString:@"<date>"][1];
		creationDateTemp = [creationDateTemp componentsSeparatedByString:@"</date>"][0];
		NSLog(@"[CertRemainTime] CreationDate = %@", creationDateTemp);

		if ([stringContent rangeOfString:@"<key>TimeToLive</key>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the TimeToLive key");
			continue;
		}
		NSString *ttlTemp = [stringContent componentsSeparatedByString:@"<key>TimeToLive</key>\n"][1];
		if ([ttlTemp rangeOfString:@"<integer>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the TimeToLive integer begining");
			continue;
		}
		if ([ttlTemp rangeOfString:@"</integer>"].location == NSNotFound) {
			NSLog(@"[CertRemainTime] Cannot find the TimeToLive integer end");
			continue;
		}
		ttlTemp = [ttlTemp componentsSeparatedByString:@"<integer>"][1];
		ttlTemp = [ttlTemp componentsSeparatedByString:@"</integer>"][0];
		NSLog(@"[CertRemainTime] TimeToLive = %@", ttlTemp);


		if ([appIdName rangeOfString:@"yalu"].location != NSNotFound ||  
			([appIdName rangeOfString:@"mach"].location != NSNotFound && [appIdName rangeOfString:@"portal"].location != NSNotFound) || 
			([appIdName rangeOfString:@"home"].location != NSNotFound && [appIdName rangeOfString:@"depot"].location != NSNotFound))
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
			[dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
			NSDate *expireNSDateTemp = [dateFormat dateFromString:expireDateTemp];
			NSDate *createNSDateTemp = [dateFormat dateFromString:creationDateTemp];
			if (expireDate <= 0 || [expireNSDateTemp compare:expireDate] == NSOrderedDescending) {
				appId = appIdName;
				ttlDays = ttlTemp;
				expireDate = expireNSDateTemp;
				createDate = createNSDateTemp;
			}
		}
	}

	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[[self view] setBackgroundColor:[UIColor whiteColor]];

	/* Label */
	label1 = [[UILabel alloc] init];
	label1.font = [UIFont boldSystemFontOfSize: 45.0f];
	label1.textColor = [UIColor blackColor];
	label1.backgroundColor = [UIColor clearColor];
	label1.textAlignment = NSTextAlignmentCenter;
	[label1 setText:@"Cert Time"];
	[label1 sizeToFit];
	label1.translatesAutoresizingMaskIntoConstraints = NO;
	[label1 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label1];

	label2 = [[UILabel alloc] init];
	label2.font = [UIFont boldSystemFontOfSize: 15.0f];
	label2.textColor = [UIColor blackColor];
	label2.backgroundColor = [UIColor clearColor];
	label2.textAlignment = NSTextAlignmentCenter;
	[label2 setText:@"by @lululombard"];
	[label2 sizeToFit];
	label2.translatesAutoresizingMaskIntoConstraints = NO;
	[label2 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label2];

	label3 = [[UILabel alloc] init];
	label3.font = [UIFont boldSystemFontOfSize: 20.0f];
	label3.textColor = [UIColor blackColor];
	label3.backgroundColor = [UIColor clearColor];
	label3.textAlignment = NSTextAlignmentCenter;
	if ([expireDate isEqual:@"-1"]) [label3 setText:@"State : No cert found (expired ?)"];
	else if ([expireDate isEqual:@"-2"]) [label3 setText:@"State : No cert compatible (expired ?)"];
	else {
		NSTimeInterval secondsBetween;
		NSString *state;
		NSString *remaining = @"";
		if ([expireDate compare:now] == NSOrderedDescending) {
			secondsBetween = [expireDate timeIntervalSinceDate:now];
			state = @"Valid for";
		}
		else {
			secondsBetween = [now timeIntervalSinceDate:expireDate];
			state = @"Expired since";
		}
		int minutesBetween = secondsBetween / 60;
		int days = 0;
		int hours = 0;
		while (minutesBetween >= 1440) {
			minutesBetween -= 1440;
			days++;
		}
		while (minutesBetween >= 60) {
			minutesBetween -= 60;
			hours++;
		}
		if (days == 0 && hours == 0 && minutesBetween == 0) remaining = @"NOW !";
		else {
			if (days > 0) remaining = [remaining stringByAppendingString:[[NSString stringWithFormat:@"%i", days] stringByAppendingString:@" days"]];
			if (days < 10 && hours > 0) {
				if (![remaining isEqual:@""]) remaining = [remaining stringByAppendingString:(days == 0 && minutesBetween > 0) ? @", " : @" and "];
				remaining = [remaining stringByAppendingString:[[NSString stringWithFormat:@"%i", hours] stringByAppendingString:@" hours"]];
			}
			if (days == 0 && minutesBetween > 0) {
				if (![remaining isEqual:@""]) remaining = [remaining stringByAppendingString:@" and "];
				remaining = [remaining stringByAppendingString:[[NSString stringWithFormat:@"%i", minutesBetween] stringByAppendingString:@" minutes"]];
			}
		}
		[label3 setText:[[state stringByAppendingString:@" "] stringByAppendingString:remaining]];
	}
	
	[label3 sizeToFit];
	label3.translatesAutoresizingMaskIntoConstraints = NO;
	[label3 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label3];

	label4 = [[UILabel alloc] init];
	label4.font = [UIFont boldSystemFontOfSize: 15.0f];
	label4.textColor = [UIColor blackColor];
	label4.backgroundColor = [UIColor clearColor];
	label4.textAlignment = NSTextAlignmentCenter;
	if (![expireDate isEqual:@"-1"] && ! [expireDate isEqual:@"-2"]) [label4 setText:[@"Tool detected : " stringByAppendingString:appId]];
	[label4 sizeToFit];
	label4.translatesAutoresizingMaskIntoConstraints = NO;
	[label4 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label4];

	label5 = [[UILabel alloc] init];
	label5.font = [UIFont boldSystemFontOfSize: 15.0f];
	label5.textColor = [UIColor blackColor];
	label5.backgroundColor = [UIColor clearColor];
	label5.textAlignment = NSTextAlignmentCenter;
	NSString *expireDateString = [self humanLocalizedDate:expireDate displayFormat:defFormat];
	if (![expireDate isEqual:@"-1"] && ! [expireDate isEqual:@"-2"]) [label5 setText:[@"Expiration : " stringByAppendingString:expireDateString]];
	[label5 sizeToFit];
	label5.translatesAutoresizingMaskIntoConstraints = NO;
	[label5 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label5];

	label6 = [[UILabel alloc] init];
	label6.font = [UIFont boldSystemFontOfSize: 15.0f];
	label6.textColor = [UIColor blackColor];
	label6.backgroundColor = [UIColor clearColor];
	label6.textAlignment = NSTextAlignmentCenter;
	NSString *createDateString = [self humanLocalizedDate:createDate displayFormat:defFormat];
	if (![expireDate isEqual:@"-1"] && ! [expireDate isEqual:@"-2"]) [label6 setText:[@"Creation : " stringByAppendingString:createDateString]];
	[label6 sizeToFit];
	label6.translatesAutoresizingMaskIntoConstraints = NO;
	[label6 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label6];

	label7 = [[UILabel alloc] init];
	label7.font = [UIFont boldSystemFontOfSize: 15.0f];
	label7.textColor = [UIColor blackColor];
	label7.backgroundColor = [UIColor clearColor];
	label7.textAlignment = NSTextAlignmentCenter;
	if (![expireDate isEqual:@"-1"] && ! [expireDate isEqual:@"-2"]) [label7 setText:[@"Certificate duration : " stringByAppendingString:[ttlDays stringByAppendingString:@" days"]]];
	[label7 sizeToFit];
	label7.translatesAutoresizingMaskIntoConstraints = NO;
	[label7 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label7];

	footer = [[UILabel alloc] init];
	footer.font = [UIFont boldSystemFontOfSize: 10.0f];
	footer.textColor = [UIColor blackColor];
	footer.backgroundColor = [UIColor clearColor];
	footer.textAlignment = NSTextAlignmentCenter;
	[footer setText:@"Any issues ? contact@lululombard.fr"];
	[footer sizeToFit];
	footer.translatesAutoresizingMaskIntoConstraints = NO;
	[footer setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:footer];

	/* Spaces */
	topSpace = [[UIView alloc] init];
	bottomSpace = [[UIView alloc] init];
	topSpace.translatesAutoresizingMaskIntoConstraints = NO;
	bottomSpace.translatesAutoresizingMaskIntoConstraints = NO;
	[[self view] addSubview:topSpace];
	[[self view] addSubview:bottomSpace];

	/* Constraints */
	NSDictionary *viewDict = NSDictionaryOfVariableBindings(label1, label2, label3, label4, label5, label6, label7, footer, topSpace, bottomSpace);

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

	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label3
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label4
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label5
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label6
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label7
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:footer
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	[self.view addConstraints: [NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-50-[label1]-10-[label2][topSpace(==bottomSpace)]-[label3]-100-[label4]-[label5]-[label6]-[label7][bottomSpace][footer]-10-|"
		options:0
		metrics:nil
		views:viewDict
	]];
}

@end