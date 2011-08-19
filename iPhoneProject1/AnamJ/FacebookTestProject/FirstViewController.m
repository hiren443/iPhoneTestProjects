//
//  FirstViewController.m
//  FacebookTestProject
//
//  Created by Saad Mubarak on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "FacebookTestProjectAppDelegate.h"
#import "FirstViewController.h"
#import "RootViewController.h"

@implementation FirstViewController
@synthesize m_facebook;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Friends";
            // Do any additional setup after loading the view from its nib.
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

- (IBAction)viewFriendsPressed:(id)sender {
    if (!m_facebook)
        {
        m_facebook = [[Facebook alloc] initWithAppId:@"145062165564860" andDelegate:[[UIApplication sharedApplication] delegate]];
                      
        }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"])
        {
        m_facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        m_facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
    
    if (![m_facebook isSessionValid])
        {
            // Permissions are customizeable, I will discuss these in a minute
        NSArray* permissions = [NSArray arrayWithObjects:@"read_friendlists",nil];
        [m_facebook authorize:permissions];
        }
    else
        {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [m_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
        }
         
}
- (void) request:(FBRequest *)request didLoad:(id)result
{
    RootViewController *detailViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    detailViewController.friendsArray = [[result valueForKey:@"data"] copy];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];


}

- (void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"error: %@", error);
}


    ////////////////////////////////////////////////////////////////////////////////

@end
