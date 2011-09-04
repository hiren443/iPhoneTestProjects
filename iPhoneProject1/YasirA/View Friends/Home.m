//
//  Home.m
//  View Friends
//
//  Created by uraan on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Home.h"
#import "FaceBookLogin.h"

@implementation Home

- (IBAction) clickViewFriendsList{
	NSArray* permissions =  [[NSArray arrayWithObjects:@"read_stream",@"email", @"offline_access", @"publish_stream",nil] retain];	
	facebook = [[Facebook alloc] initWithAppId:@"145062165564860"];
	facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
	facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];
	if (![facebook isSessionValid]) {
		NSLog(@"invalid");
		[facebook authorize:permissions delegate:self];
	}
	else {
		NSLog(@"valid");
		
		if ([facebook isSessionValid]) {
			[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
			//[facebook authorize:permissions delegate:self];
			
		}
		
		
	}
	[permissions release];
	
	
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)requestLoading:(FBRequest *)request {
	
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	
}

/**
 * Called when a request returns and its response has been parsed into an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	NSLog(@"%@",result);
	FaceBookLogin *controller = [[FaceBookLogin alloc] init];
	//controller.currentCampus = [PUCampuses objectAtIndex:indexPath.row];
	//controller.friendsList = result;
	controller.friendsList = [[NSMutableArray alloc] init];
	[controller.friendsList addObjectsFromArray:[result objectForKey:@"data"]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller	 autorelease];
	/*if ([result isKindOfClass:[NSArray class]]) {
	 //
	 }
	 else {
	 [friendsList addObjectsFromArray:[result objectForKey:@"data"]];
	 if ([friendsList count] > 0) {
	 [fbFriendsTableView reloadData];
	 }
	 }*/
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data {
	
}

#pragma mark -
#pragma mark  FACEBOOK DELEGATE
- (void) fbDidLogin{
	NSLog(@"login in....%@",facebook);
	NSLog(@"token     :%@",facebook.accessToken);
	NSLog(@"exp     :%@",facebook.expirationDate);
	
	[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"AccessToken"];
	[[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:@"ExpirationDate"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
	
	//[self getUserFacebookInfo];
}
-(void) fbDidLogout{
	NSLog(@"no login in....");
}
- (void) fbDidNotLogin:(BOOL)cancelled{
	NSLog(@"login error....");
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
