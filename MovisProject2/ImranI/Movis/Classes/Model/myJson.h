//
//  Json.h
//  airflow
//
//  Created by Awais Lodhi on 02/03/10.
//  Copyright 2010 Suave Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
//#import "ASIFormDataRequest.h"

@interface Json : NSObject {
}

+ (NSString *)stringWithUrl:(NSURL *)url;
+ (id) objectWithUrl:(NSURL *)url;
+ (id) objectWthString:(NSString *) jsonString;

+(id) postToWebwithURL: (NSString *) urlString andBody:(NSString *) requestBody;
//+ (id) postFileToWebwithURL: (NSString *) urlString key:(NSString *) key fileData:(NSData *) fileData andFilename:(NSString *) fileName withContentType:(NSString *) contentType;

+(void) stopSpinner;
+(void) startSpinner;
@end
