//
//  AsynchronousImageDownloader.h
//  FacebookConnect
//
//  
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"



@protocol AsynchronousImageViewDelegate;

/*!
 @class		AsynchronousImageDownloader
 @brief		Downloads the profile pictures of friends from facebook
 @details	Asynchronously downloads the images of friends and sets image field once downloaded.
 */
@interface AsynchronousImageView : UIImageView {
	/*!
	 @brief  adress of the profile picture sepecific to the facebook profile id
	 */
	NSURL* url;
	/*!
	 @brief facebook profile id
	 */
	NSString* profileId;
	/*!
	 @brief delegate
	 */
	id delegate;
	}

/*!
 @brief			Designated initializer
 @details		Creates an instance, and initialize the fields.
 @param			Url to dowload the image from
 @param			Facebook profile id of the friend 
 @return		An instance of AsynchronousImageView
 */
-(id)initWithDelegate:(id)_delegate;

/*!
 @brief			Starts the image downloading when called according to the imageURL
 */
-(void)startImageDownloadWithImageURL:(NSURL*)_url andProfileId:(NSString*)_profileId;


@property(nonatomic,retain)NSURL* url;
@property(nonatomic,retain)id delegate;
@property(nonatomic,retain)NSString* profileId;
@end

/*!
@brief the class implementing this protocol would be recieving the images with the profile id once the download completes.
 */
@protocol AsynchronousImageViewDelegate
/*!
 @brief			Called when image gets downloaded
 @param			The imageview instance which calls this function
 @param			The image which was downloaded
 @param			The profile id for which the image was downloaded
 @return		void
 */
-(void)imageView:(AsynchronousImageView*)imageView withImage:(UIImage*)_profileImage andProfileId:(NSString*)_profileId;
@end