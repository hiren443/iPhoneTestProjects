//
//  FriendsViewController.m
//  Friends
//
//  Created by mac on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendListViewController.h"

#define _APP_KEY @"145062165564860"
#define _SECRET_KEY @"09d5ff4260a342ea3012cf2888e47d4e"

@implementation FriendsViewController
@synthesize usersession;
@synthesize username;
@synthesize post,appDelegate,activityIndicator;


-(IBAction)PartageFacebook:(id)sender;
{
	//	appDelegate =(Shems_FMAppDelegate *)[[UIApplication sharedApplication]delegate];
	
	if (appDelegate._session == nil){
		appDelegate._session = [FBSession sessionForApplication:_APP_KEY 
														 secret:_SECRET_KEY delegate:self];
	}
	
	[appDelegate._session resume];
	
	if (!appDelegate._session.isConnected) {
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:appDelegate._session] autorelease];
		[dialog show];
	}
	
	activityIndicator.hidden = NO;
	[activityIndicator startAnimating];
	
}




- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	self.usersession =session;
    NSLog(@"User with id %lld logged in.", uid);
	[self getFacebookName];
}

- (void)getFacebookName {
//NSString* fql = [NSString stringWithFormat:@"select uid,name from user where uid == %lld", self.usersession.uid];
	
NSString* fql = [NSString stringWithFormat:@"SELECT uid, name from user where uid IN (SELECT uid2 FROM friend WHERE uid1=%lld)",  self.usersession.uid];
	
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
	self.post=YES;
}

- (void)request:(FBRequest*)request didLoad:(id)result {
	
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		self.username = name;		
		
		if (self.post) {
		//[self postToWall];
		NSLog(@"%d amis",[users count]);
FriendListViewController *ListViewController= [[FriendListViewController  alloc] initWithNibName:@"FriendListViewController" bundle:[NSBundle mainBundle]];
    [ListViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	ListViewController.usersArray=users;
	[self presentModalViewController:ListViewController  animated:YES];
	self.post = NO;
			
		}
	}
}


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
	activityIndicator.hidden = YES;
	appDelegate= (FriendsAppDelegate *)[[UIApplication sharedApplication] delegate];
	
}

- (void) viewWillAppear:(BOOL)animated
{
	activityIndicator.hidden = YES;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
