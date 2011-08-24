//
//  MovisAppDelegate.m
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import "MovisAppDelegate.h"
#import "RootViewController.h"
#import "StorageUrlClassViewController.h"
#import "RecordingTableViewController.h"
@implementation MovisAppDelegate



@synthesize window=_window;

@synthesize navigationController=_navigationController;
@synthesize facebook;
@synthesize delegateLoginView;
@synthesize friendsMutableArray;
@synthesize videoLinksNSMutableArray;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self loadVideoUrl];
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    friendsMutableArray=[[NSMutableArray alloc]init];
    videoLinksNSMutableArray =[[NSMutableArray alloc]init];
    facebook = [[Facebook alloc] initWithAppId:@"145062165564860"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
 
    [self saveVideoUrl];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

///This function is called by facebook app.
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
    //NSLog(@"value of url is %@",url);
    
    [(RecordingTableViewController *)delegateLoginView loginThroughFacebook];
    return [facebook handleOpenURL:url]; 
}


-(void)loginToFacebookAndDelegate:(id)delegateLogin{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
   
       // [facebook authorize:nil delegate:self];
        NSArray* permissions =  [[NSArray arrayWithObjects:
                         @"email",@"read_stream",@"publish_stream",@"user_about_me", nil] retain];
        [facebook authorize:permissions delegate:self];  
        //[facebook authorize:nil delegate:self];  
        delegateLoginView = [delegateLogin retain];        
    
   
}

#pragma fb Session Delegate
- (void)fbDidLogin {
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

///////For data presistence URLS of User Saved videos///

- (void)loadVideoUrl{
    
    
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSMutableString *savePath = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
    
    [savePath appendString:@"/links.plist"];
    
    
    NSData* data = [NSData dataWithContentsOfFile:savePath];
    
    NSMutableArray *rootObject = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self.videoLinksNSMutableArray removeAllObjects];
    if(rootObject != nil){
        for (int i = 0; i < [rootObject count]; i++) {
            StorageUrlClassViewController *storage = (StorageUrlClassViewController *)[rootObject objectAtIndex:i];
            [self.videoLinksNSMutableArray addObject:storage ];
        }
    }
    
    
    
}





- (void)saveVideoUrl{
    
    
    
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSMutableString *savePath = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
    [savePath appendString:@"/links.plist"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.videoLinksNSMutableArray];
    [data writeToFile:savePath atomically:YES];
    
}


/*
- (void)loadScanItems{
    
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSMutableString *savePath = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
    
    [savePath appendString:@"/scan.plist"];
    
    
    NSData* data = [NSData dataWithContentsOfFile:savePath];
    
    NSMutableArray *rootObject = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    Item *temp = (Item *)[rootObject objectAtIndex:0];
    
    NSLog(@"%@",temp.code);
    
    [scanImageArray removeAllObjects];
    if(rootObject != nil){
        for (int i = 0; i < [rootObject count]; i++) {
            Item *temp = (Item *)[rootObject objectAtIndex:i];
            [scanImageArray addObject:temp ];
        }
    }
    
    
}
- (void)saveScanItems{
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSMutableString *savePath = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
    
    [savePath appendString:@"/scan.plist"];
    
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:scanImageArray];
    
    [data writeToFile:savePath atomically:YES];
}




*/




- (void)dealloc
{
    [facebook release];
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
