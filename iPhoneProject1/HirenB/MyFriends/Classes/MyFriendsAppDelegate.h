//
//  MyFriendsAppDelegate.h
//  MyFriends
//
//  Created by hiren bhadreshwara on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
@class MyFriendsViewController;

@interface MyFriendsAppDelegate : NSObject <UIApplicationDelegate,FBSessionDelegate> {
    UIWindow *window;
	NSMutableArray *friendArray;
    MyFriendsViewController *viewController;

}

	@property (nonatomic, retain) NSMutableArray *friendArray;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MyFriendsViewController *viewController;

@end

