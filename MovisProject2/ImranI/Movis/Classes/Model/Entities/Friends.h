//
//  Friends.h
//  View Friends
//
//  Created by Imran Ishaq on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Friends : NSObject {
    NSString *strFriendName;
    int frndID;
}

@property int frndID;
@property (retain, nonatomic) NSString *strFriendName;
@end
