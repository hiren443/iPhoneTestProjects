//
//  MyFriendsAppDelegate.h
//  MyFriends
//
//  Created by The Linh NGUYEN on 8/17/11.
//  Copyright 2011 Hirevietnamese Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendsAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;

@end
