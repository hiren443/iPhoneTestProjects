//
//  AppDelegate.h
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface userDC : NSObject {

    int userID;
    NSString *userName, *email, *password, *userStatus, *imageURL, *firstName, *lastName, *aboutMe;
}

@property int userID;
@property(nonatomic, retain) NSString *userName, *email, *password, *userStatus, *imageURL, *firstName, *lastName, *aboutMe;


- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;
-(id)initWithEmail:(NSString *)eMail AndPassword:(NSString *)pass AndUserName:(NSString *)uName AndId:(int)uID AndUserStatus:(NSString *) uStatus AndImageURL:(NSString *)imgURL AndFirstName:(NSString *) fName AndLastName:(NSString *)lName  AndAboutMe:(NSString *)aMe;

@end
