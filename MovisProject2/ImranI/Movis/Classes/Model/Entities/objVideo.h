//
//  objVideo.h
//  Movis
//
//  Created by Imran Ishaq on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface objVideo : NSObject {
    NSString *strVideoPath,*strVideoName,*strimgName;
    int videoID;
}
@property int videoID;
@property(retain,nonatomic) NSString *strVideoPath,*strVideoName,*strimgName;
@end
