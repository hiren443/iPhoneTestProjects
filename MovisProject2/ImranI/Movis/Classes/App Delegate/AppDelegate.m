//
//  AppDelegate.m
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MovisViewController.h"
#import "DBHandler.h"
#import "Facebook.h"

@implementation AppDelegate

@synthesize m_facebook;
@synthesize act,nameVideo,select;
@synthesize window,viewController;

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    m_facebook = [[Facebook alloc] initWithAppId:@"214664188584044" andDelegate:self];
    [m_facebook setSessionDelegate:self];
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [DBHandler connectWithDB];
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    navigationController.navigationBarHidden = YES;
    return YES;
}
- (BOOL) application:(UIApplication*) application handleOpenURL:(NSURL *)url
{
	return [m_facebook handleOpenURL:url];
}

- (void) fbDidLogin
{
    NSLog(@"login");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[m_facebook accessToken] forKey:@"FBAccessTokenKey"]; // store the access token
    [defaults setObject:[m_facebook expirationDate] forKey:@"FBExpirationDateKey"];  // store the token's expiration date
    [defaults synchronize];
}

- (void) fbDidNotLogin:(BOOL)cancelled
{
    // do something with this information
}

- (void) fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"FBAccessTokenKey"];  // set the facebook token to nil as it's no longer valid
    [defaults setObject:nil forKey:@"FBExpirationDateKey"];  // same with expiration date
    [defaults synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (void)dealloc {
    //[viewController release];
    [window release];
    [super dealloc];
}


#pragma mark -
#pragma mark busy view management

- (void)showBusyView
{
	[window bringSubviewToFront:busyMainView_];
	[window bringSubviewToFront:busyActivityIndicator_];
	[busyActivityIndicator_ startAnimating];
	busyActivityIndicator_.hidden = NO;
	busyMainView_.hidden = NO;
}

- (void)hideBusyView
{
	[busyActivityIndicator_ stopAnimating];
	busyActivityIndicator_.hidden = YES;
	busyMainView_.hidden = YES;
}



@end
