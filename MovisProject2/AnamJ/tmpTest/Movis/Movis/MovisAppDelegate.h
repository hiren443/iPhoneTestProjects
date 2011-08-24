//
//  MovisAppDelegate.h
//  Movis
//
//  Created by Saad Mubarak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
@interface MovisAppDelegate : NSObject <UIApplicationDelegate,FBSessionDelegate> {
    NSString *act,*nameVideo;
	NSMutableArray *select;
     Facebook* m_facebook;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) Facebook *m_facebook;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSString *act,*nameVideo;
@property (nonatomic, retain) NSMutableArray *select;
@end
