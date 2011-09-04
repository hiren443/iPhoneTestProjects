//
//  Movis2AppDelegate.h
//  Movis2
//
//  Created by Eugene Pavlyuk on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Movis2AppDelegate : NSObject <UIApplicationDelegate> 
{
	UINavigationController *navController;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

