//
//  MovisViewController.h
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Facebook.h"

@class AppDelegate;

@interface MovisViewController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate> {
	NSMutableArray *pathOfVideos;
	IBOutlet UITableView *tbl;
	NSString *currentVideoPath;
	MPMoviePlayerViewController *player;
    IBOutlet UIView *overlayview;
    IBOutlet UIButton *useBtn;
    UIImagePickerController *cameraUI;
    int i;
    NSDictionary *infoDictionary;
    UITextField *myTextField;
    NSString *strName,*url;
    AppDelegate *app;
    NSMutableArray *imgArray;
    IBOutlet UIButton *btndelete;
    
}

- (IBAction) showCameraUI;
- (void) useBtnClicked;
-(void)generateImage;
-(void)GetAllVideos;
-(void)DeleteVideoFromDatabase:(int)ID;
@end

