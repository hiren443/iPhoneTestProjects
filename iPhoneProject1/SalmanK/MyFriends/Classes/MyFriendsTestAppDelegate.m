
/* M Salman Kahlid --Copy righted- certified-
 DO not reuse
 */
#import "MyFriendsTestAppDelegate.h"
#import "MyFriendsTestViewController.h"

@implementation MyFriendsTestAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
	window.rootViewController= navigationController;
  //  [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
