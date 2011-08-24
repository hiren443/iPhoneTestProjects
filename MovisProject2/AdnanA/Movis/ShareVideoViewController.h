//
//  ShareVideoViewController.h
//  Movis
//
//  Created by Adnan Ahmad on 8/22/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Loading;
@interface ShareVideoViewController : UIViewController {
    
    int index;
    NSString *urlpath;
    UIProgressView *myProgressIndicator;
    Loading *activity;
}

@property(nonatomic,assign)int index;

-(IBAction)shareWithMEButtonPress:(id)sender;
-(IBAction)shareWithFriendsButtonPress:(id)sender;
-(IBAction)cancelButtonPress:(id)sender;
@property(nonatomic,retain)    NSString *urlpath;
@property(nonatomic,retain)UIProgressView *myProgressIndicator;
@property(nonatomic,retain)Loading *activity;
@end
