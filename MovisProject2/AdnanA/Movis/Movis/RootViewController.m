//
//  RootViewController.m
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.

#import "RootViewController.h"
#import "MovisAppDelegate.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import "StorageUrlClassViewController.h"
#import "RecordingTableViewController.h"

@implementation RootViewController

@synthesize  currentVideoPath;
@synthesize  player;
@synthesize  cameraUI;
@synthesize  infoDictionary;
@synthesize  myTextField;
@synthesize recordingTableViewController;

#pragma mark -
#pragma mark View lifecycle


-(void)dealloc
{
    
    [currentVideoPath retain];
    [player retain];
    [cameraUI retain];
    [infoDictionary retain];
    [myTextField retain];
    [super dealloc];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

	
    self.navigationItem.title = @"My Videos";
    [self showCameraUI];
 
}
- (void)viewWillAppear:(BOOL)animated {

    [self showCameraUI];

   
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>) delegate {
	
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil))
        return NO;
	
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
	cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
	
	[controller presentModalViewController: cameraUI animated: YES];
    //cameraUI.cameraOverlayView = overlayview;
    return YES;
}
// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
	
   // [[picker parentViewController] dismissModalViewControllerAnimated: YES];
   // [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
	
    infoDictionary = info;
    [infoDictionary retain];
    [self useBtnClicked];
    
    
}

-(void)saveMedia
{
    NSDictionary *info = infoDictionary;
    [info retain];
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
	// Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *moviePath = [paths objectAtIndex:0];
		
        MovisAppDelegate *appDelegate=(MovisAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        int countValue =[appDelegate.videoLinksNSMutableArray count];
        
        StorageUrlClassViewController *storage=(StorageUrlClassViewController *)[appDelegate.videoLinksNSMutableArray objectAtIndex:countValue-1];
      
		NSString *videoName = storage.title;
		moviePath = [NSString stringWithFormat:@"%@/%@.mp4",moviePath,videoName];
		
		NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath];
        
        NSLog(@"movie path %@",moviePath);
       
        NSString *destinationPath =moviePath;
		[[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destinationPath error:nil];
        
    }
    
    StorageUrlClassViewController *storage=[[StorageUrlClassViewController alloc]init];
	
    storage.url=[[infoDictionary objectForKey:@"UIImagePickerControllerMediaURL"] relativePath];

    [[cameraUI parentViewController] dismissModalViewControllerAnimated: YES];

    recordingTableViewController =[[RecordingTableViewController alloc]initWithNibName:@"RecordingTableViewController" bundle:nil];
    [self.navigationController   pushViewController:recordingTableViewController animated:YES];
    
    
       
    
}



- (void) useBtnClicked
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Title for video" message:@"this gets covered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    [myAlertView addSubview:myTextField];
    [myAlertView show];
    [myAlertView release];
    [myTextField setDelegate:self];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        StorageUrlClassViewController *storage =[[StorageUrlClassViewController alloc]init];
        storage.title=myTextField.text;
    
        /////Date////
        NSDateFormatter *formatter;
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        storage.date = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        
        NSLog(@"vaue of date is %@",storage.date);
        NSLog(@"value of url is %@",storage.url);
        NSLog(@"value of storage title %@",storage.title);
        MovisAppDelegate *appDelegate =(MovisAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.videoLinksNSMutableArray addObject:storage];
    
        [storage release];
        [self saveMedia];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction) showCameraUI {
    [self startCameraControllerFromViewController: self usingDelegate: self];
}

- (IBAction) showShare:(id) sender {
    
   // UIButton *temp = sender;
   // app.nameVideo = [pathOfVideos objectAtIndex:temp.tag];
    //[app.nameVideo retain];
    
       
}



@end

