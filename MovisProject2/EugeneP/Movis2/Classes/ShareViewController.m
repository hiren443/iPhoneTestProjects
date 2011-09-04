//
//  ShareViewController.m
//  Movis2
//
//  Created by Eugene Pavlyuk on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "FriendsViewController.h"
#import "Friend.h"
#import "GradientButton.h"

@interface ShareViewController()

@property (nonatomic, retain) FBLoginDialog *loginDialog;

@end


@implementation ShareViewController

@synthesize filename;
@synthesize friends;
@synthesize accessToken;
@synthesize loginButton;
@synthesize logoutButton;
@synthesize loginDialog;
@synthesize imageView;
@synthesize postToMyWallButton;
@synthesize postToFriendsWallButton;
@synthesize activityView;
@synthesize titleLabel;

- (void)enableUI:(BOOL)enable
{
	[self.view setUserInteractionEnabled:enable];
	
	if (enable)
	{
		[self.activityView stopAnimating];
	}
	else
	{
		[self.view bringSubviewToFront:self.activityView];
		[self.activityView startAnimating];
	}
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self)
	{
		timer = [[NSTimer scheduledTimerWithTimeInterval:10 
												 target:self 
											   selector:@selector(restoreAccessToken) 
											   userInfo:nil 
												repeats:YES] retain];
	}
	
	return self;
}

- (void)restoreAccessToken
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	self.accessToken = [userDefaults objectForKey:@"access_token"];
	NSString *expires_in = [userDefaults objectForKey:@"expires_in"];
	NSDate *date = [userDefaults objectForKey:@"date"];
	
	if (!date || !expires_in || !self.accessToken)
	{
		[self logoutButtonTapped:nil];
	}
	else 
	{
		if ([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970] > [expires_in intValue])
		{
			[self logoutButtonTapped:nil];
		}
	}
}

- (void)viewDidLoad 
{			
	self.navigationItem.title = NSLocalizedString(@"Share", @"Share title");
	
	[super viewDidLoad];
	
	self.friends = [NSMutableArray array];
	
	self.titleLabel.text = filename;
	
	int loginAvailable = 0;
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	for (NSHTTPCookie* cookie in cookies.cookies) 
	{
		loginAvailable++;
	}
	
	if (loginAvailable <= 1)
	{
		self.loginButton.hidden = NO;
		self.logoutButton.hidden = YES;
		self.postToMyWallButton.hidden = YES;
		self.postToFriendsWallButton.hidden = YES;
	}
	else 
	{
		self.loginButton.hidden = YES;
		self.logoutButton.hidden = NO;
		self.postToMyWallButton.hidden = NO;
		self.postToFriendsWallButton.hidden = NO;
	}	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	NSString *localUrl = [NSString stringWithFormat:@"%@/%@", uniquePath, filename];
	
	MPMoviePlayerController *moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath: localUrl]] autorelease];
	
	self.imageView.image = [moviePlayer thumbnailImageAtTime:0.2 timeOption:MPMovieTimeOptionExact];
	
	[moviePlayer stop];
	
	self.imageView.layer.cornerRadius = 5.f;
	self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
	self.imageView.layer.borderWidth = 1.f;		
	
	[self restoreAccessToken];
	
	[loginButton useGreenConfirmStyle];
	loginButton.strokeColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
	loginButton.cornerRadius = 5.f;		
	
	[logoutButton useRedDeleteStyle];
	logoutButton.strokeColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
	logoutButton.cornerRadius = 5.f;		
	
	[postToMyWallButton useGreenConfirmStyle];
	postToMyWallButton.strokeColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
	postToMyWallButton.cornerRadius = 5.f;		
	
	[postToFriendsWallButton useGreenConfirmStyle];
	postToFriendsWallButton.strokeColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
	postToFriendsWallButton.cornerRadius = 5.f;		
}

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
	self.loginButton = nil;
    self.logoutButton = nil;
	self.postToMyWallButton = nil;
	self.postToFriendsWallButton = nil;
	self.activityView = nil;
	self.titleLabel = nil;
}


- (void)dealloc 
{
	self.filename = nil;
	self.loginButton = nil;
    self.logoutButton = nil;
	self.loginDialog = nil;	
	self.activityView = nil;
	self.postToMyWallButton = nil;
	self.postToFriendsWallButton = nil;
	self.friends = nil;
	self.titleLabel = nil;
	
	[timer invalidate];
	[timer release];
	timer = nil;
	
    [super dealloc];
}

- (void)uploadVideo
{	
	NSMutableString *strFriends = [NSMutableString string];
	
	for (Friend *friend in self.friends) 
	{
		NSString *str = friend.friend_id;
		
		if (friend.selected)
		{
			[strFriends appendString:[NSString stringWithFormat:@"@[%@:] ", str]];
		}
	}
	
	NSURL *url = [NSURL URLWithString:@"https://graph-video.facebook.com/me/videos?"];
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@", uniquePath, self.filename];
    NSURL *urlVideo = [NSURL fileURLWithPath:uniquePath];
    
    NSData *dataVideo = [NSData dataWithContentsOfURL:urlVideo];
    [newRequest addFile:dataVideo withFileName:@"test.mp4" andContentType:@"multipart/form-data" forKey:@"post_url"];
    NSString *str = [[self.filename componentsSeparatedByString:@"."] objectAtIndex:0];
	
    [newRequest setPostValue:str forKey:@"title"];
    [newRequest setPostValue:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/movis/id455509395?ls=1&mt=8  %@", strFriends] forKey:@"description"];
	[newRequest setPostValue:strFriends forKey:@"message"];
	
	[newRequest setPostValue:self.accessToken forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(shareForFriendsFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
	
}

- (void) continueShareForFriends
{
	[self enableUI:NO];
	[self uploadVideo];
}

- (void) postToMyWall
{	
	NSURL *url = [NSURL URLWithString:@"https://graph-video.facebook.com/me/videos?"];
	ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@", uniquePath, self.filename];
	NSURL *urlVideo = [NSURL fileURLWithPath:uniquePath];
	
	NSData *dataVideo = [NSData dataWithContentsOfURL:urlVideo];
	[newRequest addFile:dataVideo withFileName:@"test.mp4" andContentType:@"multipart/form-data" forKey:@"post_url"];
	NSString *str = [[self.filename componentsSeparatedByString:@"."] objectAtIndex:0];
	[newRequest setPostValue:str forKey:@"title"];
	[newRequest setPostValue:@"http://itunes.apple.com/us/app/movis/id455509395?ls=1&mt=8" forKey:@"description"];
	
	[newRequest setPostValue:self.accessToken forKey:@"access_token"];
	[newRequest setDidFinishSelector:@selector(postToMyWallRequestFinished:)];
	
	[newRequest setDelegate:self];
	[newRequest startAsynchronous];	
}

- (void)postToMyWallRequestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSMutableDictionary *responseJSON = [responseString JSONValue];
	NSString *result = [responseJSON objectForKey:@"id"];
	
	if(!result )
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UnSuccessfull", @"UnSuccessfull") 
													  message:nil
													 delegate:nil 
											cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											otherButtonTitles:nil] autorelease];
		[av show];
		
	}
	else 
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Successfully post a video wall", @"Successfull") 
													  message:NSLocalizedString(@"Check out your Facebook to see!", @"Check out")
													 delegate:nil 
											cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											otherButtonTitles:nil] autorelease];
		[av show];		
	}	
	
	[self enableUI:YES];
}

- (void)getFriendsRequestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSMutableDictionary *responseJSON = [responseString JSONValue];  
	
	NSArray *array = [responseJSON objectForKey:@"data"];

	[self.friends removeAllObjects];
	
	for (NSDictionary *friend in array)
	{
		Friend *fr = [[[Friend alloc] init] autorelease];
		
		fr.name = [friend objectForKey:@"name"];
		fr.friend_id = [friend objectForKey:@"id"];
		
		[self.friends addObject:fr];
	}
	
	[self.friends sortUsingSelector:@selector(sortByName:)];
	
	NSSortDescriptor *lastNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
	[friends sortUsingDescriptors:[NSArray arrayWithObject:lastNameDescriptor]];
	
	[self enableUI:YES];
	
	FriendsViewController *friendsViewController = [[[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil] autorelease];
	friendsViewController.friends = self.friends;
	friendsViewController.shareViewController = self;
	[self.navigationController pushViewController:friendsViewController animated:YES];
}	

- (void)shareForFriendsFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSMutableDictionary *responseJSON = [responseString JSONValue];
	
	NSString *idForVideo = [responseJSON objectForKey:@"id"];

	if(!idForVideo )
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UnSuccessfull", @"UnSucessful") 
													  message:nil
													 delegate:nil 
											cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											otherButtonTitles:nil] autorelease];
		[av show];
		
	}
	else 
	{
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Successfully shared a video with friends",@"Success") 
													  message:NSLocalizedString(@"Check out your Facebook to see!", @"message")
													 delegate:nil 
											cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											otherButtonTitles:nil] autorelease];
		[av show];
	}
	
	[self enableUI:YES];
}

#pragma mark -
#pragma mark IBOutlet's methods

- (IBAction)loginButtonTapped:(id)sender 
{
	self.loginDialog = [[[FBLoginDialog alloc] init] autorelease];
	self.loginDialog.delegate = self;
	self.loginDialog.apiKey = @"214664188584044";
	self.loginDialog.requestedPermissions = @"publish_stream";
	[self.loginDialog show];
	
	[self enableUI:NO];
}

- (IBAction)logoutButtonTapped:(id)sender 
{
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) 
	{
        [cookies deleteCookie:cookie];
    }
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:nil forKey:@"access_token"];
	[userDefaults setObject:nil forKey:@"expires_in"];
	[userDefaults setObject:nil forKey:@"date"];
	
	self.logoutButton.hidden = YES;
	self.loginButton.hidden = NO;
	self.postToMyWallButton.hidden = YES;
	self.postToFriendsWallButton.hidden = YES;
	
	[self enableUI:YES];
}

- (IBAction)postToMyWallButtonTapped
{
	[self postToMyWall];
	[self enableUI:NO];
}

- (IBAction)postToFriendsWallButtonTapped
{
	NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", [self.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *newRequest = [ASIHTTPRequest requestWithURL:url];
	[newRequest setDidFinishSelector:@selector(getFriendsRequestFinished:)];
	[newRequest setDelegate:self];
	[newRequest startAsynchronous];
	
	[self enableUI:NO];
}

#pragma mark -
#pragma mark Get Facebook Name Helper

- (void)accessTokenFound:(NSString *)aAccessToken 
{
    NSLog(@"Access token found: %@", aAccessToken);
	
	NSArray *components = [aAccessToken componentsSeparatedByString:@"&"];
	
	if ([components count])
	{
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		[userDefaults setObject:[components objectAtIndex:0] forKey:@"access_token"];		
		
		NSString *expires_in = [components objectAtIndex:1];
		NSArray *array = [expires_in componentsSeparatedByString:@"="];
		
		[userDefaults setObject:[array objectAtIndex:1] forKey:@"expires_in"];	
		[userDefaults setObject:[NSDate date] forKey:@"date"];
		
		self.accessToken = [components objectAtIndex:0];
		self.loginButton.hidden = YES;
		self.logoutButton.hidden = NO;
		self.postToMyWallButton.hidden = NO;
		self.postToFriendsWallButton.hidden = NO;
	}
    else 
	{
		self.loginButton.hidden = NO;
		self.logoutButton.hidden = YES;
		self.accessToken = nil;
		self.postToMyWallButton.hidden = YES;
		self.postToFriendsWallButton.hidden = YES;
	}

	[self.loginDialog dismissWithSuccess:YES animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


@end
