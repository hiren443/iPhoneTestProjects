//
//  ShareVideoViewController.h
//  Movis
//
//  Created by Adnan Ahmad on 8/22/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
@class Loading;
@class Facebook;
@interface ShareVideoViewController : UIViewController<FBRequestDelegate> {
    
    int index;
    NSString *urlpath;
    UIProgressView *myProgressIndicator;
    Loading *activity;
    Facebook *facebook;
}

@property(nonatomic,assign)int index;

-(IBAction)shareWithMEButtonPress:(id)sender;
-(IBAction)shareWithFriendsButtonPress:(id)sender;
-(IBAction)cancelButtonPress:(id)sender;
@property(nonatomic,retain)    NSString *urlpath;
@property(nonatomic,retain)UIProgressView *myProgressIndicator;
@property(nonatomic,retain)Loading *activity;
@property(nonatomic,retain)    Facebook *facebook;

@end
