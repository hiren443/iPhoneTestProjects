//
//  FriendsViewController.h
//  Friends
//
//  Created by mac on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FriendsAppDelegate.h"
#import "FBConnect/FBConnect.h"
#import "FBConnect/FBSession.h"


@interface FriendsViewController : UIViewController<FBSessionDelegate,FBRequestDelegate,FBDialogDelegate> {

	FBSession *usersession;
	NSString *username;
	FriendsAppDelegate *appDelegate;
	BOOL post;
	IBOutlet UIActivityIndicatorView *activityIndicator;
}



@property(nonatomic,retain) FBSession *usersession;
@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) FriendsAppDelegate *appDelegate;
@property(nonatomic,assign) BOOL post;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;


-(IBAction)PartageFacebook:(id)sender;
- (void)getFacebookName;
- (void) Loadtableview;
@end

