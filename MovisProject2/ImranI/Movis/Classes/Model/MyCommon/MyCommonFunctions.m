//
//  AppDelegate.m
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCommonFunctions.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "myJson.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@implementation MyCommonFunctions

 

#pragma mark -
#pragma mark IMAGE_FUNCTIONS

+ (NSString*)saveImageInDocuments:(UIImage*)senderImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSDate *selected = [NSDate date];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"ddmmyyyyhhmmss"];
	NSString *imgName = [dateFormat stringFromDate:selected];
	imgName = [NSString stringWithFormat:@"%@.jpg",imgName];

	NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imgName];
	
	UIImage *image = senderImage;
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
	[imageData writeToFile:savedImagePath atomically:YES];
	return imgName;
}

+ (UIImage*)getImageFromDocuments:(NSString*)senderImageName {
	
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:senderImageName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL fileExist = [fileManager fileExistsAtPath:getImagePath]; // Returns a BOOL  
	
	UIImage *img = [[UIImage alloc] init];
	if(fileExist)
	{
		img = [[UIImage alloc] init];
		img = [UIImage imageWithContentsOfFile:getImagePath];
	}
	return img;
}

+ (void)removeImageFromDocuments:(NSString*)fileName {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];	 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	 
	NSString *documentsDirectory = [paths objectAtIndex:0];	 
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
	
	[fileManager removeItemAtPath: fullPath error:NULL];
	
	NSLog(@"image removed");
}


+(NSString*)replaceURLAndRetrunImageName:(NSString*)URL
{
	NSString *strContains = [NSString stringWithFormat:@"/"];
	NSString *currentCharacter = @"";
	for (int i =0; i< [URL length]; i++) {
		unichar ch = [URL characterAtIndex:i];
		NSString *str = [NSString stringWithCharacters:&ch length:1];		
		currentCharacter = [NSString stringWithFormat:@"%@", str];
		if([currentCharacter isEqualToString:strContains])
		{
			URL = [URL substringFromIndex:i+1];
			i = 0;
		}
	}
	return URL;
}
+(bool) doesFileExist: (NSString *)filePath 
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+(UIImage *)getOrDownloadImage:(NSString*)photoUrl
{
	if (!photoUrl) {
		return nil;
	}
	if ([[photoUrl lowercaseString] isEqualToString:@"na"]) {
		return nil;
	}
	NSString *targetString = photoUrl;
	NSString *myImageName = @"";	
	myImageName = [MyCommonFunctions replaceURLAndRetrunImageName:targetString];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString * filePath =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", myImageName]];
	//NSLog(filePath);
	UIImage *image;
	
	if(![myImageName isEqualToString:@""])
	{	
		if([self doesFileExist:filePath])
		{
			NSLog(@"Image Found.");
			image = [UIImage imageWithContentsOfFile:filePath];
			return image;
		}
	}
	
	NSData *receivedData = [[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]] retain];
	if([receivedData length] > 0)
	{
		image = [UIImage  imageWithData:receivedData];		
		NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
		[imageData writeToFile:filePath atomically:YES];
		NSLog(@"Image downloaded to documents.");
	}
	return image;
}

+(UIImage *)getOrDownloadASyncImage:(NSString*)photoUrl
{
	if (!photoUrl) {
		return nil;
	}
    
	UIImageView *tempImgView = [[UIImageView alloc] init];
    [tempImgView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"noProfile.png"]];
	return tempImgView.image;
}


#pragma mark - DATE_FUNCTIONS

/* 
 SAMPLE CODE
 
 NSString *inputDateString = @"2007-08-11T19:30:00Z";
 NSString *outputDateString = [NSDateFormatter
 dateStringFromString:inputDateString
 sourceFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"
 destinationFormat:@"h:mm:ssa 'on' MMMM d, yyyy"];
 */
+ (NSString *)dateStringFromString:(NSString *)sourceString sourceFormat:(NSString *)sourceFormat destinationFormat:(NSString *)destinationFormat
{
	
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:sourceFormat];
    NSDate *date = [dateFormatter dateFromString:sourceString];
    [dateFormatter setDateFormat:destinationFormat];
    return [dateFormatter stringFromDate:date];
}


/*
 SAMPLE CODE
 NSString *dateString = [[NSDate date] dateStringWithStyle:NSDateFormatterLongStyle];
 */

+ (NSString *)dateStringWithStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:style];
    return [dateFormatter stringFromDate:self];
}




#pragma mark -
#pragma mark OTHER_FUNCTIONS


+ (void)isUserRemembered {
	/*
	
	NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
	NSData *dataRepresentingUser = [currentDefaults objectForKey:@"savedUser"];
	
	
	
	UserClass *savedUser;
	
	if ([dataRepresentingUser length] > 0) // user is already remembered
	{
		savedUser = (UserClass*)[NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingUser];
		[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:savedUser] forKey:@"currentUser"];
	}
	else 
	{
		savedUser = nil;
	}
	
	if(!savedUser) // show login screen
	{
		// Override point for customization after app launch    
		Share_Your_RockViewController *syr = [[Share_Your_RockViewController alloc]initWithNibName:@"Share_Your_RockViewController" bundle:[NSBundle mainBundle]];
		navigationController = [[UINavigationController alloc]initWithRootViewController:syr]; 
		
		[navigationController.view addSubview:syr.view];
		
		[window addSubview:navigationController.view];		
	}
	else
	{
		if(savedUser.language  != nil)			
			if([savedUser.language isEqualToString:@"Spanish"])
			{
				isEnglishLanguage = NO;
			}
		// go to main menu view controller
		MainMenuViewController *mmvc = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:[NSBundle mainBundle]];
		navigationController = [[UINavigationController alloc]initWithRootViewController:mmvc]; 
		
		[navigationController.view addSubview:mmvc.view];
		
		[window addSubview:navigationController.view];
	}*/
}

+ (NSString *)stringWithUrl:(NSURL *)url {
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}
 
+ (UIImage*)scaleImage:(UIImage *)img toSize:(CGSize) targetSize {
    if (img == nil)
        return nil;
        
    UIImage * sourceImage = img;
	
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
	//    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
		//        if (widthFactor > heightFactor) 
		//            scaleFactor = widthFactor; // scale to fit height
		//        else
		//            scaleFactor = heightFactor; // scale to fit width
		//        scaledWidth  = width * scaleFactor;
		//        scaledHeight = height * scaleFactor;
        
        scaledWidth = width * widthFactor;
        scaledHeight = height * heightFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+(BOOL)contains:(NSString*) strContains InString:(NSString*)targetString {
	//NSNotFound is a built i variable; it's value is 0
	
	if([[NSString stringWithFormat:@"%@", targetString] isEqualToString:@"(null)"] == TRUE)
		return FALSE;
	if([targetString length] == 0)
		return FALSE;
	
	if ([targetString rangeOfString:strContains].location == NSNotFound) {
		return FALSE;
	} else {
		return TRUE;		
	}
}


+(BOOL)isCoordinateValid:(NSString*)coordinate
{
	if([[NSString stringWithFormat:@"%@", coordinate] isEqualToString:@"(null)"] == TRUE)
		return FALSE;
	if([coordinate length] == 0)
		return FALSE;
	
	NSString *RegEx = @"[-]?[0-9]{1,3}[.]{1}[0-9]{2,6}";

	NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", RegEx];
	BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:coordinate];
	if(!myStringMatchesRegEx)
	{
		return FALSE;
	}
	return TRUE;
}


+(BOOL)isEmailValid:(NSString*)emailAddress
{
	if([[NSString stringWithFormat:@"%@", emailAddress] isEqualToString:@"(null)"] == TRUE)
		return FALSE;
	if([emailAddress length] == 0)
		return FALSE;
		
	NSString *email = [emailAddress lowercaseString];
	NSString *emailRegEx =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

	NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
	if(!myStringMatchesRegEx)
	{		
		return FALSE;
	}
	return TRUE;
}



@end
