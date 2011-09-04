/*
 * Copyright 2009 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

#import "FBConnect/FBLoginDialog.h"
#import "FBConnect/FBSession.h"
#import "FBConnect/FBRequest.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

#define kDefaultTitle  @"Connect to Facebook"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBLoginDialog

@synthesize apiKey;
@synthesize requestedPermissions;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)loadLoginPage 
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	
    NSString *redirectUrlString = @"http://www.facebook.com/connect/login_success.html";
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
	
    NSString *urlString = [NSString stringWithFormat:authFormatString, self.apiKey, redirectUrlString, self.requestedPermissions];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];	   
}

- (void)checkForAccessToken:(NSString *)urlString 
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
	
    if (regex != nil) 
	{
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
		
        if (firstMatch) 
		{
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [(NSObject<FBLoginDialogDelegate>*)_delegate accessTokenFound:accessToken];               
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    [self checkForAccessToken:urlString];    
    return TRUE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init 
{
	if (self = [super initWithFrame:CGRectZero]) 
	{
		_delegate = nil;
		_loadingURL = nil;
		_orientation = UIDeviceOrientationUnknown;
		_showingKeyboard = NO;
		
		self.backgroundColor = [UIColor clearColor];
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeRedraw;
		
		UIImage* iconImage = [UIImage imageNamed:@"FBConnect.bundle/images/fbicon.png"];
		UIImage* closeImage = [UIImage imageNamed:@"FBConnect.bundle/images/close.png"];
		
		_iconView = [[UIImageView alloc] initWithImage:iconImage];
		[self addSubview:_iconView];
		
		UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
		_closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_closeButton setImage:closeImage forState:UIControlStateNormal];
		[_closeButton setTitleColor:color forState:UIControlStateNormal];
		[_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[_closeButton addTarget:self action:@selector(cancel)
			   forControlEvents:UIControlEventTouchUpInside];
		
		_closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	
		_closeButton.showsTouchWhenHighlighted = YES;
		_closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
		| UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_closeButton];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.text = kDefaultTitle;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:14];
		_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
		| UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_titleLabel];
        
		_webView = [[UIWebView alloc] initWithFrame:CGRectZero];
		_webView.delegate = self;
		_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_webView];
		
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
					UIActivityIndicatorViewStyleWhiteLarge];
		_spinner.autoresizingMask =
		UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
		| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[self addSubview:_spinner];
	}
	
	return self;
}

- (void)dealloc 
{
	self.apiKey = nil;
	self.requestedPermissions = nil;
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialog

- (void)load {
  [self loadLoginPage];
}

- (void)dialogWillDisappear {
  [_webView stringByEvaluatingJavaScriptFromString:@"email.blur();"];
  
  if (![_session isConnected]) {
    [_session cancelLogin];
  }
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  NSDictionary* object = result;
  FBUID uid = [[object objectForKey:@"uid"] longLongValue];
  NSString* sessionKey = [object objectForKey:@"session_key"];
  NSString* sessionSecret = [object objectForKey:@"secret"];
  NSTimeInterval expires = [[object objectForKey:@"expires"] floatValue];
  NSDate* expiration = expires ? [NSDate dateWithTimeIntervalSince1970:expires] : nil;
  
  [_session begin:uid sessionKey:sessionKey sessionSecret:sessionSecret expires:expiration];
  [_session resume];
  
  [self dismissWithSuccess:YES animated:YES];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {

  [self dismissWithError:error animated:YES];
}
 
@end
