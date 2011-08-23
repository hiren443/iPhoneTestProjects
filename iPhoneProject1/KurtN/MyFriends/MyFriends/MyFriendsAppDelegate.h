//
//  MyFriendsAppDelegate.h
//  MyFriends
//
//  Created by Kurt Niemi on 8/20/11.
//  Copyright 2011 22nd Century Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyFriendsViewController;

@interface MyFriendsAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MyFriendsViewController *viewController;

@end
