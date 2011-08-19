//
//  SharedManager.m
//  My Friends
//
//  Created by Manish Patel on 16/08/11.
//  Copyright 2011 MacyMind. All rights reserved.
//

#import "SharedManager.h"

static SharedManager *sharedObj;


#define MM_FACEBOOK_APP_ID @"145062165564860"

@implementation SharedManager

@synthesize facebook, facebookId, facebookAccessToken;


+ (SharedManager *)sharedInstance
{
	if(!sharedObj)
	{
		sharedObj = [[SharedManager alloc] init];
		sharedObj.facebook = [[[Facebook alloc] initWithAppId:MM_FACEBOOK_APP_ID] autorelease];
		NSLog(@"FB Access Token: %@", sharedObj.facebook.accessToken);
		//sharedObj.facebook.accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessToken"];
		sharedObj.facebookAccessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessToken"];
	}
	return sharedObj;
}

- (void)dealloc
{
	[facebook release];
	[facebookId release];
	[facebookAccessToken release];
	[super dealloc];
}


- (void)loginWithFacebookDelegate:(id<LoginDelegate>)delegate
{
	if(!loginInProcess)
	{
		loginDelegate = delegate;
		loginInProcess = YES;
		
		[facebook authorize:
		 [NSArray arrayWithObjects:
//		  @"read_stream", @"offline_access", @"email", @"publish_stream", @"user_location", @"read_friendlists", nil]
		  @"offline_access", @"read_friendlists", nil]
			   delegate:self];
	}
}

-(void)getFriendList:(id<FriendsDelegate>)delegate
{
	friendsDelegate = delegate;
	[self.facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}


- (void)logoutWithDelegate:(id<LoginDelegate>)delegate
{
	loginDelegate = delegate;
	loginInProcess = YES;
	[facebook logout:self];
}


#pragma mark -
#pragma mark Facebook delegate
#pragma mark -

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin
{
	NSString *accessToken = self.facebook.accessToken;
	NSLog(@"Facebook accessToken:%@", accessToken);
	self.facebookAccessToken = accessToken;
	[[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"FBAccessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[loginDelegate sharedManagerDidLogin:self];
	//[self.facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled
{
	NSString *message = @"Unable to complete login with facebook. Please try again latter.";
	if(cancelled)
		message = @"You just cancelled login with facebook. Please try again latter.";
	NSError *error = [NSError errorWithDomain:@"APICallerDomain" code:1000 userInfo:[NSDictionary dictionaryWithObject:message forKey:@"NSLocalizedDescription"]];
	if(loginDelegate && [loginDelegate respondsToSelector:@selector(sharedManager:failedLoginWithError:)])
	{
		[loginDelegate sharedManager:self failedLoginWithError:error];
	}
	loginInProcess = NO;
	[[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"FBAccessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"did not login, Cancelled:%d", cancelled);
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout
{
	NSLog(@"Logged out from facebook");
	self.facebookId = @"";
	loginInProcess = NO;
	if(loginDelegate && [loginDelegate respondsToSelector:@selector(sharedManagerDidLogout:)])
		[loginDelegate sharedManagerDidLogout:self];
	[[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"FBAccessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
	NSLog(@"Result:%@", result);
	if ([result isKindOfClass:[NSArray class]])
	{
		result = [result objectAtIndex:0];
	}
	NSArray *friends = [result valueForKey:@"data"];
	if(friends && [friends isKindOfClass:[NSArray class]]) // We got friends list from facebook
	{
		if(friendsDelegate && [friendsDelegate respondsToSelector:@selector(sharedManager:didLoadFriedList:)])
		{
			[friendsDelegate sharedManager:self didLoadFriedList:friends];
		}
	}
	else if(friendsDelegate && [friendsDelegate respondsToSelector:@selector(sharedManager:failedWithError:)])
	{
		NSString *message = @"Unable to load friend list. Please try again latter.";
		NSError *error = [NSError errorWithDomain:@"APICallerDomain" code:1000 userInfo:[NSDictionary dictionaryWithObject:message forKey:@"NSLocalizedDescription"]];
		[friendsDelegate sharedManager:self failedWithError:error];
	}
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"Failed to perform request:%@", error);
	if(loginDelegate && [loginDelegate respondsToSelector:@selector(sharedManager:failedLoginWithError:)])
	{
		[loginDelegate sharedManager:self failedLoginWithError:error];
	}
}



@end
