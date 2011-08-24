//
//  RootViewController.h
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class RecordingTableViewController;
@interface RootViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

	NSString *currentVideoPath;
	MPMoviePlayerViewController *player;
    UIImagePickerController *cameraUI;
    NSDictionary *infoDictionary;
    UITextField *myTextField;
    
    RecordingTableViewController *recordingTableViewController;
    
}

@property(nonatomic,retain) NSString *currentVideoPath;
@property(nonatomic,retain) MPMoviePlayerViewController *player;
@property(nonatomic,retain) UIImagePickerController *cameraUI;
@property(nonatomic,retain) NSDictionary *infoDictionary;
@property(nonatomic,retain) UITextField *myTextField;
@property(nonatomic,retain) RecordingTableViewController *recordingTableViewController;

- (IBAction) showCameraUI;
- (void) useBtnClicked;
@end