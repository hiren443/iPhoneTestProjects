//
//  FriendsCC.m
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendsCC.h"


@implementation FriendsCC

@synthesize checkBoxButton,nameFriends;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
