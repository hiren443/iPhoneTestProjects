//
//  ShareVideoViewController.m
//  Movis
//
//  Created by Adnan Ahmad on 8/22/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import "ShareVideoViewController.h"
#import "MovisAppDelegate.h"
#import "StorageUrlClassViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "FaceBookFriendsViewController.h"
#import "Loading.h"
#import "Facebook.h"
#import "MovisAppDelegate.h"
@implementation ShareVideoViewController
@synthesize index,urlpath,myProgressIndicator,activity,facebook;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [activity   release];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)shareWithMEButtonPress:(id)sender
{

    
    
    if(activity == nil)
        activity = [[Loading alloc] initWithNibName:@"Loading" bundle:[NSBundle mainBundle]];
    
    [self.view insertSubview:activity.view aboveSubview:self.parentViewController.view];
    [activity.activityIndicator startAnimating];

    
    MovisAppDelegate *appDelegate=(MovisAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
  //  NSString *uniquePath = [paths objectAtIndex:0];
   // uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,app.nameVideo];
    NSURL *urlVideo = [NSURL fileURLWithPath:[pref objectForKey:@"path"]];
    
    NSData *dataVideo = [NSData dataWithContentsOfURL:urlVideo];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   dataVideo, @"video.mp4",
                                   @"video/quicktime", @"contentType",
                                   [[[pref objectForKey:@"title"] componentsSeparatedByString:@"."] objectAtIndex:0], @"title",
                                   @"http://itunes.apple.com/us/app/movis/id455509395?ls=1&mt=8", @"description",
                                   nil];
    [appDelegate.facebook requestWithGraphPath:@"me/videos"
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];

   
}


- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"result %@",result );

    
    
    [activity.activityIndicator stopAnimating];
    [activity.view removeFromSuperview];

    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Video uploaded successfully" 
                                                              message:@""
                                                             delegate:nil 
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil] autorelease];
                [alert show];
    
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];           
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


- (void)uploadVideoFail:(ASIHTTPRequest *)request
{
    
    [myProgressIndicator   removeFromSuperview];
    
    [activity.activityIndicator stopAnimating];
    [activity.view removeFromSuperview];
    
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSLog(@"response String is %@",responseString);
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Video Uploading Failed." message:@"Video did not upload successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [myProgressIndicator removeFromSuperview];
}
- (void)uploadVideoFinished:(ASIHTTPRequest *)request
{
    
    [myProgressIndicator    removeFromSuperview];
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


-(IBAction)shareWithFriendsButtonPress:(id)sender
{

    FaceBookFriendsViewController *faceBookFriendsViewController=[[FaceBookFriendsViewController alloc]initWithNibName:@"FaceBookFriendsViewController" bundle:nil];
    faceBookFriendsViewController.selectedIndex=index;
    faceBookFriendsViewController.urlPathForVideo=urlpath;
    [self.navigationController pushViewController:faceBookFriendsViewController animated:YES];
    
}
-(IBAction)cancelButtonPress:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];

}
@end
