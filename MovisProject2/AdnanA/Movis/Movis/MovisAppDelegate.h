//
//  MovisAppDelegate.h
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
@interface MovisAppDelegate : NSObject <UIApplicationDelegate,FBSessionDelegate> {
    Facebook *facebook;
    id delegateLoginView;
    NSMutableArray *friendsMutableArray;
    NSMutableArray *videoLinkNSMutableArray;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) Facebook *facebook;
@property(nonatomic,assign)    id delegateLoginView;
-(void)loginToFacebookAndDelegate:(id)delegateLogin;
@property(nonatomic,retain)    NSMutableArray *friendsMutableArray;
@property(nonatomic,retain) NSMutableArray *videoLinksNSMutableArray;
- (void)saveVideoUrl;
-(void)loadVideoUrl;

@end