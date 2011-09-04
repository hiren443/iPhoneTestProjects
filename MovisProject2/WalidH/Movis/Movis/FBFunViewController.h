//
//  FBFunViewController.h
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class MovisAppDelegate;
@interface FBFunViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, FBRequestDelegate> {
    MovisAppDelegate *app;
    IBOutlet UILabel *videoName;
    IBOutlet UIImageView *videoThumb;
    
// for the popUpView
    
    IBOutlet UIView *popUp;
    IBOutlet UITableView *popUpTable;
    IBOutlet UIButton *postButton,*closeButton;
    NSMutableArray *arrFriends,*arrSelectedFriends;
	NSString *idForVideo;
	UIActivityIndicatorView *act;
    Facebook *facebook;
    int sharingTag;
}
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign)int sharingTag;
-(void)uploadVideo;


- (IBAction)postToWallClicked:(id)sender;
-(IBAction)back_Clicked:(id)sender;
-(IBAction)ShareFriendsClicked:(id)sender;
-(IBAction)postButtonClicked;
-(IBAction)closeButtonClicked;
@end

