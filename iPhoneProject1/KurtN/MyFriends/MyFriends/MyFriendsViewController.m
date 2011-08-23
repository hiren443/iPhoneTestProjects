//
//  MyFriendsViewController.m
//  MyFriends
//
//  Created by Kurt Niemi on 8/20/11.
//  Copyright 2011 22nd Century Software, LLC. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "MyFriendTableViewController.h"

@implementation MyFriendsViewController

@synthesize facebook;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    facebook = [[Facebook alloc] initWithAppId:@"145062165564860" andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)myFriendButtonClicked:(id)sender {

    if (![facebook isSessionValid]) {
        NSArray* permissions = [[NSArray alloc] initWithObjects:
                                nil];
        [facebook authorize:permissions];
        [permissions release];    
    }
    else
    {
        // call did login method - to request friends
        [self fbDidLogin];
    }
}
- (void)fbDidLogin {
    NSLog(@"Logged in!!!");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    
    [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    
    // Parse results
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
    
    // Log for debugging
	NSLog(@"Result of API call: %@", result);

    // Display friend controller modally
    // For this app a NavigationController is not needed
    MyFriendTableViewController *controller = [[MyFriendTableViewController alloc] initWithNibName:@"MyFriendTableViewController" bundle:nil];
    
    // assign friend array
    controller.friendArray = [result objectForKey:@"data"];
    [controller.friendArray retain];
    
    [self presentModalViewController:controller animated:TRUE];
    
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", [error localizedDescription]);
}

@end
