#import "RootViewController.h"
#import "SignedCert.h"
#import "CertUtils.h"

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
	[dateFormat setDateFormat:format];
	toReturn = [dateFormat stringFromDate:date];
	return toReturn;
}

- (void)loadView {
	int errCode = 1;
	NSFileManager *filemgr;
	SignedCert *usingCert;
	NSDate *now = [NSDate date];
	NSString *defFormat = @"yyyy-MM-dd 'at' HH:mm";

	//

	filemgr = [[NSFileManager alloc] init];
	[filemgr changeCurrentDirectoryPath:@"/var/MobileDevice/ProvisioningProfiles/"];

	NSArray *dirContents = [filemgr contentsOfDirectoryAtPath:[filemgr currentDirectoryPath] error:nil];

	NSLog(@"[CertRemainTime] Now browsing %@", [filemgr currentDirectoryPath]);

	for (NSString *fullFileName in dirContents) {
		if (errCode == 1) errCode = 2;
		SignedCert *cert = [[SignedCert alloc] init:[CertUtils provisioningProfileAtPath:fullFileName]];

		if ([cert.appId rangeOfString:@"jailbreak"].location != NSNotFound || 
			[cert.appId rangeOfString:@"yalu"].location != NSNotFound || 
			[cert.appId rangeOfString:@"pangu"].location != NSNotFound || 
			([cert.appId rangeOfString:@"mach"].location != NSNotFound && [cert.appId rangeOfString:@"portal"].location != NSNotFound) ||
			([cert.appId rangeOfString:@"extra"].location != NSNotFound && [cert.appId rangeOfString:@"recipe"].location != NSNotFound) ||
			([cert.appId rangeOfString:@"ph"].location != NSNotFound && [cert.appId rangeOfString:@"nix"].location != NSNotFound) ||
			([cert.appId rangeOfString:@"home"].location != NSNotFound && [cert.appId rangeOfString:@"depot"].location != NSNotFound) ||
			[cert.appId rangeOfString:@"saigon"].location != NSNotFound ||
			[cert.appId rangeOfString:@"g0blin"].location != NSNotFound ||
			[cert.appId rangeOfString:@"h3lix"].location != NSNotFound ||
			[cert.appId rangeOfString:@"electra"].location != NSNotFound ||
			[cert.appId rangeOfString:@"liberios"].location != NSNotFound)
		{
			if (!usingCert || [cert.expireDate compare:usingCert.expireDate] == NSOrderedDescending) {
				usingCert = cert;
			}
		}
	}

	if (usingCert != NULL) errCode = 0;

	if (errCode < 0 && usingCert.expireDate != NULL) errCode = 3;

	NSLog(@"[CertRemainTime] errCode = %@", [NSString stringWithFormat:@"%i", errCode]);
	NSLog(@"[CertRemainTime] defFormat = %@", defFormat);
	NSLog(@"[CertRemainTime] appId = %@", usingCert.appId);
	NSLog(@"[CertRemainTime] now = %@", now);
	NSLog(@"[CertRemainTime] ttlDays = %@", usingCert.ttlDays);
	NSLog(@"[CertRemainTime] expireDate = %@", usingCert.expireDate);
	NSLog(@"[CertRemainTime] createDate = %@", usingCert.createDate);

	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[[self view] setBackgroundColor:[UIColor whiteColor]];

	/* Label */
	NSLog(@"[CertRemainTime] Drawing label 1");
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

	NSLog(@"[CertRemainTime] Drawing label 2");
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

	NSLog(@"[CertRemainTime] Drawing label 3");
	label3 = [[UILabel alloc] init];
	label3.font = [UIFont boldSystemFontOfSize: 20.0f];
	label3.textColor = [UIColor blackColor];
	label3.backgroundColor = [UIColor clearColor];
	label3.textAlignment = NSTextAlignmentCenter;
	if (errCode == 1) [label3 setText:@"State : No certificate found"];
	else if (errCode == 2) [label3 setText:@"State : No certificate compatible"];
	else if (errCode == 3) [label3 setText:@"State : Location error"];
	else {
		NSTimeInterval secondsBetween;
		NSString *state;
		NSString *remaining = @"";
		if ([usingCert.expireDate compare:now] == NSOrderedDescending) {
			secondsBetween = [usingCert.expireDate timeIntervalSinceDate:now];
			state = @"Valid for";
		}
		else {
			secondsBetween = [now timeIntervalSinceDate:usingCert.expireDate];
			state = @"Expired since";
		}
		NSLog(@"[CertRemainTime] State = %@", state);
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
		NSString *daysString = [NSString stringWithFormat:@"%i", days];
		NSString *hoursString = [NSString stringWithFormat:@"%i", hours];
		NSString *minutesString = [NSString stringWithFormat:@"%i", minutesBetween];
		NSLog(@"[CertRemainTime] days = %@", daysString);
		NSLog(@"[CertRemainTime] hours = %@", hoursString);
		NSLog(@"[CertRemainTime] minutes = %@", minutesString);
		if (days == 0 && hours == 0 && minutesBetween == 0) remaining = @"NOW !";
		else {
			if (days > 0) {
				NSLog(@"[CertRemainTime] days > 0 = YES");
				remaining = [remaining stringByAppendingString:[daysString stringByAppendingString:(days == 1 ? @" day" : @" days")]];
			}
			if (days < 10 && hours > 0) {
				NSLog(@"[CertRemainTime] days < 10 && hours > 0 = YES");
				if (![remaining isEqual:@""]) remaining = [remaining stringByAppendingString:(days == 0 && minutesBetween > 0) ? @", " : @" and "];
				remaining = [remaining stringByAppendingString:[hoursString stringByAppendingString:(hours == 1 ? @" hour" : @" hours")]];
			}
			if (days == 0 && minutesBetween > 0) {
				NSLog(@"[CertRemainTime] days == 0 && minutesBetween > 0 = YES");
				if (![remaining isEqual:@""]) remaining = [remaining stringByAppendingString:@" and "];
				remaining = [remaining stringByAppendingString:[minutesString stringByAppendingString:(minutesBetween == 1 ? @" minute" : @" minutes")]];
			}
		}
		NSLog(@"[CertRemainTime] Remaining = %@", remaining);
		[label3 setText:[[state stringByAppendingString:@" "] stringByAppendingString:remaining]];
	}
	
	[label3 sizeToFit];
	label3.translatesAutoresizingMaskIntoConstraints = NO;
	[label3 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label3];

	NSLog(@"[CertRemainTime] Drawing label 4");
	label4 = [[UILabel alloc] init];
	label4.font = [UIFont boldSystemFontOfSize: 15.0f];
	label4.textColor = [UIColor blackColor];
	label4.backgroundColor = [UIColor clearColor];
	label4.textAlignment = NSTextAlignmentCenter;
	if (errCode == 1 || errCode == 2) [label4 setText:@"Possible issues :"];
	else if (errCode == 3) [label4 setText:@"Please send a mail with these info :"];
	else [label4 setText:[@"Tool detected : " stringByAppendingString:usingCert.appId]];
	[label4 sizeToFit];
	label4.translatesAutoresizingMaskIntoConstraints = NO;
	[label4 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label4];

	NSLog(@"[CertRemainTime] Drawing label 5");
	label5 = [[UILabel alloc] init];
	label5.font = [UIFont boldSystemFontOfSize: 15.0f];
	label5.textColor = [UIColor blackColor];
	label5.backgroundColor = [UIColor clearColor];
	label5.textAlignment = NSTextAlignmentCenter;
	NSString *expireDateString = [self humanLocalizedDate:usingCert.expireDate displayFormat:defFormat];
	if (errCode == 1 || errCode == 2) [label5 setText:@"- Your cert is expired and was removed"];
	else if (errCode == 3) [label5 setText:@"- Language and region set"];
	else [label5 setText:[@"Expiration : " stringByAppendingString:expireDateString]];
	[label5 sizeToFit];
	label5.translatesAutoresizingMaskIntoConstraints = NO;
	[label5 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label5];

	NSLog(@"[CertRemainTime] Drawing label 6");
	label6 = [[UILabel alloc] init];
	label6.font = [UIFont boldSystemFontOfSize: 15.0f];
	label6.textColor = [UIColor blackColor];
	label6.backgroundColor = [UIColor clearColor];
	label6.textAlignment = NSTextAlignmentCenter;
	NSString *createDateString = [self humanLocalizedDate:usingCert.createDate displayFormat:defFormat];
	if (errCode == 1 || errCode == 2) [label6 setText:@"- You didn't use Cydia Impactor"];
	else if (errCode == 3) [label6 setText:@"- Hour display setting (12h/24h)"];
	else [label6 setText:[@"Creation : " stringByAppendingString:createDateString]];
	[label6 sizeToFit];
	label6.translatesAutoresizingMaskIntoConstraints = NO;
	[label6 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label6];

	NSLog(@"[CertRemainTime] Drawing label 7");
	label7 = [[UILabel alloc] init];
	label7.font = [UIFont boldSystemFontOfSize: 15.0f];
	label7.textColor = [UIColor blackColor];
	label7.backgroundColor = [UIColor clearColor];
	label7.textAlignment = NSTextAlignmentCenter;
	if (errCode == 1 || errCode == 2) [label7 setText:@"- Other ? contact@lululombard.fr"];
	else if (errCode == 3) [label7 setText:@"- Calendar used (Gregorian or other)"];
	else [label7 setText:[@"Certificate duration : " stringByAppendingString:[usingCert.ttlDays stringByAppendingString:@" days"]]];
	[label7 sizeToFit];
	label7.translatesAutoresizingMaskIntoConstraints = NO;
	[label7 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label7];

	NSLog(@"[CertRemainTime] Drawing label 8");
	footer = [[UILabel alloc] init];
	footer.font = [UIFont boldSystemFontOfSize: 10.0f];
	footer.textColor = [UIColor blackColor];
	footer.backgroundColor = [UIColor clearColor];
	footer.textAlignment = NSTextAlignmentCenter;
	if (errCode == 1 || errCode == 2) [footer setText:@"Send /var/MobileDevice/ProvisioningProfiles via mail"];
	else if (errCode == 3) [footer setText:@"contact@lululombard.fr"];
	else [footer setText:@"Any issues ? contact@lululombard.fr"];
	[footer sizeToFit];
	footer.translatesAutoresizingMaskIntoConstraints = NO;
	[footer setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:footer];

	/* Spaces */
	NSLog(@"[CertRemainTime] Defining spaces");
	topSpace = [[UIView alloc] init];
	bottomSpace = [[UIView alloc] init];
	topSpace.translatesAutoresizingMaskIntoConstraints = NO;
	bottomSpace.translatesAutoresizingMaskIntoConstraints = NO;
	[[self view] addSubview:topSpace];
	[[self view] addSubview:bottomSpace];

	/* Constraints */
	NSLog(@"[CertRemainTime] Defining Constraints");
	NSDictionary *viewDict = NSDictionaryOfVariableBindings(label1, label2, label3, label4, label5, label6, label7, footer, topSpace, bottomSpace);

	NSLog(@"[CertRemainTime] Defining constraint for label 1");
	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label1
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	NSLog(@"[CertRemainTime] Defining constraint for label 2");
	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label2
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	NSLog(@"[CertRemainTime] Defining constraint for label 3");
	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label3
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	NSLog(@"[CertRemainTime] Defining constraint for label 4");
	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label4
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	NSLog(@"[CertRemainTime] Defining constraint for label 5'");
	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label5
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	NSLog(@"[CertRemainTime] Defining constraint for label 6");
	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label6
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	NSLog(@"[CertRemainTime] Defining constraint for label 7");
	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:label7
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	NSLog(@"[CertRemainTime] Defining constraint for label 8");
	[self.view addConstraint: [NSLayoutConstraint 
		constraintWithItem:footer
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0
	]];

	NSLog(@"[CertRemainTime] Defining general look");
	[self.view addConstraints: [NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-50-[label1]-10-[label2][topSpace(==bottomSpace)]-[label3]-100-[label4]-[label5]-[label6]-[label7][bottomSpace][footer]-10-|"
		options:0
		metrics:nil
		views:viewDict
	]];
	NSLog(@"[CertRemainTime] Done !");
}

@end
