//
//  AppDelegate.m
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBHandler : NSObject {

}


+(void) copyDatabaseIfNeeded;
+(NSString *) getDBPath;
+(NSString *) getDBPathForSql;
+(void) generateDB;
+(sqlite3_stmt *) getStatement:(NSString *) SQLStrValue;
+(BOOL)InsUpdateDelData:(NSString*)SqlStr;
+(void)connectWithDB;


#pragma mark -
#pragma mark MAIN MENU SCREEN

+(NSMutableArray *)loadData;

#pragma mark -


@end
