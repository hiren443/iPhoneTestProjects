//
//  video_recordingAppDelegate.h
//  video_recording
//
//  Created by Pavan Patel on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface video_recordingAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    NSString *act,*nameVideo;
	NSMutableArray *select;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSString *act,*nameVideo;
@property (nonatomic, retain) NSMutableArray *select;
@end

