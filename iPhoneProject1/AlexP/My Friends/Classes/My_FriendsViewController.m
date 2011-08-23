//
//  My_FriendsViewController.m
//  My Friends
//
//  Created by naceka on 21.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "My_FriendsViewController.h"
#import "FBConnect.h"
#import "My_FriendsAppDelegate.h"

static NSString *kAppID = @"145062165564860";

@implementation My_FriendsViewController

@synthesize facebook;
@synthesize permissions;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	facebook = [[Facebook alloc] initWithAppId:kAppID andDelegate:self];
	permissions = [[NSArray arrayWithObjects:@"read_stream", nil] retain];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction) buttonShowFriends:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults objectForKey:@"FBAccessTokenKey"]
	   && [defaults objectForKey:@"FBExpirationDateKey"]){
		facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
		facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
	if(![facebook isSessionValid]){
		[facebook authorize:permissions];
	} else {
		[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
	}
	//[facebook logout:self];
}

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	NSLog(@"logged in");
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
	[defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
	[defaults synchronize];
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	NSLog(@"logout");
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}


- (void)request:(FBRequest *)request didLoad:(id)result {
	My_FriendsAppDelegate *app = (My_FriendsAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *users = [result objectForKey:@"data"];
	NSMutableArray *data = [[[NSMutableArray alloc] init] autorelease];
	for (NSInteger i=0; i<[users count]; i++) {
			NSDictionary *user = [users objectAtIndex:i];
			[data addObject: (NSString*)[user objectForKey:@"name"]];
			 NSLog(@"%@", (NSString*)[user objectForKey:@"name"]);	
	}
	app.data = data;
	[self presentModalViewController:friends animated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	permissions = nil;
	friends = nil;
	bfrnds = nil;
	facebook = nil;
}


- (void)dealloc {
	[friends release];
	[permissions release];
	[bfrnds release];
	[facebook release];
    [super dealloc];
}

@end
