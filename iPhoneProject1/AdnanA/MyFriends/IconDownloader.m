//
//  Created by Muhammad Uzair Arshad on 3/20/11.
//  Copyright 2011 Emblem Technologies (Pvt.) Ltd. All rights reserved.
//


#import "IconDownloader.h"
#import "FaceBookFriendsViewController.h"

#define kAppIconHeight 48


@implementation IconDownloader

@synthesize appRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;


#pragma mark

- (void)dealloc
{
    [appRecord release];
    [indexPathInTableView release];
    
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
   
	NSLog(@"value is of imageURLString%@",[appRecord objectForKey:@"imageURLString"]);
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[appRecord objectForKey:@"imageURLString"]]] delegate:self];
                       

    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
        
    [appRecord setObject:image forKey:@"image"];
    
    self.activeDownload = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    NSLog(@"indexPathInTableView %@",indexPathInTableView);
    NSLog(@"self.indexPathInTableView %@",self.indexPathInTableView);
    // call our delegate and tell it that our icon is ready for display
    [(FaceBookFriendsViewController*)delegate appImageDidLoad:self.indexPathInTableView];
}

@end

