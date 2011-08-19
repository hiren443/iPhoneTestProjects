//
//  Friend.m
//  MyFriends
//
//  Created by Eugene Pavlyuk on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Friend.h"


@implementation Friend

@synthesize name;

- (void) dealloc
{
	self.name = nil;
	[super dealloc];
}

- (NSComparisonResult) sortByName:(Friend*)friend
{
    return [self.name compare:friend.name];
}

@end
