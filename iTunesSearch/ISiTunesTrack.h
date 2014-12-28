//
//  ISiTunesTrack.h
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISiTunesTrack : NSObject

@property (nonatomic,readwrite) NSString *trackName;
@property (nonatomic,readwrite) NSString *artist;
@property (nonatomic,readwrite) NSString *album;
@property (nonatomic,readwrite) NSURL *thumbnailURL;
@property (nonatomic,readwrite) NSURL *artworkURL;
@property (nonatomic,readwrite) NSString *price;
@property (nonatomic,readwrite) NSDate *releaseDate;
@property (nonatomic,readwrite) NSString *releaseDateString;

@end
