//
//  MainViewController.h
//  MyFriends
//
//  Created by Maxim Pervushin on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Facebook.h"

@interface MainViewController : UIViewController<FBSessionDelegate, FBRequestDelegate>
{
    Facebook* _facebook;
    UIButton *_viewFriendsButton;
}

@property (nonatomic, retain) Facebook* facebook;
@property (nonatomic, retain) IBOutlet UIButton *viewFriendsButton;

- (IBAction)logIn:(id)sender;

@end
