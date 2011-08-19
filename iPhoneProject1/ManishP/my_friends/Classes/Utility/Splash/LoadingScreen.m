//
//  LoadingScreen.m
//  Sam Adams
//
//  Created by Vijay Kanse on 05/05/10.
//  Copyright 2010 bsmart. All rights reserved.
//

#import "LoadingScreen.h"


@implementation LoadingScreen

static LoadingScreen *shInstance = nil;

+(LoadingScreen *)sharedInstance
{
	if(shInstance == nil)
	{
		shInstance = [[LoadingScreen alloc] init];
	}
	return shInstance;
}

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		mySplash = [[SplashView alloc] init];

	}
	return self;
}

-(void)startLoadingScreen
{
	[mySplash startSplash];
}

- (void)startLoadingScreenWithTitle:(NSString *)title
{
	[mySplash startSplashWithTitle:title];
}

-(void)dismissLoadingScreen
{
	[mySplash dismissSplash];
}

@end
