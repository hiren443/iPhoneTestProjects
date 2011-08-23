//
//  FreindsListController.m
//  Facebook
//
//  Created by amina on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FreindsListController.h"


@implementation FreindsListController
@synthesize dataTableView,friends;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFriendLsit:(NSMutableDictionary*)dic{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		//friendsDic=dic;
		NSArray *a=[dic objectForKey:@"data"];
		//friends=[[NSMutableArray alloc] initWithArray:a];
		friends=[[NSArray alloc] initWithArray:a];
	/*	NSLog(@"freiends");
		for (int i=0; i<[a count]; i++) {
			NSDictionary *dic  = [a objectAtIndex:i];
			NSString *name = [dic objectForKey:@"name"];
			NSLog(@"i=%d",i);
			NSLog(@"name=%@",name);	
			[friends addObject:name];
			
		}*/
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	int c=[friends count];
	NSLog(@"%d",c);
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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	
	return [friends count];
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *identifier = @"ident";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell==nil) {
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:identifier];
		
	}

	NSDictionary *dic  = [friends objectAtIndex:indexPath.row];
	NSString *name = [dic objectForKey:@"name"];
	//NSString *name = [friends objectAtIndex:indexPath.row]; 
	NSLog(@"%d",indexPath.row);
	NSLog(@"%@",name);
	cell.textLabel.text= name;
	
	return cell;
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	
}



-(IBAction) dismissMe:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}
@end
