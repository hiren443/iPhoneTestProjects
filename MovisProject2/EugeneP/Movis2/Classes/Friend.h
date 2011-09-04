//
//  Friend.h
//  MyFriends
//
//  Created by Eugene Pavlyuk on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Friend : NSObject 
{
	NSString *name;
	NSString *friend_id;
	BOOL selected;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *friend_id;
@property (nonatomic, assign) BOOL selected;

@end
