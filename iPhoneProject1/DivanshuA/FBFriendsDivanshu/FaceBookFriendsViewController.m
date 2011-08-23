//
//  FaceBookFriendsViewController.m
//  MyFriends
//
//  Created by Adnan Ahmad on 8/16/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import "FaceBookFriendsViewController.h"
#import "FriendsCustomCell.h"

@implementation FaceBookFriendsViewController

@synthesize faceBookFriendsNsMutableArray,imageDownloadsInProgress,friendTableView;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [imageDownloadsInProgress release];
    [faceBookFriendsNsMutableArray release];
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

    self.title=@"Friends";
    imageDownloadsInProgress=[[NSMutableDictionary alloc]init];
    self.navigationItem.hidesBackButton=YES;    
    
    UIBarButtonItem *home = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Home"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = home;
    [home release];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [faceBookFriendsNsMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
      
        static NSString *CellIdentifier = @"FriendsCustomCell";
        FriendsCustomCell *cell = (FriendsCustomCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FriendsCustomCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (FriendsCustomCell*) currentObject;
                    break;
                }
            }
        }
        
        
        CALayer * l = [cell.imageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        // You can even add a border
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
    
    
    
    cell.name.text=[[faceBookFriendsNsMutableArray  objectAtIndex:indexPath.row] objectForKey:@"name"]; 
    
    
    if (![[faceBookFriendsNsMutableArray objectAtIndex:indexPath.row] objectForKey:@"image"])
    {
        if (self.friendTableView.dragging == NO && self.friendTableView.decelerating == NO)
        {
            [self startIconDownload:[faceBookFriendsNsMutableArray  objectAtIndex:indexPath.row] forIndexPath:indexPath];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"review.png"];                
        
    }
    else
    {
        
        cell.imageView.image = [[faceBookFriendsNsMutableArray objectAtIndex:indexPath.row] objectForKey:@"image"];
        
    }
    

        
        
    // Configure the cell...
    
    return cell;
}


#pragma mark -
#pragma mark Start Custom Functions
#pragma mark -
- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}
// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([faceBookFriendsNsMutableArray count] > 0)
    {
        NSArray *visiblePaths = [friendTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths){
            if(indexPath.row < [faceBookFriendsNsMutableArray  count]){
                NSMutableDictionary *appRecord = [faceBookFriendsNsMutableArray  objectAtIndex:indexPath.row];
                
                if (![appRecord objectForKey:@"image"]) // avoid the app icon download if the app already has an icon
                {
                    [self startIconDownload:appRecord forIndexPath:indexPath];
                }
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
        IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
        if (iconDownloader != nil)
        {
            FriendsCustomCell *cell =(FriendsCustomCell*)[friendTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
            cell.imageView.image = [iconDownloader.appRecord objectForKey:@"image"];
            
        }
        
    
}

#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        [self loadImagesForOnscreenRows];
        
    
}
-(void)backAction
{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
