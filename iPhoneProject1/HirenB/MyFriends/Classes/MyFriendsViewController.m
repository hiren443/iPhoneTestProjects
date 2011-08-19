//
//  MyFriendsViewController.m
//  MyFriends
//
//  Created by hiren bhadreshwara on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "MyFriendsAppDelegate.h"

@implementation MyFriendsViewController


@synthesize facebook;
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
	fbBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	fbBtn.frame = CGRectMake(60, 220, 200, 37);
	fbBtn.enabled = TRUE;
	[fbBtn setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
	[fbBtn setTitle:@"View Friend" forState:UIControlStateNormal];
	[fbBtn addTarget:self action:@selector(getMeFriendsButtonPressed:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:fbBtn];
	
	 facebook = [[Facebook alloc] initWithAppId:@"145062165564860"];	
	
}
/* facebook button pressed event */
-(IBAction)getMeFriendsButtonPressed:(id)sender {
	fbBtn.enabled = FALSE;
	NSLog(@"button clicked");
    NSArray* permissions = [[NSArray alloc] initWithObjects:
                            @"publish_stream",@"read_friendlists" ,nil];
    [facebook authorize:permissions delegate:self];
    [permissions release];
}
///@"read_friendlists",
- (void)fbDidLogin {
	NSLog(@"Facebook Did Login");
	
	NSMutableDictionary*params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"4",@"uids", @"name", @"fields", nil];
	
	[facebook requestWithGraphPath:@"me/friends"
                         andParams:params
                     andHttpMethod:@"GET"
                       andDelegate:self];	
}

/* facebook did not log */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

/* request loading sent */
- (void)request:(FBRequest *)request didLoad:(id)result {
	
	MyFriendsAppDelegate *appdelegate = (MyFriendsAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSLog(@"request Did load");
	if ([result isKindOfClass:[NSArray class]]) {
		NSLog(@"Result %@", result);
		result = [result objectAtIndex:0];
		
	}
	NSLog(@"Result of API call: %@", [result objectForKey:@"data"]);
	appdelegate.friendArray = [result objectForKey:@"data"];
	NSLog(@"friend Array %@", appdelegate.friendArray);
	
	UITableView *friendTable =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
	friendTable.delegate = self;
	friendTable.dataSource = self;
	friendTable.backgroundColor = [UIColor whiteColor];
	friendTable.scrollEnabled = YES;
	friendTable.rowHeight = 40;
	[self.view addSubview:friendTable];
	
	
}
/* If facebook fail to get request */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"fail equest");
    NSLog(@"Failed with error: %@", [error localizedDescription]);
}

#pragma mark UITableView delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
	
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	MyFriendsAppDelegate *appdelegate = (MyFriendsAppDelegate *)[[UIApplication sharedApplication] delegate];
	return appdelegate.friendArray.count;
	
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MyFriendsAppDelegate *appdelegate = (MyFriendsAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	static NSString *CellIdentifier;
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil){
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;		
	}	
	
	cell.textLabel.text = [[appdelegate.friendArray objectAtIndex:indexPath.row] objectForKey:@"name"];
	cell.textColor = [UIColor darkGrayColor];	
	
	return cell;
	
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
