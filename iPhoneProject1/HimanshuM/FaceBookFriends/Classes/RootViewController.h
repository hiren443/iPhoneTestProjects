//
//  RootViewController.h
//  FacebookConnect
//
// 
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "AsynchronousImageView.h"
/*!
 @class		RootViewController
 @brief		Main view controller that manages the table view
 @details	First let user log in to facebook and then displays the friend list in a tableView and Asynchronously downloads the images associated with their profiles
 */

@interface RootViewController:UIViewController<FBRequestDelegate,
FBDialogDelegate,FBSessionDelegate,UITableViewDataSource,UITableViewDelegate,AsynchronousImageViewDelegate> {
	/*!
	@brief facebook The facebook instance
	*/
	Facebook* facebook;
	/*!
	 @brief arrayOfFriends Stores the data as an array of dictionaries, dictionary having the friend's name,profile_id and image_url.
	 */
 	NSMutableArray* arrayOfFriendsData; 
	/*!
	 @brief profileImages key->fb profilelId and valus->profile picture
	 */
	NSMutableDictionary* profileImages; 
	
	NSMutableArray *_permissions;
}

@property(nonatomic,copy)NSMutableArray *arrayOfFriendsData;
@end
