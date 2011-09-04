//
//  RecordingTableViewController.m
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import "RecordingTableViewController.h"
#import "MovisAppDelegate.h"
#import "Loading.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Loading.h"
#import "FaceBookFriendsViewController.h"
#import "RecordingCustomCell.h"
#import "StorageUrlClassViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import "ShareVideoViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation RecordingTableViewController
@synthesize activity,faceBookConnectButton,timerFBLogin,friendListNSMutableArray,friendsListMutableDictionery,recordingTableView,player,selecctedIndex ,pathOfVideos,urlStringOfVideo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"View Friends";
    
    urlStringOfVideo=[[NSString alloc]init];
    pathOfVideos=[[NSMutableArray alloc]init];
    friendListNSMutableArray=[[NSMutableArray alloc]init];
    
    friendsListMutableDictionery =[[NSMutableDictionary alloc]init];
    
    self.navigationItem.hidesBackButton=YES;    
    
    UIBarButtonItem *home = [[UIBarButtonItem alloc] 
                             initWithTitle:@"Camera"                                            
                             style:UIBarButtonItemStyleBordered 
                             target:self 
                             action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = home;
    [home release];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
    
	//pathOfVideos = [[NSFileManager defaultManager] directoryContentsAtPath:uniquePath];	
	NSArray *pathOfVideos1 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:uniquePath error:nil];
	[pathOfVideos1 retain];
	
    NSMutableArray* filesAndProperties = [[NSMutableArray alloc] init];
    for(NSString* path in pathOfVideos1)
    {
        NSDictionary* properties = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",uniquePath,path]
                                    error:nil];
        NSDate* modDate = [properties objectForKey:NSFileModificationDate];
        
        [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       path, @"path",
                                       modDate, @"lastModDate",
                                       nil]];                 
    }
	NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastModDate" ascending:NO];
	[filesAndProperties sortUsingDescriptors:[NSArray arrayWithObject:lastNameDescriptor]];
    [filesAndProperties retain];
	
	for(int cnt= 0; cnt < [filesAndProperties count]; cnt++)
	{
		NSMutableDictionary *temDict = [[NSMutableDictionary alloc] init];
		temDict = [filesAndProperties objectAtIndex:cnt];
		[pathOfVideos addObject:[temDict objectForKey:@"path"]];
		
		
	}
	[pathOfVideos retain];

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    MovisAppDelegate *appDelegate =(MovisAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if ([appDelegate.videoLinksNSMutableArray count]>0) {
        
        
        return [appDelegate.videoLinksNSMutableArray count];
    }
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MovisAppDelegate *appDelegate=(MovisAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
  //  NSLog(@"value of array is %@",appDelegate.videoLinksNSMutableArray);
    if ([appDelegate.videoLinksNSMutableArray count]>0) {
        
    
        static NSString *cellIdentifier=@"RecordingCustomCell";
        RecordingCustomCell *cell=(RecordingCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (cell==nil) {
        
            cell=[[RecordingCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    
    
        NSArray *toplevelObject=[[NSBundle mainBundle] loadNibNamed:@"RecordingCustomCell" owner:self options:nil];
        cell =(RecordingCustomCell *)[toplevelObject objectAtIndex:0];
        
        StorageUrlClassViewController *storage =(StorageUrlClassViewController*)[appDelegate.videoLinksNSMutableArray objectAtIndex:indexPath.row];
        
        cell.title.text=storage.title;
        cell.date.text=storage.date;
        
        NSLog(@"storage url %@",storage.url);
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *uniquePath = [paths objectAtIndex:0];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@",uniquePath,[pathOfVideos objectAtIndex:indexPath.row]];
        
        
        
        MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath: url]];
        UIImage *thumbnailImage = [moviePlayer1 thumbnailImageAtTime:0.2 timeOption:MPMovieTimeOptionExact];
        
        
        CALayer * l = [cell.video layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        // You can even add a border
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        
        CALayer * l1 = [cell.faceBook layer];
        [l1 setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        // You can even add a border
        [l1 setBorderWidth:1.0];
        [l1 setBorderColor:[[UIColor grayColor] CGColor]];

        [cell.video setImage:thumbnailImage forState:UIControlStateNormal];
        [cell.video addTarget:self action:@selector(videoButtonPress:event:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.faceBook addTarget:self action:@selector(faceBookButtonPress:event:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;

    }
    else
    {
        static NSString *cellIdentifier=@"RecordingCustomCell";
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.textLabel.text=@"No Video Found";
        
        return cell;
    }
    
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
-(void)playMediaFinished:(NSNotification*)theNotification {
    [self.navigationController popViewControllerAnimated:YES];
	
	player = [theNotification object];
    
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];   
    [player.moviePlayer stop];
	
}

-(void)videoButtonPress:(id)sender event:(id)event
{

    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:recordingTableView];
    NSIndexPath *indexPath = [recordingTableView indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"index Path is %d",indexPath.row);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,[pathOfVideos objectAtIndex:indexPath.row]];
    NSLog(@"value of inique path is %@",uniquePath);
    player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:uniquePath]]; 
    [self presentMoviePlayerViewControllerAnimated:player];
    
    
    [[NSNotificationCenter defaultCenter] 
	 addObserver:self
	 selector:@selector(playMediaFinished:)                                                 
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];
	 player.moviePlayer.shouldAutoplay = YES;
	[player.moviePlayer play];  
} 

-(void)faceBookButtonPress:(id)sender event:(id)event
{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:recordingTableView];
    NSIndexPath *indexPath = [recordingTableView indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"index Path is %d",indexPath.row);

    
    ////To save URL path///
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,[pathOfVideos objectAtIndex:indexPath.row]];
    
    urlStringOfVideo =uniquePath;
    
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSString stringWithFormat:@"%@",uniquePath] forKey:@"path"];
    
    
    MovisAppDelegate *appDelegate=(MovisAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    
    StorageUrlClassViewController *storage= (StorageUrlClassViewController*)[appDelegate.videoLinksNSMutableArray objectAtIndex:indexPath.row];
    [prefs setObject:[NSString stringWithFormat:@"%@",storage.title] forKey:@"title"];
    
    
    [prefs synchronize];
    
    if(activity == nil)
        activity = [[Loading alloc] initWithNibName:@"Loading" bundle:[NSBundle mainBundle]];
    
    [self.view insertSubview:activity.view aboveSubview:self.parentViewController.view];
    [activity.activityIndicator startAnimating];
    
    
   // MovisAppDelegate *appDelegate = (MovisAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate.facebook isSessionValid]) {
        
        
        [appDelegate loginToFacebookAndDelegate:self];
        
    }
    else
    {
        
        [self getFriendList];
    }

    selecctedIndex=indexPath.row;
    
    
} 

-(void)loginThroughFacebook{
    timerFBLogin = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(loginThroughFacebookInterm) userInfo:nil repeats:NO];
    NSLog(@"login through facebook ");
    
}
-(void)loginThroughFacebookInterm{
    
    MovisAppDelegate *appDelegate = (MovisAppDelegate *)[[UIApplication sharedApplication] delegate];
    // NSLog(@"%@",[appDelegate.facebook.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    if([appDelegate.facebook.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]){
        [self loginThroughFacebookSuccessful];
    }else{
        [self loginThroughFacebookUnSuccessful];
    }
}

-(void)loginThroughFacebookSuccessful{
    [self signinFacebookRequest];
}

-(void)loginThroughFacebookUnSuccessful{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FBConnect Failed!!!" message:@"Please re-try connecting with Facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)signinFacebookRequest{
    
    
    [self getFriendList];
    
    /// check for registration of the user if it is first time registered then it push bragViewController other wise crime view controller 
    
}




#pragma get Friends list 
- (void)getFriendList {
	//1166314171
	//https://graph.facebook.com/me/friends?access_token=%@ for getting friends from faceBook 
    MovisAppDelegate *appDelegate = (MovisAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", [appDelegate.facebook.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(getFriendListFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
	
}

///////////////This method is called when we get the response from facebook regarding user infromation

#pragma mark FB Responses
-(void)getFriendListFinished:(ASIHTTPRequest *)request
{
    
    
	// Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Friend List Resonse: %@", responseString);
    
	SBJSON *json =[[SBJSON new]autorelease];
    
    friendsListMutableDictionery =[[json objectWithString:responseString]retain];
    ///////Global Array 
    friendListNSMutableArray = [[friendsListMutableDictionery objectForKey:@"data"] retain];
    
    for(int indexCounter=0; indexCounter< [friendListNSMutableArray  count]; indexCounter++){
        
        NSString *imagePath=[[NSString alloc]init];
        //imagePath=@"http://www.facebook.com/profile.php?id=";
        imagePath=@"http://graph.facebook.com/";
        imagePath=[imagePath stringByAppendingString:[[friendListNSMutableArray  objectAtIndex:indexCounter] objectForKey:@"id"]];
        imagePath=[imagePath stringByAppendingString:@"/picture"];
        
        [[friendListNSMutableArray  objectAtIndex:indexCounter] setObject:imagePath forKey:@"imageURLString"];
    }
    
    
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    
    
    [activity.activityIndicator stopAnimating];
    [activity.view removeFromSuperview];
    [friendListNSMutableArray   sortUsingDescriptors:[NSMutableArray arrayWithObjects:sortDescriptor, nil]];
    
    
    MovisAppDelegate *appDelegate=(MovisAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.friendsMutableArray=friendListNSMutableArray;
    
  /*  FaceBookFriendsViewController *faceBookFriendsViewController=[[FaceBookFriendsViewController alloc]initWithNibName:@"FaceBookFriendsViewController" bundle:nil];
    // faceBookFriendsViewController.faceBookFriendsNsMutableArray=friendListNSMutableArray;
   */
    ShareVideoViewController *sharedController=[[ShareVideoViewController alloc]initWithNibName:@"ShareVideoViewController" bundle:nil];
    sharedController.index=selecctedIndex;
 //   sharedController.urlpath=[NSString stringWithFormat:@"%@", urlStringOfVideo];
    [self.navigationController pushViewController:sharedController animated:YES];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
