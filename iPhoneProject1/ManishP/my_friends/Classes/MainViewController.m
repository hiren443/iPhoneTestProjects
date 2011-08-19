//
//  MainViewController.m
//  My Friends
//
//  Created by Manish Patel on 16/08/11.
//  Copyright 2011 MacyMind. All rights reserved.
//

#import "MainViewController.h"
#import "SharedManager.h"
#import "Global.h"
#import "FriendsListViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
	//self.navigationItem.hidesBackButton = YES;
	[super viewDidLoad];
	if([[SharedManager sharedInstance].facebookAccessToken length] > 0)
	{
		[[SharedManager sharedInstance] loginWithFacebookDelegate:self];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}


- (void)dealloc
{
	[super dealloc];
}


#pragma mark -
#pragma mark Event handlers
#pragma mark -

- (IBAction)onFriends:(id)sender
{
	[[SharedManager sharedInstance] loginWithFacebookDelegate:self];
}



#pragma mark -
#pragma mark LoginDelegates
#pragma mark -

- (void)sharedManager:(SharedManager *)sharedManager failedLoginWithError:(NSError *)error
{
	//NSLog(@"error: %@", error);
	[Global showAlert:@"Oops!" message:[error localizedDescription]];
}

- (void)sharedManagerDidLogin:(SharedManager *)sharedManager
{
	NSLog(@"Login success");
	
	FriendsListViewController *flvc = [[FriendsListViewController alloc] initWithNibName:@"FriendsListView" bundle:nil];
	[self.navigationController pushViewController:flvc animated:YES];
	[flvc release];
}


@end
