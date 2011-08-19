//
//  SharedManager.h
//  My Friends
//
//  Created by Manish Patel on 16/08/11.
//  Copyright 2011 MacyMind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

@protocol LoginDelegate;
@protocol FriendsDelegate;


@interface SharedManager : NSObject<FBSessionDelegate, FBRequestDelegate>
{
	Facebook *facebook;
	NSString *facebookId;
	NSString *facebookAccessToken;
	id<LoginDelegate> loginDelegate;
	id<FriendsDelegate> friendsDelegate;
	BOOL loginInProcess;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSString *facebookId;
@property (nonatomic, retain) NSString *facebookAccessToken;

+ (SharedManager *)sharedInstance;
- (void)loginWithFacebookDelegate:(id<LoginDelegate>)delegate;
- (void)logoutWithDelegate:(id<LoginDelegate>)delegate;

-(void)getFriendList:(id<FriendsDelegate>)delegate;

@end


@protocol LoginDelegate<NSObject>

@optional

- (void)sharedManagerDidLogin:(SharedManager *)sharedManager;
- (void)sharedManager:(SharedManager *)sharedManager failedLoginWithError:(NSError *)error;
- (void)sharedManagerDidLogout:(SharedManager *)sharedManager;

@end

@protocol FriendsDelegate<NSObject>

- (void)sharedManager:(SharedManager *)sharedManager didLoadFriedList:(NSArray *)friends;
- (void)sharedManager:(SharedManager *)sharedManager failedWithError:(NSError *)error;

@end
