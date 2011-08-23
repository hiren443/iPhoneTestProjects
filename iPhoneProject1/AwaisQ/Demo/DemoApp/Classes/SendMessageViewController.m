//
//  SendMessageViewController.m
//  Status Shuffler
//
//  Created by Awais Macbook on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendMessageViewController.h"
#import "DemoAppAppDelegate.h"
#import "JSON.h"

@implementation SendMessageViewController
@synthesize friendlist;
@synthesize statusMessage,delegate;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithFriendList:(NSMutableDictionary*)list WithMessage:(NSString*)message
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.friendlist = list;
		self.statusMessage = message;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
	dataArray = [[NSMutableArray alloc] init];
	NSArray *objects = (NSArray*)[self.friendlist objectForKey:@"data"];
	for(id person in objects)
	{
		[dataArray addObject:person];
	}
	if ([dataArray count]==0) {
		[self.delegate dismissModalViewControllerAnimated:YES];
	}
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];  
	UIButton *btnClear=[UIButton buttonWithType: UIButtonTypeCustom];
	btnClear.frame=CGRectMake(0,0,320,60);
	[btnClear setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
	[btnClear addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
	
	[view addSubview:btnClear];
	self.tableView.tableHeaderView=view;

}

-(void)dismiss
{
	[self.delegate dismissModalViewControllerAnimated:YES];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
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
	if ([dataArray count]==0) {
		[self.delegate dismissModalViewControllerAnimated:YES];
	}
	return [dataArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [dict objectForKey:@"name"];
    // Configure the cell...
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

