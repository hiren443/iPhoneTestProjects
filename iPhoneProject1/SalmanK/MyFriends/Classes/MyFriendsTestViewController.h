/* M Salman Kahlid --Copy righted- certified-
 DO not reuse
 */
#import <UIKit/UIKit.h>
#import "FbGraph.h"

@interface MyFriendsTestViewController : UIViewController <UIWebViewDelegate> {

	FbGraph *fbGraph;

	//we'll use this to store a feed post (when you press 'post me/feed').
	//when you press delete me/feed this is the post that's deleted
	NSString *feedPostId;
	NSMutableArray *allFriendsList;
	UIAlertView *alert;
	NSTimer *time;
	
}

@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSString *feedPostId;



-(IBAction) showFacebookFriends;

@end

