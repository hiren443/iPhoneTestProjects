//
//  FacebookViewController.h
//  Facebook
//
//  Created by amina on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

//FBDialogDelegate,

@interface FacebookViewController : UIViewController <FBSessionDelegate,FBRequestDelegate>{
	Facebook *facebook;
	NSMutableArray *friends;
	//int buttonEnable;
	IBOutlet UIView *activityView;
	IBOutlet UILabel *errorMsg;
}
@property (nonatomic, retain) UILabel *errorMsg;
@property (nonatomic, retain) UIView *activityView;
@property (nonatomic, retain) Facebook *facebook;

- (IBAction)showFriends;
@end

