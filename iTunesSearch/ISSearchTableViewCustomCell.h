//
//  ISSearchTableViewCustomCell.h
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSearchTableViewCustomCell : UITableViewCell

extern NSString * const  SearchTableViewCellIdentifier;
typedef ISSearchTableViewCustomCell* (^SearchTableViewCellBlock)(void);

@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

/**
 * Load the image data for a ISSearchTableViewCustomCell
 *
 * @param currentCell ISSearchTableViewCustomCell block cell
 * @param thumbnailURL NSURL for the cell's thumbnail image
 * @param queue The queue that this NSOperation will be added to.
 * @return None
 **/
- (void)loadImageDataForTableCell:(SearchTableViewCellBlock)currentCell withImageURL:(NSURL*)thumbnailURL queue:(NSOperationQueue *)queue;

/**
 * Cancel a cell's image loading NSOperation
 *
 * @return None
 **/
- (void)cancelDownload;

@end
