//
//  MainViewController.m
//  MyFriends
//
//  Created by Maxim Pervushin on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
static NSString* kAppId = @"145062165564860";

#import "MainViewController.h"
#import "FriendsTableViewController.h"
#import "JSON.h"

@interface MainViewController()

- (void)initialize;

@end

@implementation MainViewController

@synthesize facebook = _facebook;
@synthesize viewFriendsButton = _viewFriendsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    NSLog(@"initialize");
    
    _facebook = [[Facebook alloc] initWithAppId:kAppId
                                    andDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

- (IBAction)logIn:(id)sender
{
    [_facebook authorize:[NSArray arrayWithObjects:
                          @"read_stream", @"publish_stream", @"offline_access",nil]];
}

// FBSessionDelegate

- (void)fbDidLogin
{
    self.viewFriendsButton.titleLabel.text = @"Loading...";
    [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{

}

// FBRequestDelegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"request: didReceiveResponse:");
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request: didFailWithError:");
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
//    NSLog(@"request: didLoad:%@", result);
    
    FriendsTableViewController* friendsTableViewController = 
    [[FriendsTableViewController alloc] init];
    
    friendsTableViewController.data = [result objectForKey:@"data"];
    [self presentModalViewController:friendsTableViewController animated:YES];
    
    [friendsTableViewController release];

}

- (void)dealloc {
    [_viewFriendsButton release];
    [_facebook release];
    
    [super dealloc];
}
@end
