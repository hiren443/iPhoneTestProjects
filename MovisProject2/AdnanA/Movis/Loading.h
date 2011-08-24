//
//  Loading.h
//  iRepairs
//
//  Created by M Uzair Arshad on 6/4/11.
//  Copyright 2011 Emblem Technologies (Pvt.) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Loading : UIViewController {
    
 	IBOutlet UIActivityIndicatorView *activityIndicator;
    
	
}

@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator;
@end
