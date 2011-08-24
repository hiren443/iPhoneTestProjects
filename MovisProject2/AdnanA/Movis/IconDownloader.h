//
//  Created by Muhammad Uzair Arshad on 3/20/11.
//  Copyright 2011 Emblem Technologies (Pvt.) Ltd. All rights reserved.
//


@class RootViewController;

//@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject
{
    NSMutableDictionary *appRecord;
    NSIndexPath *indexPathInTableView;
    id  delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) NSMutableDictionary *appRecord;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id  delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end
