#import "RootViewController.h"

@implementation RootViewController {
	UIWindow *window;
	UILabel *label;
	UIButton *btnColor;
	UIButton *btnText;

	UIView *topSpace;
	UIView *bottomSpace;

	int coloridx;
	int textidx;
}

- (instancetype)initWithWindow:(UIWindow *)parent {
	self = [super init];
	window = parent;
	coloridx = -1;
	textidx = -1;
	return self;
}

- (void)changeColor {
	coloridx = (coloridx + 1) % 3;

	UIColor *color;
	switch(coloridx) {
		case 0: color = [UIColor whiteColor]; break;
		case 1: color = [UIColor yellowColor]; break;
		case 2: color = [UIColor orangeColor]; break;
	}

	[[self view] setBackgroundColor:color];
}

- (void)changeText {
	textidx = (textidx + 1) % 3;

	NSString *str;
	switch(textidx) {
		case 0: str = @"Hell World"; break;
		case 1: str = @"No typo here!"; break;
		case 2: str = @"Jailbreak FTW"; break;
	}

	[label setText:str];
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];

	/* Label */
	label = [[UILabel alloc] init]; //initWithFrame: [[UIScreen mainScreen] bounds]];
	label.font = [UIFont boldSystemFontOfSize: 45.0f];
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;

	[label sizeToFit];
		// NOTE: automatically resize to fit subviews
	label.translatesAutoresizingMaskIntoConstraints = NO;
		// NOTE: ^ need this to use constraint-based layout
	[label setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		// TODO: recheck this... What does this do under CBL?

	[[self view] addSubview:label];

	/* "Change Color" button */
	btnColor = [UIButton buttonWithType:UIButtonTypeSystem];
	[btnColor setTitle: @"Change Color" forState:UIControlStateNormal];
	[btnColor sizeToFit];

	[btnColor addTarget:self action:@selector(changeColor)
	   forControlEvents:UIControlEventTouchUpInside];

	btnColor.translatesAutoresizingMaskIntoConstraints = NO;

	[[self view] addSubview:btnColor];

	/* "Change Text" button */
	btnText = [UIButton buttonWithType:UIButtonTypeSystem];
	[btnText setTitle: @"Change Text" forState:UIControlStateNormal];
	[btnText sizeToFit];

	[btnText addTarget:self action:@selector(changeText)
	  forControlEvents:UIControlEventTouchUpInside];

	btnText.translatesAutoresizingMaskIntoConstraints = NO;

	[[self view] addSubview:btnText];

	/* Spaces */
	topSpace = [[UIView alloc] init];
	bottomSpace = [[UIView alloc] init];
	topSpace.translatesAutoresizingMaskIntoConstraints = NO;
	bottomSpace.translatesAutoresizingMaskIntoConstraints = NO;
	[[self view] addSubview:topSpace];
	[[self view] addSubview:bottomSpace];

	/* Constraints */
	NSDictionary *viewDict = NSDictionaryOfVariableBindings(label, btnColor,
			btnText, topSpace, bottomSpace);

	[self.view addConstraint:
		[NSLayoutConstraint constraintWithItem:label
									 attribute:NSLayoutAttributeCenterX
									 relatedBy:NSLayoutRelationEqual
										toItem:self.view
									 attribute:NSLayoutAttributeCenterX
									multiplier:1
									  constant:0]];
	[self.view addConstraint:
		[NSLayoutConstraint constraintWithItem:btnColor
									 attribute:NSLayoutAttributeCenterX
									 relatedBy:NSLayoutRelationEqual
										toItem:self.view
									 attribute:NSLayoutAttributeCenterX
									multiplier:1
									  constant:0]];

	[self.view addConstraint:
		[NSLayoutConstraint constraintWithItem:btnText
									 attribute:NSLayoutAttributeCenterX
									 relatedBy:NSLayoutRelationEqual
										toItem:self.view
									 attribute:NSLayoutAttributeCenterX
									multiplier:1
									  constant:0]];

	[self.view addConstraints:
		[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|-[topSpace(==bottomSpace)][label]-50-[btnColor]-20-[btnText][bottomSpace]-|"
								options:0
								metrics:nil
								  views:viewDict]];
	
	/* Initialize */
	[self changeColor];
	[self changeText];
}

@end
// vim:ft=objc
