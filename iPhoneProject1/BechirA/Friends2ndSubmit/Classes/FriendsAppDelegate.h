//
//  FriendsAppDelegate.h
//  Friends
//
//  Created by mac on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect/FBConnect.h"
#import "FBConnect/FBSession.h" 

@class FriendsViewController;

@interface FriendsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FriendsViewController *viewController;
	FBSession *_session;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FriendsViewController *viewController;
@property (nonatomic, retain) FBSession *_session;
@end

