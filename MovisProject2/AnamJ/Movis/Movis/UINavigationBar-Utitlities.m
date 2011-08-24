//
//  UINavigationBar-Utitlities.m
//  CoreDataBooks
//
//  Created by Saad Mubarak on 5/3/10.
//  Copyright 2010 Beaconhouse National University. All rights reserved.
//

#import "UINavigationBar-Utitlities.h"
#import <QuartzCore/QuartzCore.h>



@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
	
	UIColor *color = [UIColor blackColor];
	
	UIImage *img  = [UIImage imageNamed: @"Navbar.png"];
	
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	//self.backgroundColor=color;
	self.tintColor = color;
 
    //[label sizeToFit];
    //self.topItem.titleView = label;
	
}

@end