//
//  Home.h
//  View Friends
//
//  Created by uraan on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"


@interface Home : UIViewController<FBRequestDelegate,FBDialogDelegate,FBSessionDelegate, FBRequestDelegate> {
	Facebook		*facebook;
}

- (IBAction) clickViewFriendsList;
@end
