//
//  ISMasterViewController.m
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import "ISMasterViewController.h"
#import "ISDetailViewController.h"
#import "ISSearchTableViewCustomCell.h"
#import "ISiTunesTrack.h"

@interface ISMasterViewController ()
@property (strong, nonatomic) ISNetworkManager *dataController;
@property (strong, nonatomic) NSMutableArray *searchResultsArray;
@property (strong, nonatomic) NSOperationQueue *imageDownloadOperationQueue;
@end

@implementation ISMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (ISDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Initialise objects
    _dataController = [ISNetworkManager dataControl];
    self.imageDownloadOperationQueue = [[NSOperationQueue alloc] init];
    
    // Set delegates
    self.searchTextField.delegate = self;
    self.dataController.delegate = self;
    self.tableView.delegate = self;
    
    // Register Table View Cell Nib
    [self.tableView registerNib:[UINib nibWithNibName:@"ISSearchTableViewCustomCell" bundle:nil] forCellReuseIdentifier:@"SearchTableViewCell"];
    
    // Add observer for an internet connection error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noConnectionError:) name:@"NoInternetConnection" object:nil];
    
    // Add tap gesture to dismiss keyboard on tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    // Initialise UIActivityIndicator
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = self.spinner.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
    self.spinner.frame = frame;
    self.spinner.hidesWhenStopped = YES;
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    // Make the spinner a bit bigger
    self.spinner.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [self.view addSubview:self.spinner];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSpinnerVisibility:) name:@"StartSpinning" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSpinnerVisibility:) name:@"StopSpinning" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Cancel NSOperations
    [self.imageDownloadOperationQueue cancelAllOperations];
}

- (void)dealloc
{
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NoInternetConnection" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StartSpinning" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StopSpinning" object:nil];
}

- (void) noConnectionError:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"NoInternetConnection"])
        // Bring the error view to the front when receieving an NoInternetConnection notification
        [self.view bringSubviewToFront:self.errorView];
}

- (void) toggleSpinnerVisibility:(NSNotification *) notification
{
    // Start spinnning the UIActivityIndicatorView
    if ([[notification name] isEqualToString:@"StartSpinning"]) {
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
    }
    
    // Stop spinnning the UIActivityIndicatorView
    if ([[notification name] isEqualToString:@"StopSpinning"])
        [self.spinner stopAnimating];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *) sender
{
    [self.searchTextField resignFirstResponder];
}

#pragma mark - dataController delegate
- (void)resultsArrayHasBeenRepopulated:(ISNetworkManager *)sender
{
    // Bring tableView and spinner views back to the front
    [self.view bringSubviewToFront:self.tableView];
    [self.spinner bringSubviewToFront:self.spinner];
    
    _searchResultsArray = [sender resultsArray];
    
    // Update resultsCount label
    self.resultsCountLabel.text = [sender resultsCount];
    
    // Reload table with new results
    [self.tableView reloadData];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchTextField) {
        // Dismiss keyboard
        [textField resignFirstResponder];
        
        // Search for track with text field string
        [_dataController searchForTrackWithString:textField.text];
        return NO;
    }
    return YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create re-usable cell with identifier "SearchTableViewCell"
    ISSearchTableViewCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell" forIndexPath:indexPath];
    
    // Create ISSearchTableViewCustomCell for block
    ISSearchTableViewCustomCell * (^currentCellForBlock)(void) = ^ISSearchTableViewCustomCell*{
        return (id) [tableView cellForRowAtIndexPath:indexPath];
    };
    
    // Populate labels with ISiTunesTrack object data from the searchResults array
    ISiTunesTrack *object = _searchResultsArray[indexPath.row];
    cell.artistNameLabel.text = [object artist];
    cell.trackNameLabel.text = [object trackName];
    
    // Load the cell's image
    [cell loadImageDataForTableCell:currentCellForBlock withImageURL:[object thumbnailURL] queue:self.imageDownloadOperationQueue];

    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cancel the cell's image request NSOperation
    ISSearchTableViewCustomCell *currentCell = (ISSearchTableViewCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    [currentCell cancelDownload];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISiTunesTrack *object = _searchResultsArray[indexPath.row];
    self.detailViewController.detailItem = object;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Move to track detail view
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ISiTunesTrack *object = _searchResultsArray[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
