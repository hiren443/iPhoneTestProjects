//
//  RootViewController.h
//  MyFriends
//
//  Created by Adnan Ahmad on 8/16/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  Loading;

@interface RootViewController : UIViewController {

    
    IBOutlet UIButton *faceBookConnectButton;
    
    NSTimer *timerFBLogin;
    Loading *activity;
    
    NSMutableArray *friendListNSMutableArray;
    
    NSMutableDictionary *friendsListMutableDictionery;
    

}


/////Methods///
-(IBAction)facebookConnectButtonPressed;
-(void)loginThroughFacebook;
-(void)loginThroughFacebookSuccessful;
-(void)signinFacebookRequest;
-(void)loginThroughFacebookUnSuccessful;
- (void)getFriendList;


////Properties//////////
@property(nonatomic,retain)    IBOutlet UIButton *faceBookConnectButton;
@property(nonatomic,retain)    NSTimer *timerFBLogin;
@property(nonatomic,retain)    Loading *activity;
@property(nonatomic,retain)    NSMutableArray *friendListNSMutableArray;
@property(nonatomic,retain)    NSMutableDictionary *friendsListMutableDictionery;


@end
