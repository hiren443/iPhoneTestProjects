//
//  FacebookAppDelegate.h
//  Facebook
//
//  Created by amina on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class FacebookViewController;

@interface FacebookAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FacebookViewController *viewController;
	//Facebook *facebook;
}
//@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FacebookViewController *viewController;

@end

