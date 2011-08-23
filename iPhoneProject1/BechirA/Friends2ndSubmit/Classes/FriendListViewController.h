//
//  FriendListViewController.h
//  Friends
//
//  Created by mac on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsViewController.h"

@interface FriendListViewController : UIViewController {
	IBOutlet UITableView * _tableView;
	IBOutlet NSArray* usersArray;
}
@property (nonatomic,retain) IBOutlet NSArray* usersArray;
@property (nonatomic,retain) IBOutlet UITableView * tableView;

-(IBAction)close:(id)sender;
@end
