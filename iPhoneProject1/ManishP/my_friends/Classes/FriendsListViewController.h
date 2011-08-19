//
//  FriendsListViewController.h
//  My Friends
//
//  Created by Manish Patel on 16/08/11.
//  Copyright 2011 MacyMind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedManager.h"

@interface FriendsListViewController : UITableViewController<LoginDelegate, FriendsDelegate>
{
	NSArray *friendsList;
}

@end
