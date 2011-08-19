//
//  FriendsViewController.h
//  MyFriends
//
//  Created by Eugene Pavlyuk on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBConnect.h"

#define kMainTag  @"data"
#define kUserNameKey	@"name"

@interface FriendsViewController : UIViewController <FBRequestDelegate, UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray *friends;
	UIActivityIndicatorView *spinnerView;
	UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinnerView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
