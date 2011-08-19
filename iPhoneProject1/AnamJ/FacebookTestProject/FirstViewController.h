//
//  FirstViewController.h
//  FacebookTestProject
//
//  Created by Saad Mubarak on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBConnect.h"
@interface FirstViewController : UIViewController <FBRequestDelegate>{
    Facebook *m_facebook;
}
- (IBAction)viewFriendsPressed:(id)sender;
@property (nonatomic, retain) Facebook *m_facebook;
@end
