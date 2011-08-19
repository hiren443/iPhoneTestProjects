//
//  RootViewController.m
//  MyFriends
//
//  Created by Adnan Ahmad on 8/16/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import "RootViewController.h"
#import "MyFriendsAppDelegate.h"
#import "Loading.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Loading.h"
#import "FaceBookFriendsViewController.h"

@implementation RootViewController

@synthesize activity,faceBookConnectButton,timerFBLogin,friendListNSMutableArray,friendsListMutableDictionery;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title=@"View Friends";
    friendListNSMutableArray=[[NSMutableArray alloc]init];
    
    friendsListMutableDictionery =[[NSMutableDictionary alloc]init];
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
-(IBAction)facebookConnectButtonPressed{
    
   
    
    
    
    if ([friendListNSMutableArray count]>0) {
        
        FaceBookFriendsViewController *faceBookFriendsViewController=[[FaceBookFriendsViewController alloc]initWithNibName:@"FaceBookFriendsViewController" bundle:nil];
        
        faceBookFriendsViewController.faceBookFriendsNsMutableArray=friendListNSMutableArray;

        [self.navigationController pushViewController:faceBookFriendsViewController animated:YES];
    }
    else
    {
    
        if(activity == nil)
            activity = [[Loading alloc] initWithNibName:@"Loading" bundle:[NSBundle mainBundle]];
    
        [self.view insertSubview:activity.view aboveSubview:self.parentViewController.view];
        [activity.activityIndicator startAnimating];
    
    
        MyFriendsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate loginToFacebookAndDelegate:self];
    }
}


-(void)loginThroughFacebook{
    timerFBLogin = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(loginThroughFacebookInterm) userInfo:nil repeats:NO];
    NSLog(@"login through facebook ");
    
}
-(void)loginThroughFacebookInterm{
    
    MyFriendsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
    MyFriendsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
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
    


    FaceBookFriendsViewController *faceBookFriendsViewController=[[FaceBookFriendsViewController alloc]initWithNibName:@"FaceBookFriendsViewController" bundle:nil];
    
    faceBookFriendsViewController.faceBookFriendsNsMutableArray=friendListNSMutableArray;
    [self.navigationController pushViewController:faceBookFriendsViewController animated:YES];
}
@end
