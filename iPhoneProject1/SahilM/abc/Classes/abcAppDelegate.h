//
//  abcAppDelegate.h
//  abc
//
//  Created by apple on 8/24/11.
//  Copyright 2011 354456. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface abcAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    NSMutableArray *arrFriend;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic,retain) NSMutableArray *arrFriend;

@end

