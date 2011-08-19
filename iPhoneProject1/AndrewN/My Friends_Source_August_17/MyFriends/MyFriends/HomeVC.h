//
//  LoginVC.h
//  MyFriends
//
//  Created by The Linh NGUYEN on 8/17/11.
//  Copyright 2011 Hirevietnamese Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface HomeVC : UIViewController<FBSessionDelegate, FBRequestDelegate,UITableViewDataSource> {
    FBSession* _session;
	FBLoginDialog *_loginDialog;
    NSMutableArray *_friends;
    UIButton *_btnLogin;
    UITableView *_tbvFriends;
}

@property (nonatomic, retain) FBSession *session;
@property (nonatomic, retain) FBLoginDialog *loginDialog;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) IBOutlet UIButton *btnLogin;
@property (nonatomic, retain) IBOutlet UITableView *tbvFriends;

- (IBAction) doLogin:(id) sender;
- (IBAction) doLogout:(id) sender;
@end
