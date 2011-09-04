//
//  VideoTableViewCell.m
//  Movis2
//
//  Created by Eugene Pavlyuk on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoTableViewCell.h"

#import <QuartzCore/QuartzCore.h>
#import "GradientButton.h"

#define kCellViewWidth 320.f
#define kCellViewHeight 80.f


@interface CellView()

- (void)initialize;

@end


@implementation CellView

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self initialize];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self initialize];
	}
	return self;
}

- (void)initialize
{
	self.clipsToBounds = YES;
	
	self.backgroundColor = [UIColor lightGrayColor];
	
	CAGradientLayer *gradientLayer = (CAGradientLayer*)self.layer;
	gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.f alpha:1.f].CGColor,
							(id)[UIColor colorWithWhite:0.9f alpha:1.f].CGColor, nil];
	
}

- (void)dealloc
{
	[super dealloc];
}

@end


@implementation VideoTableViewCell

@synthesize filenameLabel;
@synthesize shareButton;
@synthesize imageView;
@synthesize indexPath;
@synthesize activityView;

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.imageView.layer.cornerRadius = 5.f;
	self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
	self.imageView.layer.borderWidth = 1.f;
	
	[shareButton useAlertStyle];
	shareButton.strokeColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.0];
	shareButton.cornerRadius = 5.f;			
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if((self = [super initWithCoder:aDecoder]))
	{
		CellView *cellView = [[[CellView alloc] initWithFrame:CGRectMake(0.f, 0.f, kCellViewWidth, kCellViewHeight)] autorelease];
		[self.contentView addSubview:cellView];		
		[self.contentView sendSubviewToBack:cellView];
	}
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		CellView *cellView = [[[CellView alloc] initWithFrame:CGRectMake(0.f, 0.f, kCellViewWidth, kCellViewHeight)] autorelease];
		[self.contentView addSubview:cellView];
		[self.contentView sendSubviewToBack:cellView];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc 
{
	self.filenameLabel = nil;
	self.shareButton = nil;
	self.imageView = nil;
	self.indexPath = nil;
	self.activityView = nil;
    [super dealloc];
}

- (IBAction) shareButtonPressed
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kShareButtonPressedNotification object:self.indexPath];
}

@end
