//
//  CustomCell.m
//  StockRing
//
//  Created by Sunil on 2/16/10.
//  Copyright 2010 iTriangle techniqa. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize topLbl,iconImg,btn,nameFriends,checkBoxButton;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
				
		topLbl = [[UILabel alloc] initWithFrame:frame];
		topLbl.font = [UIFont boldSystemFontOfSize:14];
		topLbl.textAlignment = UITextAlignmentLeft;
		topLbl.adjustsFontSizeToFitWidth = TRUE;
		topLbl.backgroundColor = [UIColor clearColor];
		topLbl.numberOfLines = 2;
		[self.contentView addSubview:topLbl];
		
        
        btn=[[UIButton alloc] init];
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setBackgroundImage:[UIImage imageNamed:@"Share_button_d.png"] forState:UIControlStateNormal];
            //[btn setTitle:@"Share" forState:normal];
        
		btn.hidden = TRUE;
		[self.contentView addSubview:btn];
		
		checkBoxButton = [[UIButton alloc] init];
		checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
		checkBoxButton.hidden = TRUE;
		[checkBoxButton setImage:[UIImage imageNamed:@"checkmark_d.png"] forState:UIControlStateNormal];
		[self.contentView addSubview:checkBoxButton];
		
		nameFriends = [[UILabel alloc] init];
		nameFriends.backgroundColor = [UIColor clearColor];
		nameFriends.textColor = [UIColor whiteColor];
		nameFriends.textAlignment = UITextAlignmentCenter;
		nameFriends.font = [UIFont boldSystemFontOfSize:14];
		nameFriends.hidden = TRUE;
		[self.contentView addSubview:nameFriends];
		
		
		iconImg = [[UIImageView alloc] init];
		[self.contentView addSubview:iconImg];

		self.selectionStyle=UITableViewCellSelectionStyleNone;
	}
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)layoutSubviews
{
	topLbl.frame=CGRectMake(100,2,200,40);
	iconImg.frame = CGRectMake(20, 5, 70, 70);
    btn.frame = CGRectMake(210, 30, 87, 27);
	
	
	checkBoxButton.frame = CGRectMake(10, 10, 30, 30);
	nameFriends.frame = CGRectMake(60, 10, 220, 30);
	
	[super layoutSubviews];
}
- (void)dealloc {
    [super dealloc];
}


@end
