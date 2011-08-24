//
//  RootViewController.m
//  FacebookConnect
//
// 
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

/*class extension*/
@interface RootViewController ()
@property(nonatomic,retain)UITableView* myTableView;
@property(nonatomic,retain)UIActivityIndicatorView* spinner;
@property(nonatomic,retain)UIButton* loginButton;
@property(nonatomic,retain)UILabel* statusLabel;
@end

@implementation RootViewController

@synthesize myTableView,spinner,loginButton,statusLabel;
@synthesize arrayOfFriendsData;
#pragma mark -
#pragma mark View lifecycle

static NSString *kAppId= @"246139905408010"; // externalize it!
#define ACCESS_TOKEN_KEY @"fb_access_token"
#define EXPIRATION_DATE_KEY @"fb_expiration_date"



-(void)loadView{
	[super loadView];
}


/*!
 Checks for the facebook session and if the user is logged in it will directly print the friends in the table view.
 The session is stored in userdefaults.
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	facebook =[[ Facebook alloc] initWithAppId:kAppId];
	myTableView=[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
	myTableView.delegate=self;
	myTableView.dataSource=self;
	facebook.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
    facebook.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:EXPIRATION_DATE_KEY];
	statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 70, 200, 100)];
	loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect] ;
	loginButton.frame=CGRectMake(100, 160, 100, 20);
	[loginButton setTitle:@"Login" forState:UIControlStateNormal];
	[loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
	loginButton.hidden=YES;
	[self.view addSubview:statusLabel];
	[self.view addSubview:loginButton];
	if(![facebook isSessionValid]){
		statusLabel.text=@"Please Login First";
		loginButton.hidden=NO;
		//statusLabel.text = NSLocalizedString(@"Please Login First",@"Please Login First");
	}
	else {
		[self fbDidLogin];
	}
		
}

-(void)logout{
	NSLog(@"logout");
	[facebook logout:self];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:nil forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:nil forKey:EXPIRATION_DATE_KEY];
	[defaults synchronize];
	
}

-(void)login{
	[facebook authorize:nil delegate:self];
	
}
/*!
 requests for the friends list from the facebook singleton instance
 */
-(void) fbDidLogout
{
	loginButton.hidden=FALSE;
	myTableView.hidden = TRUE;
	statusLabel.text=@"Pls login first";
	self.navigationItem.rightBarButtonItem = nil;
	NSLog(@"LogedOut");
}
- (void)fbDidLogin {
	loginButton.hidden=YES;
	statusLabel.text=@"Loading Table Data";
	spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.frame=CGRectMake(150,160, 30, 30);
	[self.view addSubview:spinner];
	[spinner startAnimating];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:facebook.accessToken forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:facebook.expirationDate forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];
	self.title=@"Friend List";
	self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
	NSMutableDictionary* params = [NSMutableDictionary 
								   dictionaryWithObjectsAndKeys:@"name,id,picture", @"fields", nil];
	[facebook requestWithGraphPath:@"me/friends" andParams:params andDelegate:self];
}

#pragma mark FBRequestDelegate
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	
}

- (void)request:(FBRequest *)request didLoad:(id)result{
	[spinner stopAnimating];
	if(result!=nil){
	self.arrayOfFriendsData = [result valueForKey:@"data"]; // memory leaked!!!
	//what if result does not have data???
	// always copy in such cases
	// memory leak on refresh
	[self.view addSubview:myTableView];
	}
	
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if([arrayOfFriendsData count]==0) return 1;// check for some error cases dude!!!
	else return[arrayOfFriendsData count];
}


// Customize the appearance of table view cells. And creates an instance of asynchronousimageview to download image asynchronously. 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
    }
	for(UIView* v in [cell.contentView subviews]){
		[v removeFromSuperview];
	}
	NSString* profileId=[[arrayOfFriendsData objectAtIndex:[indexPath row]] valueForKey:@"id"];
	NSString* name=[[arrayOfFriendsData objectAtIndex:[indexPath row]] valueForKey:@"name"];
	NSURL* pictureURL=[[NSURL alloc] initWithString: [[arrayOfFriendsData objectAtIndex:[indexPath row]] valueForKey:@"picture"]];
	UILabel* textLabel=[[UILabel alloc] init];
	textLabel.frame=CGRectMake(100,20, 300, 50);
	textLabel.text=name;
	[cell.contentView addSubview:textLabel];
	[textLabel release];
	AsynchronousImageView* imageView=[[AsynchronousImageView alloc]initWithDelegate:self];
	imageView.frame=CGRectMake(20 ,20 , 50 , 50);
	
	if([profileImages objectForKey:profileId]==nil)
	{	imageView.image=[UIImage imageNamed:@"not_there.jpg"];
		[imageView startImageDownloadWithImageURL:pictureURL andProfileId:profileId];
		
	}
	else 
	{	
		imageView.image=[profileImages objectForKey:profileId];
		
	}
	
	[cell.contentView addSubview:imageView];
	[imageView release];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}
#pragma mark AsynchronousImageViewDelegate
-(void)imageView:(AsynchronousImageView*)imageView withImage:(UIImage*)_profileImage andProfileId:(NSString*)_profileId;
{	
	NSLog(@"%@",_profileId);
	if(profileImages==nil)
	{
		profileImages=[[NSMutableDictionary alloc] init]; 
	}
	[profileImages setObject:_profileImage forKey:_profileId];
}

#pragma mark -
#pragma mark Table view delegate

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    
	[super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
	loginButton=nil;
	statusLabel=nil;

}
- (void)dealloc {
	[spinner release];
	[loginButton release];
	[statusLabel release];
	[myTableView release];
    [super dealloc];
	
}

@end

