//
//  FreindsListController.h
//  Facebook
//
//  Created by amina on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FreindsListController : UIViewController {

	//NSMutableDictionary *friendsDic;
	NSArray *friends;
 	IBOutlet UITableView *dataTableView;
}
@property(nonatomic,retain)	NSArray *friends;
@property(nonatomic,retain)	UITableView *dataTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFriendLsit:(NSDictionary*)dic;
@end
