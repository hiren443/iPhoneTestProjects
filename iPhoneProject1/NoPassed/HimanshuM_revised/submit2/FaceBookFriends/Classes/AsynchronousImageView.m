//
//  AsynchronousImageDownloader.m
//  FacebookConnect
//
//  
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousImageView.h"

@interface AsynchronousImageView ()
@property(nonatomic,retain) NSURLConnection* connection;
@property(nonatomic,retain) NSMutableURLRequest* request;
@property(nonatomic,retain) NSMutableData* data;
@end

@implementation AsynchronousImageView
@synthesize url,delegate,profileId,data,request,connection;


-(id)initWithDelegate:_delegate {
	self=[super init];
	if (self) {
	self.delegate=_delegate;
	}
	return self;

}

-(void)startImageDownloadWithImageURL:(NSURL*)_url andProfileId:(NSString*)_profileId 
{	
	self.url=_url;
	self.profileId=_profileId;
	self.request =[NSMutableURLRequest requestWithURL:url];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		
}


#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
		
	}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data {
	if (data==nil) {
	self.data=[NSMutableData data];
	}
	
	[data appendData:_data];

}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.image=[UIImage imageWithData:data];
	[delegate imageView:self withImage:self.image andProfileId:self.profileId];
}


-(void)dealloc
{	[profileId release];
	[url release];
	[data release];
	[request release];
	[connection release];
	[super dealloc];
}
@end
