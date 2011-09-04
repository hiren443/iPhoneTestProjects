//
//  FBFunViewController.m
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//



#import "FBFunViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MovisAppDelegate.h"
#import "JSON.h"
#import "CustomCell.h"

@implementation FBFunViewController
@synthesize facebook;
@synthesize sharingTag;
#pragma mark Main

- (void)dealloc {
  //  self.accessToken = nil;
    [facebook release];
    [super dealloc];
}



-(void)viewDidLoad
{
        // facebook = [[Facebook alloc] initWithAppId:@"214664188584044" andDelegate:self];
    popUpTable.delegate = self;
    popUpTable.dataSource = self;
	popUpTable.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowDivider.png"]];
	popUpTable.backgroundColor = [UIColor clearColor];
	popUp.backgroundColor = [UIColor blackColor];
	CGRect frame = CGRectMake(0, 0, 320, 416);
	popUp.frame = frame;
	frame = CGRectMake(0, 26, 320, 336);
	popUpTable.frame = frame;
	[popUp addSubview:popUpTable];
    arrFriends = [[NSMutableArray alloc]init];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	app = [[UIApplication sharedApplication] delegate];
	app.select = [[NSMutableArray alloc]init];
	
	arrSelectedFriends = [[NSMutableArray alloc]init];
	
    self.navigationItem.title = @"Share Video";
	//[self loginButtonTapped];
	
	videoName.text = app.nameVideo;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	NSString *url = [NSString stringWithFormat:@"%@/%@",uniquePath,app.nameVideo];
    
    
	
	MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath: url]];
    
    UIImage *thumbnailImage = [moviePlayer1 thumbnailImageAtTime:0.3 timeOption:MPMovieTimeOptionExact];
    
    videoThumb.image = thumbnailImage;
    [moviePlayer1 stop];
	
	
	
	
}

-(IBAction)back_Clicked:(id)sender;{
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)postToWallClicked:(id)sender {
    
   /* if (![facebook isSessionValid])
        {
            // Permissions are customizeable, I will discuss these in a minute
        NSArray* permissions = [NSArray arrayWithObjects:@"read_friendlists",nil];
        [facebook authorize:permissions];
        }
    else
        {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
        }*/
    sharingTag = 1;
    if (!facebook)
        {
        facebook = [[Facebook alloc] initWithAppId:@"214664188584044" andDelegate:app];
        
        }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"])
        {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
    
    if (![facebook isSessionValid])
        {
            // Permissions are customizeable, I will discuss these in a minute
        NSArray* permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",@"read_friendlists", nil];
        [facebook authorize:permissions];
        [permissions release];
        }
    else
        {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *uniquePath = [paths objectAtIndex:0];
        uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,app.nameVideo];
        NSURL *urlVideo = [NSURL fileURLWithPath:uniquePath];
        
        NSData *dataVideo = [NSData dataWithContentsOfURL:urlVideo];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       dataVideo, @"video.mp4",
                                       @"video/quicktime", @"contentType",
                                       [[app.nameVideo componentsSeparatedByString:@"."] objectAtIndex:0], @"title",
                                       @"http://itunes.apple.com/us/app/movis/id455509395?ls=1&mt=8", @"description",
                                       nil];
        [facebook requestWithGraphPath:@"me/videos"
                             andParams:params
                         andHttpMethod:@"POST"
                           andDelegate:self];
        }
   
    
    /*act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    act.frame = CGRectMake(141, 169, 37, 37);
    [self.view addSubview:act];
    [self.view bringSubviewToFront:act];
    [act startAnimating];
    [act setHidden:NO];
    [self.view setUserInteractionEnabled:NO];*/

    
}
-(IBAction)ShareFriendsClicked:(id)sender
{
   /* if (![facebook isSessionValid])
        {
            // Permissions are customizeable, I will discuss these in a minute
        NSArray* permissions = [NSArray arrayWithObjects:@"read_friendlists",nil];
        [facebook authorize:permissions];
        }
    else
        {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
        }*/
    sharingTag = 2;
    
    if (!facebook)
        {
        facebook = [[Facebook alloc] initWithAppId:@"214664188584044" andDelegate:app];
        
        }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"])
        {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
    
    if (![facebook isSessionValid])
        {
            // Permissions are customizeable, I will discuss these in a minute
        NSArray* permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",@"read_friendlists", nil];
        [facebook authorize:permissions];
        [permissions release];
        }
    else
        {
         [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
        }
    
   
    
	[popUp setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
	popUp.hidden = FALSE;
    
	[self.view addSubview:popUp];
	[self.view bringSubviewToFront:popUp];
	
	[UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:0.3];
    [UIImageView setAnimationDelegate:self];
    CGAffineTransform transformBack = CGAffineTransformMakeScale(1.0, 1.0);
    popUp.transform = transformBack;
    [UIView commitAnimations];
	
    
	[popUpTable reloadData];
    
}
-(IBAction)postButtonClicked
{
	
	sharingTag = 3;
	NSLog(@"%@",[arrSelectedFriends description]);
	[self uploadVideo];
}

/*    ///////////////facebook//////////////////////
- (void)fbDidLogin {
    NSLog(@"sharing tag %d",sharingTag);
    switch (sharingTag) {
        case 1:
        {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *uniquePath = [paths objectAtIndex:0];
        uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,app.nameVideo];
        NSURL *urlVideo = [NSURL fileURLWithPath:uniquePath];
        
        NSData *dataVideo = [NSData dataWithContentsOfURL:urlVideo];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       dataVideo, @"video.mp4",
                                       @"video/quicktime", @"contentType",
                                       [[app.nameVideo componentsSeparatedByString:@"."] objectAtIndex:0], @"title",
                                       @"http://itunes.apple.com/us/app/movis/id455509395?ls=1&mt=8", @"description",
                                       nil];
        [facebook requestWithGraphPath:@"me/videos"
                             andParams:params
                         andHttpMethod:@"POST"
                           andDelegate:self];
            break;
        }
        
        case 2:
        {
        [facebook requestWithGraphPath:@"me/friends" andDelegate:self];

        break;
        }
        case 3:
        {
        break;
        }
        default:
            break;
    }
   
}


-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}
*/
- (void)request:(FBRequest *)request didLoad:(id)result {
        // NSLog(@"result %@",result );
    switch (sharingTag) {
        case 1:
        {
        
        if ([result isKindOfClass:[NSArray class]]) {
            result = [result objectAtIndex:0];
            UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Video uploaded successfully" 
                                                          message:@""
                                                         delegate:nil 
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil] autorelease];
            [av show];
        }
        break;
        }
            
        case 2:
        {
        
        arrFriends = [[result valueForKey:@"data"]copy];
        [popUpTable reloadData];

        break;
        }
        case 3:
        {
        break;
        }
        default:
            break;
    }
  

        //NSLog(@"Result of API call: %@", result);
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", [error localizedDescription]);
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Video could not be uploaded" 
                                                  message:[NSString stringWithFormat:@"%@",[error localizedDescription]]
                                                 delegate:nil 
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil] autorelease];
    [av show];
}

    ////////////////////////////////

#pragma mark -
#pragma mark uploadVideoWithTag Methods


-(void)uploadVideo
{
	act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	act.frame = CGRectMake(141, 169, 37, 37);
	[popUp addSubview:act];
	[popUp bringSubviewToFront:act];
	[act startAnimating];
	[act setHidden:NO];
	[popUpTable setUserInteractionEnabled:NO];
	[postButton setEnabled:NO];
	NSMutableString *strGO;
	strGO = @"";
	NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
	for (int i=0; i<[arrSelectedFriends count]; i++) {
		temp = [arrSelectedFriends objectAtIndex:i];
		NSString *str = [temp objectForKey:@"id"];
		strGO = [strGO stringByAppendingString:[NSString stringWithFormat:@"@[%@:] ",str]];
	}
	[strGO retain];
	
	
	NSURL *url = [NSURL URLWithString:@"https://graph-video.facebook.com/me/videos?"];
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,app.nameVideo];
    NSURL *urlVideo = [NSURL fileURLWithPath:uniquePath];
    
    NSData *dataVideo = [NSData dataWithContentsOfURL:urlVideo];
    [newRequest addFile:dataVideo withFileName:@"test.mp4" andContentType:@"multipart/form-data" forKey:@"post_url"];
    NSString *str = [[app.nameVideo componentsSeparatedByString:@"."] objectAtIndex:0];

    [newRequest setPostValue:str forKey:@"title"];
    [newRequest setPostValue:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/movis/id455509395?ls=1&mt=8  %@",strGO] forKey:@"description"];
	[newRequest setPostValue:strGO forKey:@"message"];
	
        //NSArray *arr = [app.act componentsSeparatedByString:@"&"];
        // _accessToken = [arr objectAtIndex:0] ;
	[newRequest setPostValue:[facebook accessToken] forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(sendToPhotosFinished3:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
	
}
- (void)sendToPhotosFinished3:(ASIHTTPRequest *)request
{
	[act setHidden:YES];
	[popUpTable setUserInteractionEnabled:YES];
	[postButton setEnabled:YES];

    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSMutableDictionary *responseJSON = [responseString JSONValue];
	idForVideo = [responseJSON objectForKey:@"id"];
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
		
	}

}



#pragma mark -

-(IBAction)closeButtonClicked
{
	[popUp setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	
	[UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:0.3];
    [UIImageView setAnimationDelegate:self];
    CGAffineTransform transformBack = CGAffineTransformMakeScale(0.001, 0.001);
    popUp.transform = transformBack;
    [UIView commitAnimations];
	
	[self performSelector:@selector(hideThePopUp) withObject:nil afterDelay:1.0];
}
-(void)hideThePopUp
{
	popUp.hidden = TRUE;
}
#pragma mark FB Requests
















#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrFriends count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell =(CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.nameFriends.hidden = FALSE;
	cell.checkBoxButton.hidden = FALSE;
	cell.checkBoxButton.tag = indexPath.row;
	
	
	int l = 0;
	/*if(flG==1 && remove == indexPath.row)
	 {
	 
	 flG=0;
	 }*/
	
    for(int i=0;i<[app.select count];i++)
    {
        int val=[[app.select objectAtIndex:i] intValue];
        if(val==indexPath.row)
        {
			l = 1;
			
        }
		
    }
	if(l == 1)
	{
		[cell.checkBoxButton setImage:[UIImage imageNamed:@"checkmark_s.png"] forState:UIControlStateNormal];
	}
	else
	{
		[cell.checkBoxButton setImage:[UIImage imageNamed:@"checkmark_d.png"] forState:UIControlStateNormal];
		
	}	
	
	//[cell.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"chkbox.png"] forState:normal];
	[cell.checkBoxButton addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
    cell.nameFriends.text = [[arrFriends objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

-(void)checkBoxButtonClicked:(id)sender
{
    UIButton *b=(UIButton *)sender;
    if ([app.select containsObject:[NSString stringWithFormat:@"%d",b.tag]])
    {
        
        [app.select removeObject:[NSString stringWithFormat:@"%d",b.tag]];
        
		if ([arrSelectedFriends containsObject:[arrFriends objectAtIndex:b.tag]]) {
			
			[arrSelectedFriends removeObject:[arrFriends objectAtIndex:b.tag]];

		}
				
    }
    else
    {
        [app.select addObject:[NSString stringWithFormat:@"%d",b.tag]];
		
		if ([arrSelectedFriends containsObject:[arrFriends objectAtIndex:b.tag]]) {
			
		}
		else {
			[arrSelectedFriends addObject:[arrFriends objectAtIndex:b.tag]];
		}

    }
    [app.select retain];
    [popUpTable reloadData];    
	
}


- (void)closeTapped {
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
