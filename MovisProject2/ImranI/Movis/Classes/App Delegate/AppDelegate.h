//
//  AppDelegate.h
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBHandler.h"
#import "Facebook.h"

@class MovisViewController;
@interface AppDelegate : NSObject <UIApplicationDelegate,FBSessionDelegate> {
    UIWindow *window;
    MovisViewController *viewController;
    
    UINavigationController *navigationController;
    
    // busy view
    IBOutlet UIView*				busyMainView_;
	IBOutlet UIActivityIndicatorView*	busyActivityIndicator_;
    NSString *act,*nameVideo;
	NSMutableArray *select;
    Facebook* m_facebook;
}
@property (nonatomic, retain) Facebook *m_facebook;
@property (nonatomic, retain) NSString *act,*nameVideo;
@property (nonatomic, retain) NSMutableArray *select;
@property(nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MovisViewController *viewController;

- (void)showBusyView;
- (void)hideBusyView;


#define APPDELEGATE \
((AppDelegate*)[UIApplication sharedApplication].delegate)

#define GET_DBHANDLER(dbHandler)\
DBHandler *dbHandler = [[DBHandler alloc] init];

#define GET_DEFAULTS(defaults)\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

#define ALERT_VIEW(msg)\
{\
UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Movis" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];\
[av show];\
[av release];\
}




@end

