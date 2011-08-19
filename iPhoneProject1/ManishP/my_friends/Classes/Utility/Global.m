//
//  Global.m
//  TimeBang
//
//  Created by Manish Patel on 26/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Global.h"

@implementation Global


+ (void)showAlert:(NSString *)title message:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
