//
//  FaceBookFriendsViewController.h
//  MyFriends
//
//  Created by Adnan Ahmad on 8/16/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import <QuartzCore/QuartzCore.h>
#import "Facebook.h"
@class Loading;
@interface FaceBookFriendsViewController : UITableViewController <FBRequestDelegate>{
    
    NSMutableArray *faceBookFriendsNsMutableArray;
    //To Enable intelligent image loading 
    NSMutableDictionary *imageDownloadsInProgress; 
    IBOutlet UITableView *friendTableView;
    int selectedIndex;
    NSString *urlPathForVideo;
    
    NSInteger _radioSelection;
    UIProgressView *myProgressIndicator;
    Loading *activity;
    
    NSMutableArray *arrSelectedFriends;

    
    }

@property(nonatomic,retain) NSMutableArray *faceBookFriendsNsMutableArray;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)    IBOutlet UITableView *friendTableView;

- (void)loadImagesForOnscreenRows;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)startIconDownload:(NSObject *)newDataRecord forIndexPath:(NSIndexPath *)indexPath;
-(void)backAction;
@property(nonatomic,assign)int selectedIndex;
@property(nonatomic,retain)    NSString *urlPathForVideo;
-(void)shareVideoWithFriend;
@property(nonatomic,retain)        UIProgressView *myProgressIndicator;

@property(nonatomic,retain)    Loading *activity;

@property(nonatomic,retain)    NSMutableArray *arrSelectedFriends;

@end
