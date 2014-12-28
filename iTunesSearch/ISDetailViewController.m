//
//  ISDetailViewController.m
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import "ISDetailViewController.h"

@interface ISDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property UIDeviceOrientation currentOrientation;
- (void)configureView;
@end

@implementation ISDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        // Populate navigation title, labels and image views with ISiTunesTrack data
        self.navigationItem.title = [self.detailItem trackName];
        self.trackNameLabel.text = [self.detailItem trackName];
        self.albumNameLabel.text = [self.detailItem album];
        self.artistNameLabel.text = [self.detailItem artist];
        
        // Display the string "Free" if the price is equal to 0
        if(![[self.detailItem price] isEqualToString:@"0"])
            self.priceLabel.text = [NSString stringWithFormat: @"£%@", [self.detailItem price]];
        else
            self.priceLabel.text = @"Free";
        self.releaseDateLabel.text = [self.detailItem releaseDateString];
        
        // Create circle image view and add image
        self.artWorkImageView.layer.cornerRadius = self.artWorkImageView.frame.size.width / 2;
        self.artWorkImageView.clipsToBounds = YES;
        NSData *imageData = [NSData dataWithContentsOfURL:[self.detailItem artworkURL]];
        self.artWorkImageView.image = [UIImage imageWithData:imageData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // Set delegates
    self.detailScrollView.delegate = self;
    
    // Set orientation
    self.currentOrientation = [[UIDevice currentDevice] orientation];
    
    // Center image view on UIView
    [self adjustLayoutAndCenterSubviews];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Center image view on UIView
    [self adjustLayoutAndCenterSubviews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Fixed UIScrollView bug by setting the delegate to nil. scrollViewDidScroll was getting called when navigating out of the view.
    self.detailScrollView.delegate = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Set detailScrollView content size to the combined height of all UIViews
    CGRect contentSizeFrame = self.view.frame;
    contentSizeFrame.size.height = self.topImageView.frame.size.height + self.mainNameView.frame.size.height + self.bottomDetailView.frame.size.height;
    self.detailScrollView.contentSize = contentSizeFrame.size;
}

#pragma mark - ScrollView delegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.detailScrollView)
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        // Don't do anything if the user scrolls up
        if (offsetY > 0)
        {
            // The Main view frame should never be less than 0 (the top of the scrollview)
            CGRect newMainframe = self.mainNameView.frame;
            CGFloat newMainViewY = ((newMainframe.origin.y - offsetY) > 0) ? (newMainframe.origin.y - offsetY) : 0;
            newMainframe.origin.y = newMainViewY;
            
            // The Image view frame should never be more than the height of the Main view otherwise it will overlap the view below it.
            CGRect newTopViewframe = self.topImageView.frame;
            CGFloat newTopViewY = ((newTopViewframe.origin.y + offsetY) < self.mainNameView.frame.size.height + 1) ? (newTopViewframe.origin.y + offsetY) : (self.mainNameView.frame.size.height + 1);
            newTopViewframe.origin.y = newTopViewY;
            
            // Move the main frame above the top view in an animation
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainNameView.frame = newMainframe;
                self.topImageView.frame = newTopViewframe;
            } completion:nil];
        }
    }
}

#pragma mark - Other functions

-(void)adjustLayoutAndCenterSubviews
{
    // Center the artwork image view in the topImageView
    self.artWorkImageView.center = [self.topImageView convertPoint:self.topImageView.center fromView:self.topImageView.superview];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    UIDeviceOrientation toOrientation   = [[UIDevice currentDevice] orientation];
    if (self.currentOrientation != toOrientation)
    {
        self.currentOrientation = toOrientation;
        // Center image view when the orientation changes
        [self adjustLayoutAndCenterSubviews];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
