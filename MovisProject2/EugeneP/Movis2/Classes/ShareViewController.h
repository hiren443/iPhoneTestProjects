//
//  ShareViewController.h
//  Movis2
//
//  Created by Eugene Pavlyuk on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBLoginDialog.h"

@class GradientButton;

@interface ShareViewController : UIViewController <FBLoginDialogDelegate, FBDialogDelegate>
{
	NSString *filename;
	
@private
	FBLoginDialog *loginDialog;
	NSString *accessToken;
	UIImageView *imageView;
	NSMutableArray *friends;
	NSTimer *timer;
}

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) IBOutlet GradientButton *loginButton;
@property (nonatomic, retain) IBOutlet GradientButton *logoutButton;
@property (nonatomic, retain) IBOutlet GradientButton *postToMyWallButton;
@property (nonatomic, retain) IBOutlet GradientButton *postToFriendsWallButton;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;
- (IBAction)postToMyWallButtonTapped;
- (IBAction)postToFriendsWallButtonTapped;

- (void) continueShareForFriends;

@end
