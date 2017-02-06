#import "certremaintimeApplication.h"

@implementation certremaintimeApplication {
	UIWindow *window;
	RootViewController *control;
}

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	control = [[RootViewController alloc] initWithWindow:window];
    window.rootViewController = control;
	[window makeKeyAndVisible];
}

@end