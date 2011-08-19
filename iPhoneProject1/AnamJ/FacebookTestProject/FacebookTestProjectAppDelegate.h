//
//  FacebookTestProjectAppDelegate.h
//  FacebookTestProject
//
//  Created by Saad Mubarak on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
@interface FacebookTestProjectAppDelegate : NSObject <UIApplicationDelegate,FBSessionDelegate> {
    Facebook* m_facebook;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) Facebook *m_facebook;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@end
