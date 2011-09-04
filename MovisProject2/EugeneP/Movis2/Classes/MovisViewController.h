//
//  MovisViewController.h
//  Movis2
//
//  Created by Eugene Pavlyuk on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageLoadingTask;

@protocol ImageLoaderDelegate

- (void)notifyWithTask:(ImageLoadingTask*)task;

@end


@interface ImageLoadingTask : NSOperation
{
	BOOL _isExecuting;
    BOOL _isFinished;
	
	NSIndexPath *indexPath;
	UIImage *image;
	NSString *filename;
	
	NSObject<ImageLoaderDelegate> *delegate;
}

@property (nonatomic, readonly) BOOL isExecuting;
@property (nonatomic, readonly) BOOL isFinished;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *filename;

- (id) initWithDelegate:(NSObject<ImageLoaderDelegate>*)aDelegate;

@end


@interface MovisViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, 
													UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,
													ImageLoaderDelegate>
{
@private
	UIImagePickerController *cameraUI;
	NSString *fileName;
	UITextField *myTextField;
	NSMutableArray *imagesArray;
	NSMutableArray *pathOfVideos;
	UITableView *movisTableView;
	NSDictionary *imagePickerDictionary;
	
	NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) IBOutlet UITableView *movisTableView;

@end
