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

	filemgr = [[NSFileManager alloc] init];
	[filemgr changeCurrentDirectoryPath:@"/var/MobileDevice/ProvisioningProfiles/"];

	NSArray *dirContents = [filemgr contentsOfDirectoryAtPath:[filemgr currentDirectoryPath] error:nil];

	NSLog(@"CertRemainTime : %@", [filemgr currentDirectoryPath]);

	for (NSString *fullFileName in dirContents) {
		expireDate = @"-2";
		NSLog(@"CertRemainTime : %@", fullFileName);
		NSError *err;
		NSString *stringContent = [NSString stringWithContentsOfFile:fullFileName encoding:NSASCIIStringEncoding error:&err];
		if ([stringContent rangeOfString:@"yalu102"].location != NSNotFound || [stringContent rangeOfString:@"CY- mach portal"].location != NSNotFound) {
			expireDate = @"-2";
			if ([stringContent rangeOfString:@"ExpirationDate</key>\n"].location == NSNotFound) {
				expireDate = @"-3";
			}
			else {
				expireDate = [stringContent componentsSeparatedByString:@"ExpirationDate</key>\n"][1];
				expireDate = [expireDate componentsSeparatedByString:@"<date>"][1];
				expireDate = [expireDate componentsSeparatedByString:@"</date>"][0];
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
				[dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
				NSDate *date = [dateFormat dateFromString:expireDate];
				NSLog(@"CertRemainTime : %@", date);
				[dateFormat setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
				expireDate = [dateFormat stringFromDate:date];
				break;
			}
		}
		NSLog(@"CertRemainTime : %@", stringContent);
		NSLog(@"CertRemainTime : %@", err);
	}

	NSLog(@"CertRemainTime : %@", expireDate);

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
	else [label1 setText:@"yalu will expire"];
	[label1 sizeToFit];
	label1.translatesAutoresizingMaskIntoConstraints = NO;
	[label1 setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self view] addSubview:label1];

	label2 = [[UILabel alloc] init];
	label2.font = [UIFont boldSystemFontOfSize: 15.0f];
	label2.textColor = [UIColor blackColor];
	label2.backgroundColor = [UIColor clearColor];
	label2.textAlignment = NSTextAlignmentCenter;
	if ([expireDate isEqual:@"-1"]) [label1 setText:@"(really, no cert at all)"];
	else if ([expireDate isEqual:@"-2"]) [label2 setText:@"gave info about yalu"];
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
