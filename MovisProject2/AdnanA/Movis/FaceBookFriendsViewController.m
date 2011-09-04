//
//  FaceBookFriendsViewController.m
//  MyFriends
//
//  Created by Adnan Ahmad on 8/16/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import "FaceBookFriendsViewController.h"
#import "FriendsCustomCell.h"
#import "MovisAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "StorageUrlClassViewController.h"
#import "Loading.h"
@implementation FaceBookFriendsViewController

@synthesize faceBookFriendsNsMutableArray,imageDownloadsInProgress,friendTableView,selectedIndex,urlPathForVideo,myProgressIndicator,activity;
@synthesize arrSelectedFriends;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [activity release];
    [imageDownloadsInProgress release];
    [faceBookFriendsNsMutableArray release];
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

    self.title=@"Friends";
    imageDownloadsInProgress=[[NSMutableDictionary alloc]init];
    self.navigationItem.hidesBackButton=YES;    
    
    UIBarButtonItem *home = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Back"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = home;
    [home release];
    

    faceBookFriendsNsMutableArray=[[NSMutableArray alloc]init];
    
    MovisAppDelegate *appDelegate=(MovisAppDelegate *)[[UIApplication sharedApplication]delegate];
    faceBookFriendsNsMutableArray=appDelegate.friendsMutableArray;
    
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc] 
                             initWithTitle:@"Share Video"                                            
                             style:UIBarButtonItemStyleBordered 
                             target:self 
                             action:@selector(shareVideoWithFriend)];
    self.navigationItem.rightBarButtonItem = share;
    [share release];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [faceBookFriendsNsMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
      
        static NSString *CellIdentifier = @"FriendsCustomCell";
        FriendsCustomCell *cell = (FriendsCustomCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FriendsCustomCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (FriendsCustomCell*) currentObject;
                    break;
                }
            }
        }
        
        
        CALayer * l = [cell.imageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        // You can even add a border
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
    
    
    
  //  if (indexPath.row == _radioSelection)cell.accessoryType = UITableViewCellAccessoryCheckmark;

    
    cell.name.text=[[faceBookFriendsNsMutableArray  objectAtIndex:indexPath.row] objectForKey:@"name"]; 
    
    
    if (![[faceBookFriendsNsMutableArray objectAtIndex:indexPath.row] objectForKey:@"image"])
    {
        if (self.friendTableView.dragging == NO && self.friendTableView.decelerating == NO)
        {
            [self startIconDownload:[faceBookFriendsNsMutableArray  objectAtIndex:indexPath.row] forIndexPath:indexPath];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"review.png"];                
        
    }
    else
    {
        
        cell.imageView.image = [[faceBookFriendsNsMutableArray objectAtIndex:indexPath.row] objectForKey:@"image"];
        
    }
    

    
    NSMutableDictionary *item = [faceBookFriendsNsMutableArray objectAtIndex:indexPath.row];
    
    [item setObject:cell forKey:@"cell"];
    
    BOOL checked = [[item objectForKey:@"checked"] boolValue];
    
    NSLog(@"value of check is %d",checked);
    UIImage *image =(checked)?[UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(8.0, 76.0, 30, 22);
    button.frame = frame;	// match the button's size with the image size
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    // set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
        
        
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

   // _radioSelection = indexPath.row;
    
    
    
    
    [self tableView: friendTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];    
    
    
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:friendTableView];
	NSIndexPath *indexPath = [friendTableView indexPathForRowAtPoint: currentTouchPosition];
	NSLog(@"index Path is %d",indexPath.row);
	if (indexPath != nil)
	{
		[self tableView:friendTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{	
           NSMutableDictionary *item = [faceBookFriendsNsMutableArray objectAtIndex:indexPath.row];
        BOOL checked = [[item objectForKey:@"checked"] boolValue];
        NSLog(@"checked value id %d",checked);
        
        [item setObject:[NSNumber numberWithBool:!checked] forKey:@"checked"];
        NSLog(@"checked value id %d",checked);
        
        UITableViewCell *cell = [item objectForKey:@"cell"];
        UIButton *button = (UIButton *)cell.accessoryView;
        
        UIImage *newImage = (checked) ? [UIImage imageNamed:@"unchecked.png"] : [UIImage imageNamed:@"checked.png"];
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
}

#pragma mark -
#pragma mark Start Custom Functions
#pragma mark -
- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}
// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([faceBookFriendsNsMutableArray count] > 0)
    {
        NSArray *visiblePaths = [friendTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths){
            if(indexPath.row < [faceBookFriendsNsMutableArray  count]){
                NSMutableDictionary *appRecord = [faceBookFriendsNsMutableArray  objectAtIndex:indexPath.row];
                
                if (![appRecord objectForKey:@"image"]) // avoid the app icon download if the app already has an icon
                {
                    [self startIconDownload:appRecord forIndexPath:indexPath];
                }
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
        IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
        if (iconDownloader != nil)
        {
            FriendsCustomCell *cell =(FriendsCustomCell*)[friendTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
            cell.imageView.image = [iconDownloader.appRecord objectForKey:@"image"];
            
        }
        
    
}

#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        [self loadImagesForOnscreenRows];
        
    
}
-(void)backAction
{

    [self.navigationController popViewControllerAnimated:YES];
}




-(void)shareVideoWithFriend
{
    
    
    if(activity == nil)
        activity = [[Loading alloc] initWithNibName:@"Loading" bundle:[NSBundle mainBundle]];
    
    [self.view insertSubview:activity.view aboveSubview:self.parentViewController.view];
    [activity.activityIndicator startAnimating];
    
    
   // MovisAppDelegate *appDelegate=(MovisAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    ///Adding progressView
    
    
    
    myProgressIndicator=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    myProgressIndicator.frame=CGRectMake(10, 260, 300, 14);
    [self.view addSubview:myProgressIndicator];

    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    
    NSString *strGO;
	strGO = @"";
	NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
	
    
    for(int i=0;i<[faceBookFriendsNsMutableArray count];i++)
    {
        
        if ([[[faceBookFriendsNsMutableArray objectAtIndex:i]objectForKey:@"checked"] intValue] == 1)
        {
            temp = [faceBookFriendsNsMutableArray objectAtIndex:i];
            NSString *str = [temp objectForKey:@"id"];
            strGO = [strGO stringByAppendingString:[NSString stringWithFormat:@"@[%@:] ",str]];

            
        }
    }
    [strGO retain];
	
	NSURL *url = [NSURL URLWithString:@"https://graph-video.facebook.com/me/videos?"];
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [pref objectForKey:@"path"];
    NSURL *urlVideo = [NSURL fileURLWithPath:uniquePath];
    
    NSData *dataVideo = [NSData dataWithContentsOfURL:urlVideo];
    [newRequest addFile:dataVideo withFileName:@"test.mp4" andContentType:@"multipart/form-data" forKey:@"post_url"];
    NSString *str = [[[pref objectForKey:@"title"] componentsSeparatedByString:@"."] objectAtIndex:0];
    
    [newRequest setPostValue:str forKey:@"title"];
    [newRequest setPostValue:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/movis/id455509395?ls=1&mt=8  %@",strGO] forKey:@"description"];
	[newRequest setPostValue:strGO forKey:@"message"];
	
    //NSArray *arr = [app.act componentsSeparatedByString:@"&"];
    // _accessToken = [arr objectAtIndex:0] ;
	[newRequest setPostValue:[pref objectForKey:@"FBAccessTokenKey"] forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(shareVideoWithFriendFinished:)];
    [newRequest setDidFailSelector:@selector(uploadVideoFail:)];
    
    [newRequest setUploadProgressDelegate:myProgressIndicator];
    [newRequest setShowAccurateProgress:YES];

    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
	
}
- (void)shareVideoWithFriendFinished:(ASIHTTPRequest *)request
{
	[myProgressIndicator removeFromSuperview];
    [activity.activityIndicator stopAnimating];
    [activity.view removeFromSuperview];
    
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSMutableDictionary *responseJSON = [responseString JSONValue];
	NSString * idForVideo = [responseJSON objectForKey:@"id"];
    //NSLog(idForVideo);
	if(!idForVideo )
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Video not uploaded" 
													  message:@"Please try later"
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil] autorelease];
		[av show];
        
	}
	else 
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Sucessfully shared a video with friends" 
													  message:@"Check out your Facebook to see!"
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil] autorelease];
		[av show];
        
        
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
		
	}
    

	
}


- (void)uploadVideoFail:(ASIHTTPRequest *)request
{
    
    [myProgressIndicator removeFromSuperview];
    
    
    [activity.activityIndicator stopAnimating];
    [activity.view removeFromSuperview];
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSLog(@"response String is %@",responseString);
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Video Uploading Failed." message:@"Video did not upload successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void)uploadVideoFinished:(ASIHTTPRequest *)request
{
    
    [myProgressIndicator removeFromSuperview];
    [activity.activityIndicator stopAnimating];
    [activity.view removeFromSuperview];
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSMutableDictionary *responseJSON = [responseString JSONValue];
	NSString * idForVideo = [responseJSON objectForKey:@"id"];
	NSLog(@"%@",idForVideo);
	if(!idForVideo )
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"UnSucessfull" 
													  message:@""
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil] autorelease];
		[av show];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
	}
	else 
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Sucessfully shared a video with friends" 
													  message:@"Check out your Facebook to see!"
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil] autorelease];
		[av show];
		
	}
    
}




@end
