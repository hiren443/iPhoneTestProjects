//
//  FriendsListViewController.m
//  My Friends
//
//  Created by Manish Patel on 16/08/11.
//  Copyright 2011 MacyMind. All rights reserved.
//

#import "FriendsListViewController.h"
#import "Global.h"
#import "LoadingScreen.h"

@implementation FriendsListViewController


#pragma mark -
#pragma mark View lifecycle

- (void)addLogoutButton
{
	UIBarButtonItem *btnLogout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(onLogout:)];
	self.navigationItem.rightBarButtonItem = btnLogout;
	[btnLogout release];
}

- (void)viewDidLoad
{
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"My Friends";
	[self addLogoutButton];
	[[LoadingScreen sharedInstance] startLoadingScreenWithTitle:@"Loading friends..."];
	[[SharedManager sharedInstance] getFriendList:self];
	[super viewDidLoad];
}

- (void)onLogout:(id)sender
{
	[[LoadingScreen sharedInstance] startLoadingScreenWithTitle:@"Please wait..."];
	[[SharedManager sharedInstance] logoutWithDelegate:self];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [friendsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.textLabel.text = [friendsList objectAtIndex:indexPath.row];
	
	return cell;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
}


- (void)dealloc
{
	[friendsList release];
	[super dealloc];
}


#pragma mark -
#pragma mark SharedManager Login delegates
#pragma mark -


- (void)sharedManager:(SharedManager *)sharedManager failedLoginWithError:(NSError *)error
{
	[[LoadingScreen sharedInstance] dismissLoadingScreen];
	[Global showAlert:@"Oops!" message:[error localizedDescription]];
}

- (void)sharedManagerDidLogout:(SharedManager *)sharedManager
{
	[[LoadingScreen sharedInstance] dismissLoadingScreen];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark SharedManager Friends delegates

- (void)sharedManager:(SharedManager *)sharedManager didLoadFriedList:(NSArray *)friends
{
	friendsList = [[[friends valueForKey:@"name"] sortedArrayUsingSelector:@selector(compare:)] retain];
	if([friendsList count] <= 0)
	{
		[Global showAlert:@"My Friends" message:@"No friends found."];
	}
	[self.tableView	reloadData];
	[[LoadingScreen sharedInstance] dismissLoadingScreen];
}

- (void)sharedManager:(SharedManager *)sharedManager failedWithError:(NSError *)error
{
	[[LoadingScreen sharedInstance] dismissLoadingScreen];
	[Global showAlert:@"Oops!" message:[error localizedDescription]];
}



@end

