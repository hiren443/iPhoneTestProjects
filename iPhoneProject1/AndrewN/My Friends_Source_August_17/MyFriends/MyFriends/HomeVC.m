//
//  HomeVC.m
//  MyFriends
//
//  Created by The Linh NGUYEN on 8/17/11.
//  Copyright 2011 Hirevietnamese Co. Ltd. All rights reserved.
//

#import "HomeVC.h"
#import "GlobalVariables.h"

@implementation HomeVC

@synthesize session = _session;
@synthesize loginDialog = _loginDialog;
@synthesize friends = _friends;
@synthesize btnLogin = _btnLogin;
@synthesize tbvFriends = _tbvFriends;

- (void)dealloc
{
    [_session release];
	_session = nil;
    [_loginDialog release];
	_loginDialog = nil;
    [_friends release];
    _friends = nil;
    [_btnLogin release];
    _btnLogin = nil;
    [_tbvFriends release];
    _tbvFriends = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // config facebook APIS
    _session = [[FBSession sessionForApplication:FB_API_KEY secret:FB_SECRET_KEY delegate:self] retain];    
	// Load a previous session from disk if available.
	[_session resume];    
    [super viewDidLoad];
    // set title
    self.title = APP_NAME;
    // init variables
    _friends = [[NSMutableArray alloc] init];
    // set hide friend list
    [_tbvFriends setHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Get Facebook Name Helper

- (void) getFriendList {
	NSString* fql = [NSString stringWithFormat:@"SELECT name,uid FROM user WHERE uid IN ( SELECT uid2 FROM friend WHERE uid1=%lld )",_session.uid];
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
}

#pragma mark FBSessionDelegate methods

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	[self getFriendList];
}

- (void)session:(FBSession*)session willLogout:(FBUID)uid {
    // hide friend list
	[_tbvFriends setHidden:YES];
    // hide logout button
    self.navigationItem.rightBarButtonItem = nil;
    // show login button
    [_btnLogin setHidden:NO];
}

#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
        for (NSDictionary* user in users) {
            NSString* name = [user objectForKey:@"name"];
            [_friends addObject:name];
            //[name release];
            // Hide login button
            [_btnLogin setHidden:YES];
            // show friend list
            [_tbvFriends setHidden:NO];
            // set logout button at right
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:(UIBarButtonItemStyleBordered) target:self action:@selector(doLogout:)] autorelease];
            // reload table view
            [_tbvFriends reloadData];
        }
	}
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_friends == nil || [_friends count] == 0) {
        return 0;
    } else {
        return [_friends count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    if (cell == nil) { 
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease]; 
    }
    NSString *name = [_friends objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;    
}

#pragma mark - privates methods
// handler login action
- (IBAction) doLogin:(id) sender 
{
    if (![_session isConnected]) {
		self.loginDialog = nil;
		_loginDialog = [[FBLoginDialog alloc] init];	
		[_loginDialog show];	
	} else if (_friends != nil) {
		[_tbvFriends reloadData];
	}
}

// handler logout action
- (IBAction) doLogout:(id) sender
{
    [_session logout];
}
@end
