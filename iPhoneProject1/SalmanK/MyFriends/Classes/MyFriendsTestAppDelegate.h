



#import <UIKit/UIKit.h>

@class MyFriendsTestViewController;

@interface MyFriendsTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MyFriendsTestViewController *viewController;
	IBOutlet UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MyFriendsTestViewController *viewController;

@end

