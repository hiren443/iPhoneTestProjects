//
//  FriendsCustomCell.h
//  MyFriends
//
//  Created by Adnan Ahmad on 8/16/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FriendsCustomCell : UITableViewCell {
    
    IBOutlet UILabel *name;
    IBOutlet UIImageView *imageView;
}

@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property(nonatomic,retain)IBOutlet UILabel *name;
@end
