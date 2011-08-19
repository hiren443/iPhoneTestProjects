//
//  LoadingScreen.h
//  Sam Adams
//
//  Created by Vijay Kanse on 05/05/10.
//  Copyright 2010 bsmart. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SplashView.h"

@interface LoadingScreen : NSObject {

	SplashView *mySplash;
}

+(LoadingScreen *)sharedInstance;

-(void)startLoadingScreen;
- (void)startLoadingScreenWithTitle:(NSString *)title;
-(void)dismissLoadingScreen;

@end
