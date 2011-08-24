//
//  RecordingCustomCell.h
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecordingCustomCell : UITableViewCell {
    
    IBOutlet UIButton *video;
    IBOutlet UIButton *faceBook;
    IBOutlet UILabel *title;
    IBOutlet UILabel *date;
}
@property(nonatomic,retain) IBOutlet UIButton *video;
@property(nonatomic,retain  ) IBOutlet UIButton *faceBook;
@property(nonatomic,retain) IBOutlet UILabel *title;
@property(nonatomic,retain) IBOutlet UILabel *date;

@end
