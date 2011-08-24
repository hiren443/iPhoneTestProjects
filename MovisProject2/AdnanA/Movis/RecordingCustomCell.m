//
//  RecordingCustomCell.m
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import "RecordingCustomCell.h"


@implementation RecordingCustomCell

@synthesize  video;
@synthesize  faceBook;
@synthesize  title;
@synthesize  date;

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
    [video release];
    [faceBook release];
    [title release];
    [date release];
    [super dealloc];
}

@end
