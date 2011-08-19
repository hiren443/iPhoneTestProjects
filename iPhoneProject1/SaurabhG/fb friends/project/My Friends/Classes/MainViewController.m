    //
//  MainViewController.m
//  My Friends
//
//  Created by Saurabh on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "FBConnect.h"
#import "FBLoginDialog.h"
#import "FriendsTable.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
// This application will not work until you enter your Facebook application's API key here:

static NSString* kApiKey = @"145062165564860";

// Enter either your API secret or a callback URL (as described in documentation):
static NSString* kApiSecret = @"09d5ff4260a342ea3012cf2888e47d4e"; // @"<YOUR SECRET KEY>";
static NSString* kGetSessionProxy = nil; // @"<YOUR SESSION CALLBACK)>";

//////////////////////////////////////////////////

@implementation MainViewController

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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	friendsArray =[[NSMutableArray alloc]init];
	
	UILabel *mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 30, 200, 70)];
	mainLabel.text=@"My Friends";
	mainLabel.backgroundColor=[UIColor clearColor];
	mainLabel.font=[UIFont boldSystemFontOfSize:26];
	[self.view addSubview:mainLabel];
	
	UIButton *done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	done.frame = CGRectMake(28.0f,150.0f, 264.0f, 38.0f);
	[done setTitle:@"Find Friends" forState:UIControlStateNormal];
	
	[done addTarget:self action:@selector(fbConnectMethod) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:done];
	
	tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped]; 
	tableView.dataSource=self;
	tableView.delegate=self;
	[self.view addSubview:tableView];
	tableView.hidden=YES;
	
	
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [friendsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
	cell.textLabel.text=[friendsArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return @"My Friends";
	
	
	
}


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



#pragma mark FaceBook method

-(void)fbConnectMethod
{
	
	if (kGetSessionProxy) {
		//_session = [[FBSession sessionForApplication:kApiKey getSessionProxy:kGetSessionProxy
		//delegate:self] retain];
		_session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
		
    } else {
		_session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
    }
	
	
	
	
	if (_session.isConnected) {
		[_session logout];
		[_session deleteFacebookCookies];
		//FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:_session] autorelease];
		//[dialog show];
	} else {
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:_session] autorelease];
		[dialog show];
	}
	
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBSessionDelegate

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	
	
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld", session.uid];
	
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.friends.get" params:params];
	NSLog(@"Result 1. %@",params);
	
	
		
	
	}

- (void)sessionDidNotLogin:(FBSession*)session {
	//_label.text = @"Canceled login";
	NSLog(@"Cancelled");
}

- (void)sessionDidLogout:(FBSession*)session {
	NSLog(@"Disconnected");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/*- (void)request:(FBRequest*)request1 didLoad:(id)result {
	if ([request1.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		NSLog(@"Result 11 %@",user);
		NSLog(@"%@",name);
		//_label.text = [NSString stringWithFormat:@"Logged in as %@", name];
	} else if ([request1.method isEqualToString:@"facebook.users.setStatus"]) {
		NSString* success = result;
		if ([success isEqualToString:@"1"]) {
			//_label.text = [NSString stringWithFormat:@"Status successfully set"]; 
		} else {
			//_label.text = [NSString stringWithFormat:@"Problem setting status"]; 
		}
	} else if ([request1.method isEqualToString:@"facebook.photos.upload"]) {
		NSDictionary* photoInfo = result;
		NSString* pid = [photoInfo objectForKey:@"pid"];
		NSLog(@"%@",pid);
		//_label.text = [NSString stringWithFormat:@"Uploaded with pid %@", pid];
	}
}*/

- (void)request:(FBRequest*)request didLoad:(id)result {
	if(myList==nil) {
		NSArray* users = result;
		myList =[[NSArray alloc] initWithArray: users];
		for(NSInteger i=0;i<[users count];i++) {
			NSDictionary* user = [users objectAtIndex:i];
			NSString* uid = [user objectForKey:@"uid"];
			NSString* fql = [NSString stringWithFormat:
							 @"select name from user where uid == %@", uid];
			
			NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
			[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
		}
		NSLog(@"Array.. %@",users);
	}
	else {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		NSLog(@"%@",name);
		NSLog(@"Array.. %@",users);
		[friendsArray addObject:name];
		
		//txtView.text=[NSString localizedStringWithFormat:@"%@%@,\n",txtView.text,name];
	}
	NSLog(@"Main Array %@",friendsArray);
	[tableView reloadData];
	tableView.hidden=NO;
}

- (void)request:(FBRequest*)request1 didFailWithError:(NSError*)error {
	//_label.text = [NSString stringWithFormat:@"Error(%d) %@", error.code,
	// error.localizedDescription];
}

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
    NSLog(@"did r response");
}



@end
