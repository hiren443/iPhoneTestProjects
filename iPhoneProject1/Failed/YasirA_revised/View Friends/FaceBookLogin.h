//
//  FaceBookLogin.h
//  View Friends
//
//  Created by uraan on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FaceBookLogin : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UIView			*mainView;
	IBOutlet UITableView	*fbFriendsTableView;
	
	NSMutableArray *friendsList;
}
@property (retain, nonatomic) NSMutableArray *friendsList;

@end
