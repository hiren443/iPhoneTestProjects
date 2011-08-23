//
//  MyFriendsAppDelegate.h
//  MyFriends
//
//  Created by Adnan Ahmad on 8/16/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface MyFriendsAppDelegate : NSObject <UIApplicationDelegate> {

    Facebook *facebook;
    id delegateLoginView;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) Facebook *facebook;
@property(nonatomic,assign)    id delegateLoginView;
-(void)loginToFacebookAndDelegate:(id)delegateLogin;

@end
