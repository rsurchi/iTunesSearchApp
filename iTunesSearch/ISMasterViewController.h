//
//  ISMasterViewController.h
//  iTunesSearch
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISNetworkManager.h"

@class ISDetailViewController;

@interface ISMasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NetworkManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultsCountLabel;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *noConnectionErrorMessageLabel;
@property (strong, nonatomic) ISDetailViewController *detailViewController;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end
