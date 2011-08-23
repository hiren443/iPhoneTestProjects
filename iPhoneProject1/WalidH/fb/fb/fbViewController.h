//
//  fbViewController.h
//  fb
//
//  Created by Mac on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface fbViewController : UIViewController<FBSessionDelegate, FBRequestDelegate>{
    Facebook *facebook;
}
@property (nonatomic, retain) Facebook *facebook;
- (IBAction)buttonClicked:(id)sender;
@end
