#import "helloworldApplication.h"

@implementation helloworldApplication {
	UIWindow *window;
	RootViewController *control;
}

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	control = [[RootViewController alloc] initWithWindow:window];
    window.rootViewController = control;
	[window makeKeyAndVisible];

	[[UIScreen mainScreen] setBrightness:0.2f];
		// NOTE: set brightness.
		// NOTE: springboard does not reset brightness... fuck the manual
		// NOTE: should set brightness everytime the app is resumed
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
		// NOTE: prevent the device from sleeping/suspending
}

@end
// vim:ft=objc
