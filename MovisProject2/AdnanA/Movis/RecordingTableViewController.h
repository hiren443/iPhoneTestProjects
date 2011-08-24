//
//  RecordingTableViewController.h
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "FBConnect.h"
@class Loading;
@interface RecordingTableViewController : UIViewController<FBSessionDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *recordingTableView;
    
    IBOutlet UIButton *faceBookConnectButton;
    
    NSTimer *timerFBLogin;
    Loading *activity;
    
    NSMutableArray *friendListNSMutableArray;
    
    NSMutableDictionary *friendsListMutableDictionery;
    
    MPMoviePlayerViewController *player;

    int selecctedIndex;
    
    NSMutableArray *pathOfVideos;
    
    NSString * urlStringOfVideo;
    
}


/////Methods///
-(void)loginThroughFacebook;
-(void)loginThroughFacebookSuccessful;
-(void)signinFacebookRequest;
-(void)loginThroughFacebookUnSuccessful;
-(void)loginThroughFacebookInterm;

- (void)getFriendList;


////Properties//////////
@property(nonatomic,retain)    IBOutlet UIButton *faceBookConnectButton;
@property(nonatomic,retain)    NSTimer *timerFBLogin;
@property(nonatomic,retain)    Loading *activity;
@property(nonatomic,retain)    NSMutableArray *friendListNSMutableArray;
@property(nonatomic,retain)    NSMutableDictionary *friendsListMutableDictionery;
@property(nonatomic,retain)    IBOutlet UITableView *recordingTableView;
@property(nonatomic,retain)    MPMoviePlayerViewController *player;

@property(nonatomic,assign)    int selecctedIndex;
@property(nonatomic,retain)    NSMutableArray *pathOfVideos;
@property(nonatomic,retain)    NSString * urlStringOfVideo;


@end