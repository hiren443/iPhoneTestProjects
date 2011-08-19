//
//  MyFriendsViewController.h
//  MyFriends
//
//  Created by hiren bhadreshwara on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface MyFriendsViewController : UIViewController <FBSessionDelegate, FBRequestDelegate, UITableViewDelegate, UITableViewDataSource>{
	UIButton *fbBtn;
	Facebook *facebook;
	NSArray* _permissions;

}

@property (nonatomic, retain) Facebook *facebook;

@property (nonatomic, retain) IBOutlet UIButton *fbLoginBtn;
-(IBAction)getMeLogin:(id)sender;
-(IBAction)getMeFriendsButtonPressed:(id)sender;


@end

