//
//  MyFriendsViewController.h
//  MyFriends
//
//  Created by Kurt Niemi on 8/20/11.
//  Copyright 2011 22nd Century Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface MyFriendsViewController : UIViewController<FBSessionDelegate, FBRequestDelegate>
{
    Facebook *facebook;
}
- (IBAction)myFriendButtonClicked:(id)sender;

@property(nonatomic,retain) Facebook *facebook;

@end
