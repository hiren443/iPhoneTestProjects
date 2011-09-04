//
//  FriendsViewController.m
//  Movis2
//
//  Created by Eugene Pavlyuk on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController.h"
#import "Friend.h"
#import "ShareViewController.h"

@implementation FriendsViewController

@synthesize friends;
@synthesize sortedFriends;
@synthesize sections;
@synthesize friendsTableView;
@synthesize shareViewController;

- (void)sortFriends
{
	[self.sortedFriends removeAllObjects];
	[self.sections removeAllObjects];
	
	if ([self.friends count] > 0)
	{
		Friend *firstFriend = [self.friends objectAtIndex:0];
		
		NSRange range;
		range.length = 1;
		range.location = 0;
		
		NSString *firstCharacter = [firstFriend.name substringWithRange:range];
		
		NSMutableArray *currentArray = [NSMutableArray array];
		[currentArray addObject:firstFriend];
		[self.sortedFriends addObject:currentArray];
		[self.sections addObject:firstCharacter];
		
		for (int i = 1; i < [self.friends count]; i++)
		{
			Friend *nextFriend = [self.friends objectAtIndex:i];
			
			NSString *nextCharacter = [nextFriend.name substringWithRange:range];
			
			if (![nextCharacter isEqualToString:firstCharacter])
			{
				firstCharacter = [NSString stringWithString:nextCharacter];
				currentArray = [NSMutableArray array];
				[self.sortedFriends addObject:currentArray];
				[self.sections addObject:firstCharacter];
			}
			
			[currentArray addObject:nextFriend];
		}
	}
}

- (void) setFriends:(NSMutableArray *)newFriends
{
	if (newFriends != friends)
	{
		[friends release];
		friends = newFriends;
		[friends retain];
		
		[self sortFriends];
	}
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.sortedFriends = [NSMutableArray array];
		self.sections = [NSMutableArray array];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel button title") 
																			 style:UIBarButtonItemStyleBordered 
																			target:self 
																			 action:@selector(cancelButtonPressed)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done button title") 
																			  style:UIBarButtonItemStyleDone 
																			 target:self 
																			 action:@selector(doneButtonPressed)] autorelease];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.friendsTableView = nil;
}


- (void)dealloc 
{
	self.friends = nil;
	self.sections = nil;
	self.sortedFriends = nil;
	self.friendsTableView = nil;
	self.shareViewController = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark IBOutlet's methods

- (void) cancelButtonPressed
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) doneButtonPressed
{
	BOOL friendsSelected = NO;
	
	for (Friend *friend in self.friends)
	{
		if (friend.selected)
		{
			friendsSelected = YES;
			break;
		}
	}
	
	if (!friendsSelected)
	{
		[[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning!", @"Warning") 
								   message:NSLocalizedString(@"Select at least one friend", @"error message") 
								  delegate:nil 
						 cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
						  otherButtonTitles:nil] autorelease] show];
	}
	else
	{
		[self.shareViewController continueShareForFriends];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark UITableViewDelegate's methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *array = [self.sortedFriends objectAtIndex:indexPath.section];
	
	Friend *friend = [array objectAtIndex:indexPath.row]; 
	
	friend.selected = !friend.selected;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}	


#pragma mark -
#pragma mark UITableViewDataSource's methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.sortedFriends count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *array = [self.sortedFriends objectAtIndex:section];
	
	return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.sections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
	}
	
	NSArray *array = [self.sortedFriends objectAtIndex:indexPath.section];
	
	Friend *friend = [array objectAtIndex:indexPath.row];
	cell.textLabel.text = friend.name;
	
	if (friend.selected)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else 
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}


@end
