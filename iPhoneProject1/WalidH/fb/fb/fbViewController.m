//
//  fbViewController.m
//  fb
//
//  Created by Mac on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "fbViewController.h"
#import "FriendListViewController.h"

@implementation fbViewController

@synthesize facebook;

- (void)dealloc
{
    [facebook release];
    [super dealloc];
}

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
    facebook = [[Facebook alloc] initWithAppId:@"145374722149296" andDelegate:self];
    facebook.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey: @ "AccessToken"];
    facebook.expirationDate = (NSDate * ) [[NSUserDefaults standardUserDefaults] objectForKey: @ "ExpirationDate"];
}

- (IBAction)buttonClicked:(id)sender {
    if ([facebook isSessionValid] == NO) 
    { 
        NSArray* permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream", @"read_friendlists", nil];
        [facebook authorize:permissions];
        [permissions release];
    }else{
        NSLog(@"Logged in");
        [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
    }
} 

-(void)fbDidLogin{
    NSLog(@"Test");
    [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	
    NSArray *f = [result objectForKey:@"data"];
    NSMutableArray *fArray=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in f) {
        [fArray addObject:[dic objectForKey:@"name"]];
    }
    
	FriendListViewController *friendListViewController=[[FriendListViewController alloc]initWithNibName:@"FriendListViewController" bundle:nil];
    friendListViewController.data=fArray;
	[self presentModalViewController:friendListViewController animated: YES];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", [error localizedDescription]);
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

@end
