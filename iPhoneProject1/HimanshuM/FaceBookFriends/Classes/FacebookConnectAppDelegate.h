//
//  FacebookConnectAppDelegate.h
//  FacebookConnect
//
//  
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface FacebookConnectAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	RootViewController *vc;
}
@property (nonatomic, retain)  UIWindow *window;
@property (nonatomic, retain)  UINavigationController *navigationController;

@end

