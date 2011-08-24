//
//  StorageUrlClassViewController.m
//  Movis
//
//  Created by Adnan Ahmad on 8/21/11.
//  Copyright 2011 Emblemtechnologies Private Limited. All rights reserved.
//

#import "StorageUrlClassViewController.h"


@implementation StorageUrlClassViewController
@synthesize url,title,date;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.date forKey:@"date"];
    
}





- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if (self != nil) {
        
        self.url = [aDecoder decodeObjectForKey:@"name"];
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.date=[aDecoder decodeObjectForKey:@"date"];
    }
    
    return self;
    
    
}

@end
