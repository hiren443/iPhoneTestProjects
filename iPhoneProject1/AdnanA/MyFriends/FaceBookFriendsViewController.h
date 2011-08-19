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


@interface FaceBookFriendsViewController : UITableViewController {
    
    NSMutableArray *faceBookFriendsNsMutableArray;
    //To Enable intelligent image loading 
    NSMutableDictionary *imageDownloadsInProgress; 
    IBOutlet UITableView *friendTableView;
    
}

@property(nonatomic,retain) NSMutableArray *faceBookFriendsNsMutableArray;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)    IBOutlet UITableView *friendTableView;

- (void)loadImagesForOnscreenRows;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)startIconDownload:(NSObject *)newDataRecord forIndexPath:(NSIndexPath *)indexPath;
-(void)backAction;


@end
