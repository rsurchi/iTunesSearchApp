//
//  ISSearchTableViewCustomCell.m
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import "ISSearchTableViewCustomCell.h"

NSString * const  SearchTableViewCellIdentifier = @"SearchTableViewCell";

@interface ISSearchTableViewCustomCell ()
@property (nonatomic, weak) NSOperation *imageRequestOperation;
@property (nonatomic, strong) NSMutableDictionary *imageDictionary;
@end

@implementation ISSearchTableViewCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)loadImageDataForTableCell:(SearchTableViewCellBlock)currentCell
        withImageURL:(NSURL*)thumbnailURL
        queue:(NSOperationQueue *)queue
{
    UIImage* cachedImage = [self.imageDictionary objectForKey:thumbnailURL];
    // Check if image has been cached or not
    if (cachedImage == nil)
    {
        // Create a weak reference to self to prevent a retain cycle
        __weak typeof(self)weakSelf = self;
        NSOperation *thumbnailImageBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
            NSData *imageData = [NSData dataWithContentsOfURL:thumbnailURL];
            UIImage *loadedImage = nil;
            
            if (imageData)
                loadedImage = [UIImage imageWithData:imageData];
            
            // Load image on main queue
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                ISSearchTableViewCustomCell *originalCell = (id)currentCell();
                originalCell.thumbnailView.image = loadedImage;
                
                if (weakSelf.imageDictionary == nil)
                    weakSelf.imageDictionary = [[NSMutableDictionary alloc] init];
                
                [weakSelf.imageDictionary setObject:loadedImage forKey:thumbnailURL];
            }];
        }];
        
        // Add NSBlockOperation to the queue if the image has not been cached
        self.imageRequestOperation = thumbnailImageBlockOperation;
        [queue addOperation:self.imageRequestOperation];
        // Use a placeholder image until the image is loaded from the URL
        self.thumbnailView.image = [UIImage imageNamed:@"placeholder.jpg"];
    }
    else {
        // Use the cached image
        self.thumbnailView.image = cachedImage;
    }
}

- (void)cancelDownload
{
    if (self.imageRequestOperation) {
        // Cancel image requestion NSOperation
        [self.imageRequestOperation cancel];
    }
}

@end
