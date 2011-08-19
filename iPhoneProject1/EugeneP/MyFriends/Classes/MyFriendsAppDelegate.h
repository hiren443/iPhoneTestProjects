//
//  MyFriendsAppDelegate.h
//  MyFriends
//
//  Created by Eugene Pavlyuk on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

#define kAppId	@"145062165564860"

@class MyFriendsViewController;
@class Facebook;

@interface MyFriendsAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> 
{
    UIWindow *window;
    MyFriendsViewController *viewController;
	Facebook *facebook;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MyFriendsViewController *viewController;
@property (nonatomic, retain) Facebook *facebook;

@end

