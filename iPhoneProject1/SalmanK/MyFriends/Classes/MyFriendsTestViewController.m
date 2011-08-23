

/* M Salman Kahlid --Copy righted- certified-
 DO not reuse
 */

#import "MyFriendsTestViewController.h"
#import "SBJSON.h"
#import "FbGraphFile.h"
#import "FriendsListViewController.h"
#import "Friend.h"

@implementation MyFriendsTestViewController

@synthesize fbGraph;
@synthesize feedPostId;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	
}

- (void)dealloc {
	
		[alert release];
	[time release];
	
	
	[fbGraph release];
	[allFriendsList release];
    [super dealloc];
}



#pragma mark -
#pragma mark FbGraph Callback Function
/**
 * This function is called by FbGraph after it's finished the authentication process
 **/
- (void)fbGraphCallback:(id)sender {
	
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
	} else {
		//pop a message letting them know most of the info will be dumped in the log
		UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Sign In" message:@"Successfull Login please wait fetching friends list" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert1 show];
		[alert1 release];
		
		//NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
		
	}
	
}

-(IBAction) showFacebookFriends { 
	
	alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please wait...." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];

	
	time =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getLists) userInfo:nil repeats:NO];
	
}

-(void) getLists {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	/*Facebook Application ID*/
	NSString *client_id =@"145062165564860";//@"209037939151729"; //@"130902823636657";
	
	//alloc and initalize our FbGraph instance
	self.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
	
	//begin the authentication process.....
	
	[self performSelectorOnMainThread:@selector(fetch) withObject:nil waitUntilDone:YES];
	
	
	/**
	 * OR you may wish to 'anchor' the login UIWebView to a window not at the root of your application...
	 * for example you may wish it to render/display inside a UITabBar view....
	 *
	 * Feel free to try both methods here, simply (un)comment out the appropriate one.....
	 **/
	//	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access" andSuperView:self.view];
	[pool release];
	

}

-(void) fetch { 

	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
						 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
	
}
#pragma mark -
#pragma mark  UIAlertView 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
	
	[alert dismissWithClickedButtonIndex:0 animated:NO];
	FbGraphResponse *fb_graph_response = [fbGraph doGraphGet:@"me/friends" withGetVars:nil];
	NSLog(@"getMeFriendsButtonPressed:  %@", fb_graph_response.htmlResponse);
	
	SBJSON *parser = [[SBJSON alloc] init];
	NSDictionary *parsed_json = [parser objectWithString:fb_graph_response.htmlResponse error:nil];	
	[parser release];
	
	//there's 2 additional dictionaries inside this one on the first level ('data' and 'paging')
	NSDictionary *data = (NSDictionary *)[parsed_json objectForKey:@"data"];
	
	//how many wall posts have been returned that meet our search criteria (25 max by default)
	NSLog(@"# search results:  %i", [data count]);
	
	NSEnumerator *enumerator = [data objectEnumerator];
	NSDictionary *wall_post;
	allFriendsList = [[NSMutableArray alloc] init];
	while ((wall_post = (NSDictionary *)[enumerator nextObject])) {
		
		
		NSString *name = (NSString *)[wall_post objectForKey:@"name"];
		NSString *ID = (NSString *)[wall_post objectForKey:@"id"];
		Friend *friend = [[Friend alloc] init];
		friend.ID =ID;
		friend.name= name;
		[allFriendsList addObject:friend];
		[friend release];
	}
	
	FriendsListViewController *friends = [[FriendsListViewController alloc] init];
	friends.friendsList = allFriendsList;
	[self.navigationController pushViewController:friends animated:YES];
	[friends release];
}

@end
