//
//  SendMessageViewController.h
//  Status Shuffler
//
//  Created by Awais Macbook on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface SendMessageViewController : UITableViewController<FBRequestDelegate> {
	NSMutableDictionary *friendlist;
	NSString *statusMessage;
	NSMutableArray *dataArray;
	id delegate;
}
@property(nonatomic,retain)NSMutableDictionary *friendlist;
@property(nonatomic,retain)NSString *statusMessage;
@property(nonatomic,retain)id delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithFriendList:(NSMutableDictionary*)list WithMessage:(NSString*)message;
@end
