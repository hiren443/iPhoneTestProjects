//
//  RootViewController.h
//  abc
//
//  Created by apple on 8/24/11.
//  Copyright 2011 354456. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbGraph.h"
#import "FriendList.h"


@interface RootViewController : UIViewController {
    
    IBOutlet UIButton *btnFriends;
    FbGraph *fbGraph;
    FriendList *objFriend;
    
}

// facebook Property
@property (nonatomic, retain) FbGraph *fbGraph;
-(IBAction)btnFriends:(id)sender;
@end
