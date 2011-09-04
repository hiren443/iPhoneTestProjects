    //
//  MovisViewController.m
//  Movis2
//
//  Created by Eugene Pavlyuk on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MovisViewController.h"
#import "VideoTableViewCell.h"
#import "ShareViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GradientButton.h"

// apple import
#import <MobileCoreServices/UTCoreTypes.h>


@implementation ImageLoadingTask

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;
@synthesize indexPath;
@synthesize image;
@synthesize filename;

- (id) initWithDelegate:(NSObject<ImageLoaderDelegate>*)aDelegate
{
	self = [super init];
	
	if (self)
	{
		delegate = [aDelegate retain];
	}
	
	return self;
}

- (void)finish
{    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];	
}

- (BOOL)isConcurrent
{
    return YES;
}


- (void)start
{	
	if (![NSThread isMainThread])
	{
		[self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
		return;
	}
	
	[self willChangeValueForKey:@"isExecuting"];
	_isExecuting = YES;
	[self didChangeValueForKey:@"isExecuting"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	NSString *localUrl = [NSString stringWithFormat:@"%@/%@", uniquePath, filename];

	MPMoviePlayerController *moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath: localUrl]] autorelease];
	
	self.image = [moviePlayer thumbnailImageAtTime:0.2 timeOption:MPMovieTimeOptionExact];
	
	[moviePlayer stop];
	
	[delegate notifyWithTask:self];
	
	[self finish];
}

- (void) dealloc
{
	self.indexPath = nil;
	[delegate release];
	self.image = nil;
	self.filename = nil;
	[super dealloc];
}

@end



@interface MovisViewController()

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, retain) UITextField *myTextField;
@property (nonatomic, retain) NSDictionary *imagePickerDictionary;
@property (nonatomic, retain) NSMutableArray *pathOfVideos;

- (void)showCameraUI;
- (void)loadVideoFiles;

@end


@implementation MovisViewController

@synthesize fileName;
@synthesize myTextField;
@synthesize movisTableView;
@synthesize imagePickerDictionary;
@synthesize pathOfVideos;


- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self)
	{
		imagesArray = [[NSMutableArray alloc] init];
		pathOfVideos = [[NSMutableArray alloc] init];
		
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(shareButtonPressed:) 
													 name:kShareButtonPressedNotification 
												   object:nil];
	}
	
	return self;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self performSelector:@selector(showCameraUI) withObject:nil afterDelay:0.f];
	
	self.navigationItem.title = NSLocalizedString(@"Videos", @"Videos title");
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Camera", @"Camera button title") 
																			  style:UIBarButtonItemStyleBordered 
																			 target:self 
																			  action:@selector(showCameraUI)] autorelease];
	[self loadVideoFiles];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	
	self.movisTableView = nil;
}

- (void)loadVideoFiles
{	
    self.pathOfVideos = [NSMutableArray array];
	[imagesArray removeAllObjects];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
    
	NSArray *pathOfVideosTemp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:uniquePath error:nil];
	
    NSMutableArray *filesAndProperties = [[NSMutableArray alloc] init];
	
    for (NSString* path in pathOfVideosTemp)
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
		
	NSSortDescriptor *lastNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastModDate" ascending:NO] autorelease];
	[filesAndProperties sortUsingDescriptors:[NSArray arrayWithObject:lastNameDescriptor]];
	
	for (int cnt = 0; cnt < [filesAndProperties count]; cnt++)
	{
		NSMutableDictionary *temDict = [filesAndProperties objectAtIndex:cnt];
		[pathOfVideos addObject:[temDict objectForKey:@"path"]];
	}
	
	[filesAndProperties release];	
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.fileName = nil;
	self.myTextField = nil;
	self.movisTableView = nil;
	self.imagePickerDictionary = nil;
	[imagesArray release];
	[pathOfVideos release];
	[operationQueue cancelAllOperations];
	[operationQueue release];
    [super dealloc];
}

- (void) useBtnClicked
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Title for video" message:@"this gets covered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    self.myTextField = [[[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)] autorelease];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    [myAlertView addSubview:myTextField];
    [myTextField becomeFirstResponder];
    [myAlertView show];
    [myAlertView release];
    [myTextField setDelegate:self];
    [self becomeFirstResponder];
    
}

- (void)saveVideoFile
{
    NSString *mediaType = [self.imagePickerDictionary objectForKey: UIImagePickerControllerMediaType];
    
	// Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) 
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *moviePath = [paths objectAtIndex:0];
		
		NSString *extendedName = @"";
		int j = 0;
		BOOL exitLoop;
		
		NSString *filePath;
		
		do
		{
			j++;
			exitLoop = YES;
			NSString *videoName = self.fileName;
			filePath = [NSString stringWithFormat:@"%@/%@%@.mp4",moviePath,videoName, extendedName];
			
			if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
			{
				extendedName = [NSString stringWithFormat:@" %d", j];
				exitLoop = NO;
			}
			
		} while (!exitLoop);
		
		NSString *sourcePath = [[self.imagePickerDictionary objectForKey:@"UIImagePickerControllerMediaURL"] relativePath];
		NSString *destinationPath = filePath;
		
		[[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:nil];
    }
	
    [cameraUI dismissModalViewControllerAnimated:YES];
	[self loadVideoFiles];
	[movisTableView reloadData];	
}

- (BOOL) startCameraController
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
	{
        return NO;
	}
	
    cameraUI = [[[UIImagePickerController alloc] init] autorelease];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
	cameraUI.mediaTypes = [[[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil] autorelease];
	
	[self presentModalViewController:cameraUI animated: YES];
    return YES;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate's methods

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker 
{	
    [picker dismissModalViewControllerAnimated:YES];
}

// For responding to the user accepting a newly-captured picture or movie
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{	
    self.imagePickerDictionary = info;
    [self useBtnClicked];
}


#pragma mark -
#pragma mark IBOutlet's methods

- (void) showCameraUI 
{
    [self startCameraController];
}

- (void) shareButtonPressed:(NSNotification*)notification
{
	NSIndexPath *indexPath = [notification object];
	
	ShareViewController *shareViewController = [[[ShareViewController alloc] initWithNibName:@"ShareViewController" 
																					  bundle:nil] autorelease];
	shareViewController.filename = [pathOfVideos objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:shareViewController animated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate's methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate's methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	self.fileName = self.myTextField.text;
	
	if (!fileName || [fileName isEqualToString:@""])
	{
		self.fileName = [NSString stringWithFormat:@"untitled video"];
	}
	
	[self saveVideoFile];
}

#pragma mark -
#pragma mark UITableViewDataSource's methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [pathOfVideos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    VideoTableViewCell *videoTableViewCell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kVideoTableViewCellIdentifier];
	
    if (!videoTableViewCell) 
	{
        videoTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" owner:nil options:nil] lastObject];
    }
	
	videoTableViewCell.indexPath = indexPath;
	videoTableViewCell.filenameLabel.text = [pathOfVideos objectAtIndex:indexPath.row];
	
	UIImage *image = nil;
	
	if (indexPath.row < [imagesArray count])
	{
		image = [imagesArray objectAtIndex:indexPath.row];
	}
	
	if (image)
	{
		[videoTableViewCell.activityView stopAnimating];
	}
	else
	{
		[videoTableViewCell.activityView startAnimating];
	}
	
	videoTableViewCell.imageView.image = image;
	
	if (!image)
	{
		ImageLoadingTask *imageLoadingTask = [[[ImageLoadingTask alloc] initWithDelegate:self] autorelease];
		
		imageLoadingTask.indexPath = indexPath;
		imageLoadingTask.filename = [pathOfVideos objectAtIndex:indexPath.row];
		
		[operationQueue addOperation:imageLoadingTask];
	}
	
    return videoTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kDefaultCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,[pathOfVideos objectAtIndex:indexPath.row]];
	
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:uniquePath]]; 
    [self presentMoviePlayerViewControllerAnimated:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playMediaFinished:)                                                 
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:player];
	
	player.moviePlayer.shouldAutoplay = YES;
	[player.moviePlayer play];  
	
	[self.movisTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	VideoTableViewCell *cell = (VideoTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
	
	cell.shareButton.hidden = YES;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	VideoTableViewCell *cell = (VideoTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
	
	cell.shareButton.hidden = NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < [imagesArray count])
	{
		[imagesArray removeObjectAtIndex:indexPath.row];
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@", uniquePath,[pathOfVideos objectAtIndex:indexPath.row]];

	NSError *error = nil;
	
	[[NSFileManager defaultManager] removeItemAtPath:uniquePath error:&error];
	
	[pathOfVideos removeObjectAtIndex:indexPath.row];
	
	[tableView reloadData];
}

- (void)notifyWithTask:(ImageLoadingTask*)task
{
	[imagesArray addObject:task.image];
	
	[movisTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:task.indexPath] withRowAnimation:UITableViewRowAnimationNone];
	
}

@end
