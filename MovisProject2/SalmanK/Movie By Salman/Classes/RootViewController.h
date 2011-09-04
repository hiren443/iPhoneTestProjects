//
//  RootViewController.h
//  video_recording
//
//  Created by Pavan Patel on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class video_recordingAppDelegate;
@interface RootViewController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate> {
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
    video_recordingAppDelegate *app;
    NSMutableArray *imgArray;
    
}

- (IBAction) showCameraUI;
- (void) useBtnClicked;
-(void)generateImage;
@end
