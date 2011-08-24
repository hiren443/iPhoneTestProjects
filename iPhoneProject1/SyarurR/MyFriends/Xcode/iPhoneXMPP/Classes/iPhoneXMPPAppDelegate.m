#import "iPhoneXMPPAppDelegate.h"
#import "RootViewController.h"
#import "SettingsViewController.h"

#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorageController.h"
#import "XMPPvCardTempModule.h"
#import "XMPPStreamFacebook.h"
#import "XMPPReconnect.h"
#import "XMPPUserCoreDataStorage.h"

#import <CFNetwork/CFNetwork.h>

@implementation iPhoneXMPPAppDelegate


@synthesize facebook, accessToken;

@synthesize myTableView;

@synthesize xmppReconnect;
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardAvatarModule = _xmppvCardAvatarModule;
@synthesize xmppvCardTempModule = _xmppvCardTempModule;

@synthesize window;
@synthesize navigationController;
@synthesize loginButton = _loginButton;
@synthesize settingsViewController = _settingsViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  //[window addSubview:[navigationController view]];
  //self.window.rootViewController = self.navigationController;
	
	[self setupStream];

	
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,20,320,460)];
	
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button addTarget:self action:@selector(authFacebook) forControlEvents:UIControlEventTouchDown];
	[button setTitle:@"View Friends" forState:UIControlStateNormal];
	button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
	[view addSubview:button];
	[self.window addSubview:view];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 150, 100)];
	[label setFont:[UIFont boldSystemFontOfSize:22]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor blackColor]];
	[label setText:@"My Friends"];
	[view addSubview:label];
	
	[self.window makeKeyAndVisible];

//	
//	SettingsViewController* controller = [[SettingsViewController	alloc] initWithNibName:@"SettingsViewController" bundle:nil];
//	[self.navigationController	presentModalViewController:controller animated:YES];

	//[self	authFacebook];

	  
  return YES;
}

- (void) authFacebook 
{	
	button.hidden = YES;
	label.hidden = YES;
	if (facebook == nil)
	{
		self.facebook = [[Facebook alloc] initWithAppId:@"214664188584044"];
	}
	if (!accessToken)
	{
		[self.facebook authorize:[XMPPStreamFacebook permissions] delegate:self appAuth:NO safariAuth:NO]; 
	}
}

#pragma mark -
#pragma mark FBSessionDelegate

- (void)fbDidLogin {

	[facebook	requestWithGraphPath:@"me" andDelegate:self];
	NSLog(@"facebook access token = %@", self.facebook.accessToken);
    self.accessToken = self.facebook.accessToken;
	
	[self	setupStream];
	
	if (!myTableView) {
		
		myTableView = [[UITableView	alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
	}
	
	[myTableView	setFrame:CGRectMake(0, 70, 320, 416)];
	[myTableView	setTag:2];
	[myTableView	setDelegate:self];
	[myTableView	setDataSource:self];
	[myTableView	setHidden:NO];
	[myTableView	setBackgroundColor:[UIColor	clearColor]];
	[myTableView	setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	[myTableView	setAlpha:1.0];
	
	[self.window	addSubview:myTableView];
	
	[self.myTableView	reloadData];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 150, 100)];
	[label setFont:[UIFont boldSystemFontOfSize:22]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor blackColor]];
	[label setText:@"My Friends"];
	[self.window addSubview:label];
	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
	
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [facebook	handleOpenURL:url];
}


- (void)dealloc
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppStream disconnect];
  [_xmppvCardAvatarModule release];
  [_xmppvCardTempModule release];
	[xmppStream release];
	[xmppReconnect	release];
	[xmppRoster release];
	
	[password release];
	
  [_loginButton release];
  [_settingsViewController release];
	[navigationController release];
	[window release];

	[facebook	release];
	[accessToken	release];
	[myTableView	release];
	
	[super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Custom
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (BOOL)connect {
  if ([xmppStream isConnected]) {
    return YES;
  }
  
  //
  // Uncomment the section below to hard code a JID and password.
  //
  // Replace me with the proper JID and password
  //	[xmppStream setMyJID:[XMPPJID jidWithString:@"user@gmail.com/iPhoneTest"]];
  //	password = @"password";
  
  // If you are NOT using SRV lookup based on the JID above,
  // replace me with the proper domain and port.
  // The example below is setup for a typical google talk account.
  //	[xmppStream setHostName:@"talk.google.com"];
  //	[xmppStream setHostPort:5222];
  //
  //  return YES;
  
  // or

//  NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
//  NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
//  
//  if (myJID != nil && myPassword != nil) {
//    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
//    password = myPassword;
//    
//    // Uncomment me when the proper information has been entered above.
//    NSError *error = nil;
//    if ([xmppStream connect:&error])
//    {
//      return YES;
//    }
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting" 
//                                                        message:@"See console for error details." 
//                                                       delegate:nil 
//                                              cancelButtonTitle:@"Ok" 
//                                              otherButtonTitles:nil];
//    [alertView show];
//    [alertView release];
//    NSLog(@"Error connecting: %@", error);
//  }
  return NO;
  
}

- (void)disconnect {
  [self goOffline];
  
  [xmppStream disconnect];
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
// 
// In addition to this, the NSXMLElementAdditions class provides some very handy methods for working with XMPP.
// 
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
// 
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

- (void)setupStream {
	
	if (xmppStream)
	{
		[xmppStream	release];
		xmppStream = nil;
	}
	
	xmppStream = [[XMPPStreamFacebook alloc] init];
	[xmppReconnect =[XMPPReconnect	alloc] initWithStream:xmppStream];
	
	if (xmppRosterStorage) {
		
		[xmppRosterStorage release];
		xmppRosterStorage = nil;
	}
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	if (xmppRoster) {
		
		[xmppRoster	release];
		xmppRoster = nil;
	}
	xmppRoster = [[XMPPRoster alloc] initWithStream:xmppStream rosterStorage:xmppRosterStorage];
	
	[xmppStream addDelegate:self];
	[xmppRoster addDelegate:self];
	
	[xmppRoster setAutoRoster:YES];
  
  _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithStream:xmppStream 
                                                             storage:[XMPPvCardCoreDataStorageController sharedXMPPvCardCoreDataStorageController]];
  _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
  
  // You may need to alter these settings depending on the server you're connecting to
	xmppStream.myJID = [XMPPJID	jidWithUser:@"does not matter" domain:@"chat.facebook.com" resource:nil];
	//xmppStream.myJID = [XMPPJID	jidWithString:[NSString	stringWithFormat:@"%@chat.facebook.com", uid]];
	
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = YES;
	
	NSError*	error = nil;
	if (![xmppStream connect:&error]) {
		NSLog(@"Error connecting: %@", error);
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
//{
//	NSLog(@"---------- xmppStream:willSecureWithSettings: ----------");
//	
//	if (allowSelfSignedCertificates)
//	{
//		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
//	}
//	
//	if (allowSSLHostNameMismatch)
//	{
//		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
//	}
//	else
//	{
//		// Google does things incorrectly (does not conform to RFC).
//		// Because so many people ask questions about this (assume xmpp framework is broken),
//		// I've explicitly added code that shows how other xmpp clients "do the right thing"
//		// when connecting to a google server (gmail, or google apps for domains).
//		
//		NSString *expectedCertName = nil;
//		
//		NSString *serverDomain = xmppStream.hostName;
//		NSString *virtualDomain = [xmppStream.myJID domain];
//		
//		if ([serverDomain isEqualToString:@"talk.google.com"])
//		{
//			if ([virtualDomain isEqualToString:@"gmail.com"])
//			{
//				expectedCertName = virtualDomain;
//			}
//			else
//			{
//				expectedCertName = serverDomain;
//			}
//		}
//    else if (serverDomain == nil) {
//      expectedCertName = virtualDomain;
//    }
//		else
//		{
//			expectedCertName = serverDomain;
//		}
//		
//		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
//	}
//}
//
- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidSecure: ----------");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidConnect: ----------");
	
	isOpen = YES;
	
	NSError *error = nil;
	
	if (![self.xmppStream	authenticateWithAppId:@"262380763556" accessToken:self.accessToken error:&error])
	{
		NSLog(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidAuthenticate: ----------");
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	NSLog(@"---------- xmppStream:didNotAuthenticate: ----------");
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	NSLog(@"---------- xmppStream:didReceiveIQ: ----------");
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	NSLog(@"---------- xmppStream:didReceiveMessage: ----------");
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	NSLog(@"---------- xmppStream:didReceivePresence: ----------");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	NSLog(@"---------- xmppStream:didReceiveError: ----------");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidDisconnect: ----------");
	
	if (!isOpen)
	{
		NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
}


- (void)fbDidNotLogin:(BOOL)cancelled
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Canceled" message:@"Login cancled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
	[alert release];
}
- (void)fbDidLogout
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged out" message:@"Logged out" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
	[alert release];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{ 
	NSLog(@"Error: %@", error);
} 

- (void)request:(FBRequest*)request didLoad:(id)result { 
	
	NSLog(@" Result>>>>-------%@", result);
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSMutableDictionary *)result];
	
	uid = [dict objectForKey:@"id"];
	NSLog(@"iddddddddddddd---%@", uid);
	
} 


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorage"
		                                          inManagedObjectContext:[xmppRosterStorage managedObjectContext]];
		
		//NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:[xmppRosterStorage managedObjectContext]
		                                                                 sectionNameKeyPath:nil
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		//[sd1 release];
		[sd2 release];
		[fetchRequest release];
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			NSLog(@"Error performing fetch: %@", error);
		}
	}
	
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[[self myTableView] reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//	return [[[self fetchedResultsController] sections] count];
//}
//
//- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
//{
//	NSArray *sections = [[self fetchedResultsController] sections];
//	
//	if (sectionIndex < [sections count])
//	{
//		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
//        
//		int section = [sectionInfo.name intValue];
//		switch (section)
//		{
//			case 0  : return @"Available";
//			case 1  : return @"Away";
//			default : return @"Offline";
//		}
//	}
//	
//	return @"";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
		return sectionInfo.numberOfObjects;
	}
	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
		                               reuseIdentifier:CellIdentifier] autorelease];
	}
	
	XMPPUserCoreDataStorage *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	cell.textLabel.text = user.displayName;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 

	
//	NSData *photoData = [[self xmppvCardAvatarModule] photoDataForJID:user.jid];
//	
//	if (photoData != nil) {
//		cell.imageView.image = [UIImage imageWithData:photoData];
//	} else {
//		cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
//	}
	
	return cell;
}

#pragma mark - XMPPvCardTempModuleDelegate methods


- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule 
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp 
                     forJID:(XMPPJID *)jid
                 xmppStream:(XMPPStream *)xmppStream {
	/*
	 *  Reloading just the changed row, if it is visible would be a better solution.
	 */
	[self.myTableView reloadData];
}



@end
