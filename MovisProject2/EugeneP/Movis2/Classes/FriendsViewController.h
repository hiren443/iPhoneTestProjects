//
//  FriendsViewController.h
//  Movis2
//
//  Created by Eugene Pavlyuk on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareViewController;

@interface FriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray *friends;
	UITableView *friendsTableView;
	
	ShareViewController *shareViewController;
	
	NSMutableArray *sortedFriends;
	NSMutableArray *sections;
}

@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) NSMutableArray *sortedFriends;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) IBOutlet UITableView *friendsTableView;

@property (nonatomic, retain) ShareViewController *shareViewController;

@end
