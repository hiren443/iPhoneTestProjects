//
//  FriendsTableViewController.h
//  MyFriends
//
//  Created by Maxim Pervushin on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface FriendsTableViewController : UITableViewController<FBRequestDelegate>
{
    Facebook* _facebook;
    NSArray* _data;
}

@property (nonatomic, assign) NSArray* data;

@end
