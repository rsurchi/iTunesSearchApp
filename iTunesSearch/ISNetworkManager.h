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

@end
