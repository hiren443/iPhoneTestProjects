//
//  CustomCell.h
//  StockRing
//
//  Created by Sunil on 2/16/10.
//  Copyright 2010 iTriangle techniqa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {

// for the main page....
	UILabel *topLbl;
    UIButton *btn;
	UIImageView *iconImg;
	
// for the friends popUP
	
	UIButton *checkBoxButton;
	UILabel *nameFriends;
} 
@property(nonatomic,retain)UILabel *topLbl,*nameFriends;
@property(nonatomic,retain)UIButton *btn,*checkBoxButton;
@property(nonatomic, retain)UIImageView *iconImg;

@end
