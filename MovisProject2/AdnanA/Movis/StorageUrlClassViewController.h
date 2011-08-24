//
//  StorageUrlClassViewController.h
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StorageUrlClassViewController : NSObject <NSCoding>{
    
    
    NSString *url;
    NSString *title;
    NSString *date;
    
}

@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *date;
@end
