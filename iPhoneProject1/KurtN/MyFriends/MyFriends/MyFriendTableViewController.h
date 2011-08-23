//
//  MyFriendTableViewController.h
//  MyFriends
//
//  Created by Kurt Niemi on 8/20/11.
//  Copyright 2011 22nd Century Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendTableViewController : UITableViewController
{
    NSArray *friendArray;
}

@property(nonatomic,retain) NSArray *friendArray;

@end
