//
//  FriendsCC.h
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FriendsCC : UITableViewCell {
 
    IBOutlet UIButton *checkBoxButton;
    IBOutlet UILabel *nameFriends;
}
@property(retain,nonatomic)IBOutlet UIButton *checkBoxButton;
@property(retain,nonatomic)IBOutlet UILabel *nameFriends;
@end
