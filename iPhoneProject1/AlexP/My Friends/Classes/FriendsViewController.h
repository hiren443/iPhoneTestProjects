//
//  FriendsViewController.h
//  My Friends
//
//  Created by naceka on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FriendsViewController : UITableViewController {
	IBOutlet UITableView *table;
	
	NSArray *friends;

}

@property (nonatomic, retain) NSArray *friends;

@end
