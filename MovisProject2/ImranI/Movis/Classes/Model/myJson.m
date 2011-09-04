//
//  Json.m

#import "myJson.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "defines.h"

@implementation Json

 
+(void) stopSpinner
{
    [APPDELEGATE hideBusyView];
}

+(void) startSpinner
{
    [APPDELEGATE showBusyView];
}


+ (NSString *)stringWithUrl:(NSURL *)url
{
    
    if(kShowLog)
        NSLog(@"%@", url);
    
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

+ (id) objectWithUrl:(NSURL *)url
{

	SBJsonParser *jsonParser = [SBJsonParser new];
	if(![Reachability internetAvailable])
    {
        ALERT_VIEW(@"Please check your internet connection.");
        return nil;
    }
    
    NSString *jsonString = [self stringWithUrl:url];
	//	NSLog(jsonString);
	// Parse the JSON into an Object
	
    
    
	return [jsonParser objectWithString:jsonString error:NULL];
}

+ (id) objectWthString:(NSString *) jsonString
{
	SBJsonParser *jsonParser = [SBJsonParser new];
             
	return [jsonParser objectWithString:jsonString error:NULL];
}




+(id) postToWebwithURL: (NSString *) urlString andBody:(NSString *) requestBody
{
	NSURL * url = [NSURL URLWithString:urlString];
	
	NSMutableURLRequest * theRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	
	NSMutableData *theRequestData = [NSMutableData dataWithBytes: [requestBody UTF8String] length: [requestBody length]];
	
	[theRequest setHTTPBody:theRequestData];
	
	[theRequest setURL:url];
	[theRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[theRequest setTimeoutInterval:30];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setValue:[NSString stringWithFormat:@"%d",[requestBody length] ] forHTTPHeaderField:@"Content-Length"];


	NSMutableData * webData = (NSMutableData *) [NSURLConnection sendSynchronousRequest: theRequest returningResponse: nil error: nil ];
	
	NSString * str = [[[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding] autorelease];
//	NSLog(str);
	return [self objectWthString:str];
}

/*
//List of Content Types http://www.w3schools.com/media/media_mimeref.asp
+ (id) postFileToWebwithURL: (NSString *) urlString key:(NSString *) key fileData:(NSData *) fileData andFilename:(NSString *) fileName withContentType:(NSString *) contentType
{
	NSURL * url = [NSURL URLWithString:urlString];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostFormat:ASIMultipartFormDataPostFormat];
	[request setPostValue:key forKey:@"key"];
	[request setData:fileData withFileName:fileName andContentType:contentType forKey:@"file"];
	[request setRequestMethod:@"POST"];
	[request startSynchronous];

	NSError *error = [request error];
	if (!error) 
	{
		NSString *response = [request responseString];
//		NSLog(response);
		return [self objectWthString: response];
	}
	else
		return nil;
//		NSString * str = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
//		NSLog(str);
//		return [self objectWthString:str];
	
}
*/

@end
