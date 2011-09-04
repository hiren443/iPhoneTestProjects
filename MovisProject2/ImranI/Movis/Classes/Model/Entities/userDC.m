//
//  AppDelegate.h
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "userDC.h"

@implementation userDC

@synthesize userID, userName, email, password, userStatus, imageURL, firstName, lastName, aboutMe;


-(id)initWithEmail:(NSString *)eMail AndPassword:(NSString *)pass AndUserName:(NSString *)uName AndId:(int)uID AndUserStatus:(NSString *) uStatus AndImageURL:(NSString *)imgURL AndFirstName:(NSString *) fName AndLastName:(NSString *)lName  AndAboutMe:(NSString *)aMe
{
    self = [[userDC alloc] init];
    if (self != nil)
    {
        self.userID = uID;
        self.userName = uName;
        self.email = eMail;
        self.password = pass;
        self.imageURL = imgURL;
        self.userStatus = uStatus;
        self.firstName = fName;
        self.lastName = lName;
        self.aboutMe = aMe;
    }   
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeInt:userID forKey:@"userID"];
    [coder encodeObject:userName forKey:@"userName"];
    [coder encodeObject:password forKey:@"password"];
    [coder encodeObject:email forKey:@"email"];
    [coder encodeObject:userStatus forKey:@"userStatus"];
    [coder encodeObject:imageURL forKey:@"imageURL"];
    [coder encodeObject:firstName forKey:@"firstName"];
    [coder encodeObject:lastName forKey:@"lastName"];
    [coder encodeObject:aboutMe forKey:@"aboutMe"];
    
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[userDC alloc] init];
    if (self != nil)
    {
        self.userID = [coder decodeIntForKey:@"userID"];
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.password = [coder decodeObjectForKey:@"password"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.userStatus = [coder decodeObjectForKey:@"userStatus"];
        self.imageURL = [coder decodeObjectForKey:@"imageURL"];
        self.firstName = [coder decodeObjectForKey:@"firstName"];
        self.lastName = [coder decodeObjectForKey:@"lastName"];
        self.aboutMe = [coder decodeObjectForKey:@"aboutMe"];
    }   
    return self;
}



@end
