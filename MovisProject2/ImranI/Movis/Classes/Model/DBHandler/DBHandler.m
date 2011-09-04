//
//  AppDelegate.m
//  Movis
//
//  Created by Imran Ishaq on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBHandler.h"
#import "commonObjectsDC.h"
#import "AppDelegate.h"
#import "myJson.h"
#import "JSON.h"

@implementation DBHandler

#define databaseName @"Movis.sqlite"
static sqlite3 *database = nil;



#pragma mark -
#pragma mark MAIN MENU SCREEN 

+(NSMutableArray *)loadData
{
    [NSThread detachNewThreadSelector:@selector(showBusyView) toTarget:APPDELEGATE withObject:nil];
    
    NSMutableArray *dataArray =[[NSMutableArray alloc] init];

    NSString * sqlStr = [NSString stringWithFormat:@"select * from table_Name"];
    sqlite3_stmt *ReturnStatement = (sqlite3_stmt *) [self getStatement: sqlStr];
    while(sqlite3_step(ReturnStatement) == SQLITE_ROW)
    { 
        @try
        {
            commonObjectsDC *mmObj = [[commonObjectsDC alloc] init];
                                
            //NSString *Title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 0)];
            //NSString *iconName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 1)];
            //mmObj.MenuTitle = Title;
            //mmObj.MenuIconName = iconName;
            
            [dataArray addObject:mmObj];
        }
        @catch (NSException *ept) {
            NSLog(@"Exception in Method: '%@', Reason: %@", @"loadData", [ept reason]);
        }
    }
    [APPDELEGATE hideBusyView];
    return dataArray;
}



#pragma mark - DB_STUFF


+(void)connectWithDB
{
    [DBHandler copyDatabaseIfNeeded];
    [DBHandler generateDB];
}

+(void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];		
		//		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AnwaltTestDB.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

+(NSString *) getDBPath {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:databaseName];
}

+(NSString *) getDBPathForSql {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:databaseName];
}

+(void) generateDB {
	NSString *dbFilePath = [self getDBPath];
	if(sqlite3_open([dbFilePath UTF8String], &database) == SQLITE_OK)
	{
		NSLog(@"CONNECTION SUCCESSFUL WITH DB");
	}
	else
	{
		NSLog(@"CONNECTION FAILURE WITH DB");
	}
	
}

+(sqlite3_stmt *) getStatement:(NSString *) SQLStrValue {
	
	NSLog(@"QUERY: %@", SQLStrValue);
	if([SQLStrValue isEqualToString:@""])
		return NO;
	
	sqlite3_stmt * OperationStatement;
	sqlite3_stmt * ReturnStatement;
	
	
	const char * sql = [SQLStrValue cStringUsingEncoding: NSUTF8StringEncoding];
	if (sqlite3_prepare_v2(database, sql, -1, &OperationStatement, NULL) == SQLITE_OK)
	{	
		ReturnStatement = OperationStatement;
	}
	return ReturnStatement;
}

+(BOOL)InsUpdateDelData:(NSString*)SqlStr {
	if([SqlStr isEqual:@""])
		return NO;
	
	BOOL RetrunValue;
	RetrunValue = NO;
	const char *sql = [SqlStr cStringUsingEncoding:NSUTF8StringEncoding]; 
	
    sqlite3_stmt *stmt; 
	if (sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) 
	{	
		printf("\n\nSuccess Query: %s\n\n", sql);
		RetrunValue = YES;
	}
	else 
	{
		printf("\n\nFailure Query: %s\n\n", sql);
	}
	
	if(RetrunValue == YES)
	{	
		
		if(sqlite3_step(stmt) != SQLITE_DONE) 
			NSLog(@"This should be real error checking!");
		sqlite3_finalize(stmt);
	}
	
	return RetrunValue;
}




@end
