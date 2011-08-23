//
//  My_FriendsViewController.h
//  My Friends
//
//  Created by naceka on 21.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FriendsViewController.h"

@interface My_FriendsViewController : UIViewController<FBSessionDelegate, FBRequestDelegate> {
	IBOutlet UIButton *bfrnds;
	IBOutlet FriendsViewController *friends;
	
	Facebook *facebook;
	NSArray *permissions;

}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSArray *permissions;

-(IBAction) buttonShowFriends:(id)sender;
@end

