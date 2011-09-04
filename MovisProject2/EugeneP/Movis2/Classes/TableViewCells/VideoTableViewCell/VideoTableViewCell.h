//
//  VideoTableViewCell.h
//  Movis2
//
//  Created by Eugene Pavlyuk on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVideoTableViewCellIdentifier		@"VideoTableViewCellIdentifier"
#define kShareButtonPressedNotification		@"ShareButtonPressedNotification"

#define kDefaultCellHeight	80

@interface CellView : UIView

@end

@class GradientButton;

@interface VideoTableViewCell : UITableViewCell 
{
	UILabel *filenameLabel;
	GradientButton *shareButton;
	UIImageView *imageView;
	NSIndexPath *indexPath;
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) IBOutlet UILabel *filenameLabel;
@property (nonatomic, retain) IBOutlet GradientButton *shareButton;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) NSIndexPath *indexPath;

- (IBAction) shareButtonPressed;

@end
