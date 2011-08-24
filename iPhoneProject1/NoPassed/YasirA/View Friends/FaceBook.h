//
//  FaceBook.h
//  View Friends
//
//  Created by uraan on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface FaceBook : UIViewController<FBRequestDelegate,FBDialogDelegate,FBSessionDelegate, FBRequestDelegate> {
	Facebook		*facebook;
}

- (IBAction) clickViewFriendsList;
@end
