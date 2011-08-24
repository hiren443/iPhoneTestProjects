//
//  RootViewController.m
//  video_recording
//
//  Created by Pavan Patel on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomCell.h"

#import "MovisAppDelegate.h"
#import <CoreMedia/CoreMedia.h>
#import "FBFunViewController.h"
@implementation RootViewController
//@implementation CameraViewController (CameraDelegateMethods)

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
	app = [[UIApplication sharedApplication]delegate];
	self.navigationItem.title = @"My Videos";
    tbl.dataSource = self;
	tbl.delegate = self;
    tbl.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowDivider.png"]];
	tbl.backgroundColor = [UIColor clearColor];
        //popUp.backgroundColor = [UIColor blackColor]; 
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Take Video" style:UIBarButtonItemStylePlain target:self action:@selector(showCameraUI)];
	
	imgArray = [[NSMutableArray alloc]init];
	[self showCameraUI];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    UIImage *modify = [UIImage imageNamed:@"Record_NavButton.png"];
	UIButton *modifybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[modifybutton setBackgroundImage: [modify stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
	modifybutton.frame= CGRectMake(250.0, 0.0, modify.size.width, modify.size.height);
	[modifybutton addTarget:self action:@selector(showCameraUI)    forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem* modifyItem = [[[UIBarButtonItem alloc] initWithCustomView:modifybutton]autorelease];
	self.navigationItem.rightBarButtonItem= modifyItem;
    pathOfVideos = [[NSMutableArray alloc] init];
	
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
                                    error:@""];
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
    tbl.separatorColor = [UIColor blueColor];
	[tbl reloadData];
    [super viewWillAppear:animated];
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
	
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
	
    infoDictionary = info;
    [infoDictionary retain];
    [self useBtnClicked];
    
    
//    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//
//	// Handle a movie capture
//    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
//		NSString *moviePath = [paths objectAtIndex:0];
//		
//		NSDate *currentDate = [NSDate date];
//		NSDateFormatter *dft = [[NSDateFormatter alloc] init];
//		[dft setDateFormat:@"YYYYMMdd'T'hh:mm:ssZ"];
//		NSString *videoName = [dft stringFromDate:currentDate];
//		moviePath = [NSString stringWithFormat:@"%@/%@.mp4",moviePath,videoName];
//		
//		NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath];
//		NSString *destinationPath =moviePath;
//		[[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destinationPath error:nil];
//    }
//	
//    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
//    [picker release];
//    [self viewWillAppear:YES];
//	[tbl reloadData];

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
		
//		NSDate *currentDate = [NSDate date];
//		NSDateFormatter *dft = [[NSDateFormatter alloc] init];
//		[dft setDateFormat:@"YYYYMMdd'T'hh:mm:ssZ"];
		NSString *videoName = strName;
		moviePath = [NSString stringWithFormat:@"%@/%@.mp4",moviePath,videoName];
		
		NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath];
        url = sourcePath;
        [url retain];
		NSString *destinationPath =moviePath;
		[[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destinationPath error:nil];
    }
	
    [[cameraUI parentViewController] dismissModalViewControllerAnimated: YES];
    [self viewWillAppear:YES];
	[tbl reloadData];

}

//-(void)generateImage
//{
//    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
//    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    generator.appliesPreferredTrackTransform=TRUE;
//    [asset release];
//    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
//    
//    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
//        if (result != AVAssetImageGeneratorSucceeded) {
//            NSLog(@"couldn't generate thumbnail, error:%@", error);
//        }
//        
//        UIImageView *imgg = [[UIImageView alloc]initWithImage:[UIImage imageWithCGImage:im]];
//        [imgArray addObject:imgg];
//        [imgArray retain];
////[button setImage:[UIImage imageWithCGImage:im] forState:UIControlStateNormal];
////        thumbImg=[[UIImage imageWithCGImage:im] retain];
//        [generator release];
//    };
//    
//    CGSize maxSize = CGSizeMake(320, 180);
//    generator.maximumSize = maxSize;
//    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
//    
//}
//


- (void) useBtnClicked
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Title for video" message:@"this gets covered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    [myAlertView addSubview:myTextField];
    [myTextField becomeFirstResponder];
    [myAlertView show];
    [myAlertView release];
    [myTextField setDelegate:self];
    [self becomeFirstResponder];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        strName = [NSString stringWithFormat:@"%@",myTextField.text];
        [strName retain];
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
    
    UIButton *temp = sender;
    app.nameVideo = [pathOfVideos objectAtIndex:temp.tag];
    [app.nameVideo retain];
    
    FBFunViewController *obj = [[FBFunViewController alloc] initWithNibName:@"FBFunViewController" bundle:nil];
	[self.navigationController pushViewController:obj animated:TRUE];
	[obj release];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pathOfVideos count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell =(CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.topLbl.textColor = [UIColor whiteColor];
    cell.topLbl.text = [pathOfVideos objectAtIndex:indexPath.row];
   	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	NSString *url = [NSString stringWithFormat:@"%@/%@",uniquePath,[pathOfVideos objectAtIndex:indexPath.row]];
    
    
	
	MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath: url]];
    
    UIImage *thumbnailImage = [moviePlayer1 thumbnailImageAtTime:0.2 timeOption:MPMovieTimeOptionExact];
    
    cell.iconImg.image = thumbnailImage;
    [moviePlayer1 stop];
//    if (imgArray){
//    cell.iconImg = [imgArray objectAtIndex:indexPath.row];
//    }
    cell.btn.hidden = false;
    cell.btn.tag = indexPath.row;
    [cell.btn addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchDown];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	self.navigationItem.rightBarButtonItem.enabled = FALSE;

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,[pathOfVideos objectAtIndex:indexPath.row]];
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
-(void)playMediaFinished:(NSNotification*)theNotification {
    [self.navigationController popViewControllerAnimated:YES];
	
	player = [theNotification object];
    
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];   
    [player.moviePlayer stop];
	
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

