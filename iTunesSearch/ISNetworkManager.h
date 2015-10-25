//
//  ISNetworkManager.h
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISNetworkManager;
@protocol NetworkManagerDelegate <NSObject>
- (void) resultsArrayHasBeenRepopulated: (ISNetworkManager *) sender;
@end

@interface ISNetworkManager : NSObject

@property (strong, nonatomic) NSMutableArray *resultsArray;
@property (strong, nonatomic) NSString *resultsCount;
@property (nonatomic, weak) id <NetworkManagerDelegate> delegate;

+(id)dataControl;

/**
 * Send an asynchronous request to the searchiTunesURL using a search string
 *
 * @param string Search string
 * @return None
 **/
-(void)searchForTrackWithString:(NSString*)string;

/**
 * Parse JSON response
 *
 * @param NSDictionary JSON dictionary
 * @return None
 **/
-(void)parseJSONResponse:(NSDictionary*)jsonResponse;

/**
 * Create a date string from an NSDate in the format DD/MM/YYYY
 *
 * @param NSDate date
 * @return NSString date
 **/
+(NSString*)createDateString:(NSDate*)date;

/**
 * Round up price to two decimal places and convert to NSString
 *
 * @param NSNumber price
 * @return NSString string
 **/
+(NSString*)roundUpPrice:(NSNumber*)price;
@end
