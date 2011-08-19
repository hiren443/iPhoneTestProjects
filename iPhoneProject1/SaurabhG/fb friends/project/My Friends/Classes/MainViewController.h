//
//  MainViewController.h
//  My Friends
//
//  Created by Saurabh on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect/FBConnect.h"
NSMutableArray *friendsArray;
@class FBSession;
@interface MainViewController : UIViewController <FBDialogDelegate, FBSessionDelegate, FBRequestDelegate,UITableViewDelegate, UITableViewDataSource>{

	UITableView *tableView;
	FBSession* _session;
	NSArray *myList;
	//NSMutableArray *friendsArray;
}
-(void)fbConnectMethod;
@end
