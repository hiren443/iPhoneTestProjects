//
//  MovisViewController.m
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MovisViewController.h"
#import "AppDelegate.h"
#import "VideosCC.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FBFunViewController.h"
#import <CoreMedia/CoreMedia.h>
#import "sqlite3.h"
#import "DBHandler.h"
#import "objVideo.h"
#import "MyCommonFunctions.h"

@implementation MovisViewController

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
//    pathOfVideos = [[NSMutableArray alloc] init];
//	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
//	NSString *uniquePath = [paths objectAtIndex:0];
//    
//	//pathOfVideos = [[NSFileManager defaultManager] directoryContentsAtPath:uniquePath];	
//	NSArray *pathOfVideos1 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:uniquePath error:nil];
//	[pathOfVideos1 retain];
//	
//    NSMutableArray* filesAndProperties = [[NSMutableArray alloc] init];
//    for(NSString* path in pathOfVideos1)
//    {
//        NSDictionary* properties = [[NSFileManager defaultManager]
//                                    attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",uniquePath,path]
//                                    error:@""];
//        NSDate* modDate = [properties objectForKey:NSFileModificationDate];
//        
//        [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
//                                       path, @"path",
//                                       modDate, @"lastModDate",
//                                       nil]];                 
//    }
//	NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastModDate" ascending:NO];
//	[filesAndProperties sortUsingDescriptors:[NSArray arrayWithObject:lastNameDescriptor]];
//    [filesAndProperties retain];
//	
//	for(int cnt= 0; cnt < [filesAndProperties count]; cnt++)
//	{
//		NSMutableDictionary *temDict = [[NSMutableDictionary alloc] init];
//		temDict = [filesAndProperties objectAtIndex:cnt];
//		[pathOfVideos addObject:[temDict objectForKey:@"path"]];
//		
//		
//	}
//	[pathOfVideos retain];
    [self GetAllVideos];
    tbl.separatorColor = [UIColor blueColor];
	[tbl reloadData];
    [super viewWillAppear:animated];
}

-(void)GetAllVideos
{
    NSString * sqlStr;
    if(pathOfVideos)
        [pathOfVideos removeAllObjects];
    else
        pathOfVideos=[[NSMutableArray alloc]init];
    
    sqlStr = [NSString stringWithFormat:@"select name, path,vid,imgname from video"];
	sqlite3_stmt *ReturnStatement = (sqlite3_stmt *) [DBHandler getStatement: sqlStr];
	while(sqlite3_step(ReturnStatement) == SQLITE_ROW)
	{ 
        objVideo *obj=[[objVideo alloc]init];
        
       obj.strVideoName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement,0)];
        obj.strVideoPath=[NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement,1)];
        obj.videoID=[[NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement,2)]intValue];
         obj.strimgName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement,3)];
        [pathOfVideos addObject:obj];
	} 

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
        MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath: destinationPath]];
        [moviePlayer1 stop];
        UIImage *thumbnailImage = [moviePlayer1 thumbnailImageAtTime:0.2 timeOption:MPMovieTimeOptionExact];
        NSString *strimgName=[MyCommonFunctions saveImageInDocuments:thumbnailImage];
        NSString * sqlStr = [NSString stringWithFormat:@"insert INTO video(path,name,imgname) values('%@','%@','%@')",destinationPath,strName,strimgName];
        [DBHandler InsUpdateDelData:sqlStr];
        
    }
	
    [[cameraUI parentViewController] dismissModalViewControllerAnimated: YES];
    [self viewWillAppear:YES];
    [self GetAllVideos];
	[tbl reloadData];
    
}


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
    objVideo *objv = [pathOfVideos objectAtIndex:temp.tag];
    [app.nameVideo retain];
    
    FBFunViewController *obj = [[FBFunViewController alloc] initWithNibName:@"FBFunViewController" bundle:nil];
    obj.obj=objv;
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

- (IBAction)DeleteButtonAction:(id)sender
{
	[pathOfVideos removeLastObject];
	[tbl reloadData];
}

- (IBAction) EditTable:(id)sender
{
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[tbl setEditing:NO animated:NO];
		[tbl reloadData];
		[btndelete setTitle:@"Delete" forState:UIControlStateNormal];
		//[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[tbl setEditing:YES animated:YES];
		[tbl reloadData];
        [btndelete setTitle:@"Done" forState:UIControlStateNormal];
		//[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		//[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.    
    if (self.editing && indexPath.row == ([pathOfVideos count])) 
	{
		return UITableViewCellEditingStyleInsert;
	} else 
	{
		return UITableViewCellEditingStyleDelete;
	}
    return UITableViewCellEditingStyleNone;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        objVideo *obj=[pathOfVideos objectAtIndex:indexPath.row];
        [MyCommonFunctions removeImageFromDocuments:obj.strimgName];
        [MyCommonFunctions removeImageFromDocuments:obj.strVideoName];
        [self DeleteVideoFromDatabase:obj.videoID];
        [pathOfVideos removeObjectAtIndex:indexPath.row];
		[tbl reloadData];
    } 
}

-(void)DeleteVideoFromDatabase:(int)ID
{
    NSString * sqlStr = [NSString stringWithFormat:@"Delete from video where vid=%d",ID];
    [DBHandler InsUpdateDelData:sqlStr];

}


#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	  toIndexPath:(NSIndexPath *)toIndexPath 
{
	NSString *item = [[pathOfVideos objectAtIndex:fromIndexPath.row] retain];
	[pathOfVideos removeObject:item];
	[pathOfVideos insertObject:item atIndex:toIndexPath.row];
	[item release];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [pathOfVideos count];
	//if(self.editing) count++;
	return count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"VideosCC";
    
    VideosCC *cell =(VideosCC*) [tbl dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UIViewController *c = [[UIViewController alloc] initWithNibName:@"VideosCC" bundle:nil];
		cell = (VideosCC *) c.view;
  		[c release];    
	}
    int count = 0;
	if(self.editing && indexPath.row != 0)
		count = 1;

    objVideo *obj=[pathOfVideos objectAtIndex:indexPath.row];
    cell.lblVideoName.text=obj.strVideoName;
    
    cell.imgViewVideoThumbnail.image =[MyCommonFunctions getImageFromDocuments:obj.strimgName];
   cell.btnShare.tag = indexPath.row;
    cell.btnPlayVideo.tag=indexPath.row;
    [cell.btnShare addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchDown];
    [cell.btnPlayVideo addTarget:self action:@selector(PlayVideo:) forControlEvents:UIControlEventTouchDown];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	self.navigationItem.rightBarButtonItem.enabled = FALSE;
    
 
}

-(IBAction)PlayVideo:(UIButton*)sender
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [paths objectAtIndex:0];
	uniquePath = [NSString stringWithFormat:@"%@/%@",uniquePath,[pathOfVideos objectAtIndex:sender.tag]];
    objVideo *obj=[pathOfVideos objectAtIndex:sender.tag];
    player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:obj.strVideoPath]]; 
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
