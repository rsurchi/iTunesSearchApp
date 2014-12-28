//
//  ISDetailViewController.h
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISiTunesTrack.h"

@interface ISDetailViewController : UIViewController <UISplitViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) ISiTunesTrack *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artWorkImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomDetailView;
@property (weak, nonatomic) IBOutlet UIView *mainNameView;

@end
