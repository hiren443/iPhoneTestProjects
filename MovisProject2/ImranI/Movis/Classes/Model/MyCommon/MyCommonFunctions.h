//
//  AppDelegate.m
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MyCommonFunctions : NSObject {

	
}


+ (NSString*)saveImageInDocuments:(UIImage*)senderImage;
+ (UIImage*)getImageFromDocuments:(NSString*)senderImageName;
+ (void)removeImageFromDocuments:(NSString*)fileName;
+(UIImage *)getOrDownloadImage:(NSString*)photoUrl;
+(bool) doesFileExist: (NSString *)filePath;
+ (NSString *)dateStringFromString:(NSString *)sourceString sourceFormat:(NSString *)sourceFormat destinationFormat:(NSString *)destinationFormat;
+ (NSString *)dateStringWithStyle:(NSDateFormatterStyle)style;
+ (void)isUserRemembered ;
+ (UIImage*)scaleImage:(UIImage *)img toSize:(CGSize) targetSize;
+(BOOL)contains:(NSString*) strContains InString:(NSString*)targetString;
+(BOOL)isCoordinateValid:(NSString*)coordinate;
+(BOOL)isEmailValid:(NSString*)emailAddress;



@end
