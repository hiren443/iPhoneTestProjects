#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FBConnect.h"
#import "XMPPvCardTempModule.h"

@class SettingsViewController;
@class XMPPStreamFacebook;
@class XMPPReconnect;
@class XMPPRoster;
@class XMPPRosterCoreDataStorage;
@class XMPPvCardAvatarModule;
@class XMPPvCardTempModule;


@interface iPhoneXMPPAppDelegate : NSObject 
<UIApplicationDelegate,
FBRequestDelegate, 
FBDialogDelegate, 
FBSessionDelegate, 
UITableViewDelegate, 
UITableViewDataSource, 
NSFetchedResultsControllerDelegate, 
XMPPvCardTempModuleDelegate>{
	XMPPStreamFacebook *xmppStream;
	XMPPReconnect*	xmppReconnect;
	XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
  XMPPvCardAvatarModule *_xmppvCardAvatarModule;
  XMPPvCardTempModule *_xmppvCardTempModule;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isOpen;
	
	UIWindow *window;
	UINavigationController *navigationController;
  UIBarButtonItem *_loginButton;
  
  SettingsViewController *_loginViewController;
	
	Facebook*		facebook;
	NSString*	accessToken;
	NSString*	uid;
	
	UIButton *button;
	UILabel* label;
	UITableView*	myTableView;
	
	NSFetchedResultsController *fetchedResultsController;

}

@property (nonatomic, retain) UITableView*	myTableView;
@property (nonatomic, retain) Facebook*	facebook;
@property (nonatomic, retain) NSString*	accessToken;

@property (nonatomic, readonly) XMPPReconnect*	xmppReconnect;
@property (nonatomic, readonly) XMPPStreamFacebook *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, readonly) XMPPvCardTempModule *xmppvCardTempModule;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic, retain) IBOutlet SettingsViewController *settingsViewController;

- (BOOL)connect;
- (void)disconnect;

- (void)goOnline;
- (void)goOffline;

- (void) authFacebook;
- (void)setupStream;
@end
