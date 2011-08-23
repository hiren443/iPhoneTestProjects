//
//  My_FriendsAppDelegate.h
//  My Friends
//
//  Created by naceka on 21.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h" 

@class My_FriendsViewController;

@interface My_FriendsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    My_FriendsViewController *viewController;
	
	NSMutableArray *data;
	
		
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet My_FriendsViewController *viewController;
@property (nonatomic, retain) NSMutableArray *data;

@end

