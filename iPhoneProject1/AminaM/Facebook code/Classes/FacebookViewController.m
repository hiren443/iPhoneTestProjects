//
//  FacebookViewController.m
//  Facebook
//
//  Created by amina on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookViewController.h"
#import "FreindsListController.h"
@implementation FacebookViewController
@synthesize facebook,activityView,errorMsg;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//buttonEnable=1;
	facebook = [[Facebook alloc] initWithAppId:@"145062165564860"
                                    andDelegate:self];
	
	
}

-(void) getFriends{
	
	
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self]; 
	
}
/**
 * Show the authorization dialog.
 */
- (IBAction)showFriends {
	//an empty string array as we dont need any permission
	//if (buttonEnable==1) {
		//buttonEnable++;
		self.activityView.hidden=NO;
		NSArray *permissions =  [[NSArray arrayWithObjects:
								  @"",nil] retain];
		
		
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if ([defaults objectForKey:@"FBAccessTokenKey"] 
			&& [defaults objectForKey:@"FBExpirationDateKey"]) {
			facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
			facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
		}
		
		if (![facebook isSessionValid]) {
			[facebook authorize:permissions];
		}
		[self getFriends];
		
	//}
	
	
			
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	
	NSString *errorMSg= [error localizedDescription];
	errorMSg=[NSString stringWithFormat:@"%@; Try Again",errorMSg];
	[self.errorMsg setText:errorMSg];
	
	self.errorMsg.hidden=NO;
	self.activityView.hidden=YES;
	//NSLog(@"error");
}
- (void)request:(FBRequest*)request didLoad:(id)result {
	//NSLog(@"getFreinds");
	NSMutableDictionary *dic=result;
	
	FreindsListController *controller=[[FreindsListController alloc] initWithNibName:@"FreindsListController" bundle:nil withFriendLsit:dic];
	[self presentModalViewController:controller animated:YES];
	
}
- (void) processFriendsQuery:(id) result{
	//friends = [[NSMutableArray alloc] init];
    //NSString * element; 
    
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
