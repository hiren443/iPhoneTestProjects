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
#import "video_recordingAppDelegate.h"
#import "JSON.h"
#import "CustomCell.h"

@implementation FBFunViewController
@synthesize loginStatusLabel = _loginStatusLabel;
@synthesize loginButton = _loginButton;
@synthesize loginDialog = _loginDialog;
@synthesize loginDialogView = _loginDialogView;
@synthesize textView = _textView;
@synthesize imageView = _imageView;
@synthesize segControl = _segControl;
@synthesize webView = _webView;
@synthesize accessToken = _accessToken;

#pragma mark Main

- (void)dealloc {
    self.loginStatusLabel = nil;
    self.loginButton = nil;
    self.loginDialog = nil;
    self.loginDialogView = nil;
    self.textView = nil;
    self.imageView = nil;
    self.segControl = nil;
    self.webView = nil;
  //  self.accessToken = nil;
    [super dealloc];
}

- (void)refresh {
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        _loginStatusLabel.text = @"Not connected to Facebook";
		[_loginButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:normal];
      //  [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
		[self showLikeButton];
    } else if (_loginState == LoginStateLoggingIn) {
        _loginStatusLabel.text = @"Connecting to Facebook...";
        _loginButton.hidden = YES;
		[self showLikeButton];
    } else if (_loginState == LoginStateLoggedIn) {
        _loginStatusLabel.text = @"Connected to Facebook";
		[_loginButton setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:normal];
      //  [_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
		[self showLikeButton];
    }   
}

-(void)viewDidLoad
{
    popUpTable.delegate = self;
    popUpTable.dataSource = self;
	popUpTable.separatorColor = [UIColor blueColor];
	popUpTable.backgroundColor = [UIColor clearColor];
	popUp.backgroundColor = [UIColor blackColor];
	CGRect frame = CGRectMake(0, 40, 320, 480);
	popUp.frame = frame;
	frame = CGRectMake(0, 30, 320, 300);
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
	int LoginAvil = 0;
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
		LoginAvil++;
	}
	if(LoginAvil <=1 )
	{
		// [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
		[_loginButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:normal];
		_loginButton.hidden = NO;
		app.act = @"";
		_loginState == LoginStateLoggedOut;
		[self showLikeButton];
	}
	else 
	{
		[_loginButton setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:normal];
		_loginButton.hidden = NO;
		_loginState = LoginStateLoggedIn;
		[self showLikeButton];
		
	}
	
	
	
}

-(IBAction)back_Clicked:(id)sender;{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Login Button

- (IBAction)loginButtonTapped:(id)sender {
    
    NSString *appId = @"214664188584044";
    NSString *permissions = @"publish_stream";
    
    if (_loginDialog == nil) {
        self.loginDialog = [[[FBFunLoginDialog alloc] initWithAppId:appId requestedPermissions:permissions delegate:self] autorelease];
        self.loginDialogView = _loginDialog.view;
    }
    
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        _loginState = LoginStateLoggingIn;
        [_loginDialog login];
    } else if (_loginState == LoginStateLoggedIn) {
        _loginState = LoginStateLoggedOut;        
        [_loginDialog logout];
    }
    
    [self refresh];
}


#pragma mark -
#pragma mark uploadVideoWithTag Methods

-(IBAction)postButtonClicked
{
	
	
	NSLog(@"%@",[arrSelectedFriends description]);
	[self uploadVideo];
}

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
	NSString *str2;
	NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
	for (int i=0; i<[arrSelectedFriends count]; i++) {
		temp = [arrSelectedFriends objectAtIndex:i];
		str2 = [temp objectForKey:@"id"];
		strGO = [strGO stringByAppendingString:[NSString stringWithFormat:@"@[%@:] ",str2]];
	}
	[strGO retain];
	NSLog(@">>>>>!%@",str2);
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph-video.facebook.com/%@/videos?",str2]];
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
	
	
	NSArray *arr = [app.act componentsSeparatedByString:@"&"];
    _accessToken = [arr objectAtIndex:0] ;
	
	NSLog(@"acess:%@",_accessToken);
	[newRequest setPostValue:_accessToken forKey:@"access_token"];
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
	NSLog(idForVideo);
	if(!idForVideo )
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"UnSucessfull" 
													  message:@""
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

- (void)showLikeButton {
    
    // Source: http://developers.facebook.com/docs/reference/plugins/like-box
    NSString *likeButtonIframe = @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?id=141245645948499&amp;width=292&amp;connections=0&amp;stream=false&amp;header=false&amp;height=62\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:282px; height:62px;\" allowTransparency=\"true\"></iframe>";
    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];
    
    [_webView loadHTMLString:likeButtonHtml baseURL:[NSURL URLWithString:@""]];
    
}

- (void)getFacebookProfile {
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(getFacebookProfileFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

-(IBAction)ShareFriendsClicked:(id)sender
{
	int LoginAvil = 0;
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
		LoginAvil++;
	}
	if(LoginAvil <=1 )
	{
		[self loginButtonTapped:self];
	}
	else {
		
	

	
	NSArray *arr = [app.act componentsSeparatedByString:@"&"];
    _accessToken = [arr objectAtIndex:0] ;
		
		if (!_accessToken || _accessToken.length ==0) {
			_accessToken= [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
		}
		
	NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *newRequest = [ASIHTTPRequest requestWithURL:url];
    [newRequest setDidFinishSelector:@selector(getFacebookProfileFinished2:)];
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
    [super viewDidLoad];
		}
}


- (void)getFacebookProfileFinished2:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Profile: %@", responseString);
    NSMutableDictionary *responseJSON = [responseString JSONValue];  
	arrFriends = [responseJSON objectForKey:@"data"];
	[arrFriends retain];
	
	NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[arrFriends sortUsingDescriptors:[NSArray arrayWithObject:lastNameDescriptor]];
    [arrFriends retain];
	
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




- (IBAction)rateTapped:(id)sender {
	
	int LoginAvil = 0;
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
		LoginAvil++;
	}
	if(LoginAvil <=1 )
	{
		[self loginButtonTapped:self];
	}
	else {
    act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    act.frame = CGRectMake(141, 169, 37, 37);
    [self.view addSubview:act];
    [self.view bringSubviewToFront:act];
    [act startAnimating];
    [act setHidden:NO];
    [self.view setUserInteractionEnabled:NO];

        
        
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
    [newRequest setPostValue:@"http://itunes.apple.com/us/app/movis/id455509395?ls=1&mt=8" forKey:@"description"];

	NSArray *arr = [app.act componentsSeparatedByString:@"&"];
    _accessToken = [arr objectAtIndex:0] ;
	[newRequest setPostValue:_accessToken forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(sendToPhotosFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
		
	}
	/*
     
    NSString *likeString;
    NSString *filePath = nil;
    if (_imageView.image == [UIImage imageNamed:@"angelina.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"angelina" ofType:@"jpg"];
        likeString = @"babe";
    } else if (_imageView.image == [UIImage imageNamed:@"depp.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"depp" ofType:@"jpg"];
        likeString = @"dude";
    } else if (_imageView.image == [UIImage imageNamed:@"maltese.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"maltese" ofType:@"jpg"];
        likeString = @"puppy";
    }
    if (filePath == nil) return;
    
    NSString *adjectiveString;
    if (_segControl.selectedSegmentIndex == 0) {
        adjectiveString = @"cute";
    } else {
        adjectiveString = @"ugly";
    }
    
    NSString *message = [NSString stringWithFormat:@"I think this is a %@ %@!", adjectiveString, likeString];
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addFile:filePath forKey:@"file"];
    [request setPostValue:message forKey:@"message"];
    [request setPostValue:_accessToken forKey:@"access_token"];
    [request setDidFinishSelector:@selector(sendToPhotosFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
    */
}

- (void)sendToPhotosFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSMutableDictionary *responseJSON = [responseString JSONValue];
	NSString *idForVideo12 = [responseJSON objectForKey:@"id"];
	[act stopAnimating];
    [act setHidden: TRUE];
    self.view.userInteractionEnabled = TRUE;
	if(!idForVideo12 )
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"UnSucessfull" 
													  message:@""
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil] autorelease];
		[av show];
		
	}
	else 
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Sucessfully post a video wall" 
													  message:@"Check out your Facebook to see!"
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil] autorelease];
		[av show];
		
	}
 
}

#pragma mark FB Responses

- (void)getFacebookProfileFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Profile: %@", responseString);
    
    NSString *likesString;
    NSMutableDictionary *responseJSON = [responseString JSONValue];   
    NSArray *interestedIn = [responseJSON objectForKey:@"interested_in"];
    if (interestedIn != nil) {
        NSString *firstInterest = [interestedIn objectAtIndex:0];
        if ([firstInterest compare:@"male"] == 0) {
            [_imageView setImage:[UIImage imageNamed:@"depp.jpg"]];
            likesString = @"dudes";
        } else if ([firstInterest compare:@"female"] == 0) {
            [_imageView setImage:[UIImage imageNamed:@"angelina.jpg"]];
            likesString = @"babes";
        }        
    } else {
        [_imageView setImage:[UIImage imageNamed:@"maltese.jpg"]];
        likesString = @"puppies";
    }
    
    NSString *username;
    NSString *firstName = [responseJSON objectForKey:@"first_name"];
    NSString *lastName = [responseJSON objectForKey:@"last_name"];
    if (firstName && lastName) {
        username = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    } else {
        username = @"mysterious user";
    }
    
    _textView.text = [NSString stringWithFormat:@"Hi %@!  I noticed you like %@, so tell me if you think this pic is hot or not!",
                      username, likesString];
    
    [self refresh];    
}

- (void)getFacebookPhotoFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Photo: %@", responseString);
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];   
    
    NSString *link = [responseJSON objectForKey:@"link"];
    if (link == nil) return;
    NSLog(@"Link to photo: %@", link);
    
    /*
    NSString *adjectiveString;
    if (_segControl.selectedSegmentIndex == 0) {
        adjectiveString = @"cute";
    } else {
        adjectiveString = @"ugly";
    }
    */
    
    
    
}

- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];
    NSLog(@"Post id is: %@", postId);
    
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Sucessfully posted to photos & wall!" 
												  message:@"Check out your Facebook to see!"
												 delegate:nil 
										cancelButtonTitle:@"OK"
										otherButtonTitles:nil] autorelease];
	[av show];
    
}

#pragma mark FBFunLoginDialogDelegate

- (void)accessTokenFound:(NSString *)accessToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
	[defaults setObject:accessToken forKey:@"token"];
	[defaults synchronize];
    NSLog(@"Access token found: %@", accessToken);
    self.accessToken = accessToken;
    _loginState = LoginStateLoggedIn;
    [self dismissModalViewControllerAnimated:YES];    
    [self getFacebookProfile];  
    [self showLikeButton];
    [self refresh];
}

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
	currentFriendIndex= indexPath.row;
	
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
		[cell.checkBoxButton setImage:[UIImage imageNamed:@"chkboxselect.png"] forState:UIControlStateNormal];
	}
	else
	{
		[cell.checkBoxButton setImage:[UIImage imageNamed:@"chkbox.png"] forState:UIControlStateNormal];
		
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

- (void)displayRequired {
    [self presentModalViewController:_loginDialog animated:YES];
}

- (void)closeTapped {
    [self dismissModalViewControllerAnimated:YES];
    _loginState = LoginStateLoggedOut;        
    [_loginDialog logout];
    [self refresh];
}

@end
