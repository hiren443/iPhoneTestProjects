//
//  MyFriendsAppDelegate.m
//  MyFriends
//
//  Created by The Linh NGUYEN on 8/17/11.
//  Copyright 2011 Hirevietnamese Co. Ltd. All rights reserved.
//

#import "MyFriendsAppDelegate.h"
#import "HomeVC.h"

@implementation MyFriendsAppDelegate


@synthesize window=_window;
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    HomeVC *homeVC = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:[NSBundle mainBundle]];
    self.navController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.navController.navigationBar.barStyle = UIBarStyleBlack;
    [homeVC release];
    [self.window addSubview:[navController view]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [navController release];
    [_window release];
    [super dealloc];
}

@end
