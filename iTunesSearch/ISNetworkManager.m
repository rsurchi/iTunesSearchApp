//
//  ISNetworkManager.m
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import "ISNetworkManager.h"
#import "ISiTunesTrack.h"

static NSString * const searchiTunesURL = @"http://itunes.apple.com/search?term=";

@interface ISNetworkManager ()
@end

@implementation ISNetworkManager
static ISNetworkManager* dataControl = nil;

-(id)init
{
    self = [super init];
    if(self)
    {
        _resultsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)searchForTrackWithString:(NSString*)string {
    // Separate words by whitespace and put them in an array
    NSArray *parameterArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    parameterArray = [parameterArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    NSString *joinParametersWithPlus = [parameterArray componentsJoinedByString:@"+"];
    
    NSURL *url = [NSURL URLWithString: [[NSString stringWithFormat:@"%@%@", searchiTunesURL, joinParametersWithPlus] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    // Initialise the request URL
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    // Set HTTP method
    [request setHTTPMethod:@"GET"];
    
    // Start spinner
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartSpinning" object:self];
    
    // Create a weak reference to self to prevent a retain cycle
    __weak typeof(self)weakSelf = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
        // Stop Spinner
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StopSpinning" object:weakSelf];
        
        // If there are no errors then handle the response
        if (!connectionError) {
            // Parse the JSON response
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [weakSelf parseJSONResponse:jsonResponse];
            
            // Call delegate method
            [weakSelf.delegate resultsArrayHasBeenRepopulated:weakSelf];
        }
        // If there is a connection error, then post a "NoInternetConnection" notification.
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoInternetConnection" object:weakSelf];
        }
    }] resume];
}

-(void)parseJSONResponse:(NSDictionary*)jsonResponse
{
    // Reset array
    _resultsArray = [[NSMutableArray alloc] init];
    self.resultsCount = [[jsonResponse objectForKey:@"resultCount"] stringValue];
    NSArray *responseArray = [jsonResponse objectForKey:@"results"];
    
    for (NSObject *resultTrack in responseArray) {
        ISiTunesTrack *currentTrack = [[ISiTunesTrack alloc] init];
        currentTrack.trackName = [resultTrack valueForKey:@"trackName"];
        currentTrack.artist = [resultTrack valueForKey:@"artistName"];
        currentTrack.album = [resultTrack valueForKey:@"collectionName"];
        currentTrack.thumbnailURL = [NSURL URLWithString:[resultTrack valueForKey:@"artworkUrl60"]];
        currentTrack.artworkURL = [NSURL URLWithString:[resultTrack valueForKey:@"artworkUrl100"]];
        currentTrack.price = [ISNetworkManager roundUpPrice:[NSNumber numberWithFloat:[[resultTrack valueForKey:@"trackPrice"] floatValue]]];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        currentTrack.releaseDate = [dateFormat dateFromString:[resultTrack valueForKey:@"releaseDate"]];
        currentTrack.releaseDateString = [ISNetworkManager createDateString:currentTrack.releaseDate];
        
        [_resultsArray addObject:currentTrack];
    }
}

+(NSString*)createDateString:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSString *newDate = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)day, (long)month, (long)year];
    return newDate;
}

+(NSString*)roundUpPrice:(NSNumber*)price
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    return [formatter stringFromNumber:price];
}

+ (id)dataControl
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dataControl == nil) {
            dataControl = [[ISNetworkManager alloc] init];
        }
    });
    
    return dataControl;
}

@end
