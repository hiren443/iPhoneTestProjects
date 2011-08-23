//
//  fbAppDelegate.h
//  fb
//
//  Created by Mac on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class fbViewController;

@interface fbAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet fbViewController *viewController;

@end
