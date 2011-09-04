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

@class AppDelegate;
@class objVideo;

@interface FBFunViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, FBRequestDelegate> {
    AppDelegate *app;
    IBOutlet UILabel *videoName;
    IBOutlet UIImageView *videoThumb;
    objVideo *obj;
    // for the popUpView
    
    IBOutlet UIView *popUp;
    IBOutlet UITableView *popUpTable;
    IBOutlet UIButton *postButton,*closeButton;
    NSMutableArray *arrFriends,*arrSelectedFriends;
	NSString *idForVideo;
	UIActivityIndicatorView *act;
    Facebook *facebook;
    int sharingTag;
    IBOutlet UIImageView *titleimgView;
    NSMutableArray *sectionArray;
    
}
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign)int sharingTag;
@property(retain,nonatomic) objVideo *obj;
-(void)uploadVideo;

- (void) createSectionList: (id) wordArray;
- (IBAction)postToWallClicked:(id)sender;
-(IBAction)back_Clicked:(id)sender;
-(IBAction)ShareFriendsClicked:(id)sender;
-(IBAction)postButtonClicked;
-(IBAction)closeButtonClicked;
@end

