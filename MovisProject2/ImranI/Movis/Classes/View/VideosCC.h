//
//  VideosCC.h
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovisViewController;

@interface VideosCC : UITableViewCell {
    IBOutlet UIButton *btnShare,*btnPlayVideo;
    IBOutlet UILabel *lblVideoName;
    IBOutlet UIImageView *imgViewVideoThumbnail;
    MovisViewController *MVC;
}
@property(retain,nonatomic)MovisViewController *MVC;
@property(retain,nonatomic)IBOutlet UIButton *btnShare,*btnPlayVideo;
@property(retain,nonatomic)IBOutlet UILabel *lblVideoName;
@property(retain,nonatomic)IBOutlet UIImageView *imgViewVideoThumbnail;
@end
