//
//  PIRSendPaymentsViewController.m

//
//  Created by Kenny Tang on 12/13/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRSendPaymentsViewController.h"
#import "MRProgressOverlayView.h"
#import "PIRPeerConnectivity.h"
#import "PIRSeparator.h"
#import "PIRSendPaymentNearbyUsersCell.h"
#import "PIRSendPaymentsAmountsViewController.h"
#import "PIRSendPaymentsEmailViewController.h"
#import "PIRBeaconServices.h"
#import "PIRUserServices.h"

static NSString * const sPIRSendPaymentNearbyUsersCellIdentifier = @"PIRSendPaymentNearbyUsersCell";
static CGFloat const sPIRSendPaymentNearbyUsersCellHeight = 120.0;

@interface PIRSendPaymentsViewController ()<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITableView * nearByUsersTableView;
@property (nonatomic, strong) NSMutableDictionary * nearByUsersDict;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (nonatomic, strong) UIBarButtonItem * stopScanBarButtonItem;

@property (nonatomic, strong) UILabel * noNearbyUsersLabel;

@property (nonatomic, strong) PIRSeparator * separator;

@property (nonatomic, strong) UIActivityIndicatorView * acivityIndicatorView;
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIButton * paymentByMailButton;

@property (nonatomic, strong) PIRAlertViewViewController * alertVC;

@end

@implementation PIRSendPaymentsViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     
     this is just for testing the PIRAlertViewViewController
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        __weak UIViewController * topMostVC = self;
        AlertViewCallback callBack = ^(NSUInteger buttonSelectedIndex, BOOL isCanceledButtonTapped) {
            [topMostVC dismissViewControllerAnimated:NO completion:^{
                //
            }];
        };
        NSString * message = @"Kenny's iPhone wants to send you 111.111. Accept request?";
        PIRAlertViewViewController * alertVC = [[PIRAlertViewViewController alloc] initWithTitle:@"Payment Request" desc:message buttonsLabels:nil completion:callBack];
        [topMostVC presentViewController:alertVC animated:NO completion:nil];
    });
    
     */
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scanForNearbyPeers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [PIRColor defaultBackgroundColor];
    }
    return _contentView;
}

- (UILabel*)noNearbyUsersLabel
{
    if (!_noNearbyUsersLabel) {
        _noNearbyUsersLabel = [UILabel new];
        _noNearbyUsersLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noNearbyUsersLabel.font = [PIRFont statusLabelFont];
        _noNearbyUsersLabel.text = NSLocalizedString(@"Nearby Pier users or merchants appear here.", nil);
        _noNearbyUsersLabel.textColor = [PIRColor secondaryTextColor];
        _noNearbyUsersLabel.numberOfLines = 0;
    }
    return _noNearbyUsersLabel;
}

- (UIActivityIndicatorView*)acivityIndicatorView
{
    if (!_acivityIndicatorView) {
        _acivityIndicatorView = [UIActivityIndicatorView new];
        _acivityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _acivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_acivityIndicatorView startAnimating];
    }
    return _acivityIndicatorView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [PIRFont sectionTitleFont];
        _titleLabel.textColor = [PIRColor primaryTextColor];
        _titleLabel.text = NSLocalizedString(@"Send Payment to nearby users:", nil);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIBarButtonItem*) stopScanBarButtonItem
{
    if (!_stopScanBarButtonItem) {
        _stopScanBarButtonItem = [UIBarButtonItem new];
        _stopScanBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopScanningButtonTapped:)];
        _stopScanBarButtonItem.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
        
    }
    return _stopScanBarButtonItem;
}

- (UITableView*) nearByUsersTableView
{
    if (!_nearByUsersTableView) {
        _nearByUsersTableView = [UITableView new];
        _nearByUsersTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _nearByUsersTableView.delegate = self;
        _nearByUsersTableView.dataSource = self;
        _nearByUsersTableView.hidden = YES;
        _nearByUsersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // this line hides empty cells below the cells
        _nearByUsersTableView.tableFooterView = [UIView new];
        
        [_nearByUsersTableView registerClass:[PIRSendPaymentNearbyUsersCell class] forCellReuseIdentifier:sPIRSendPaymentNearbyUsersCellIdentifier];
    }
    return _nearByUsersTableView;
}

- (NSMutableDictionary*) nearByUsersDict
{
    if (!_nearByUsersDict) {
        _nearByUsersDict = [NSMutableDictionary new];
    }
    return _nearByUsersDict;
}

- (UIRefreshControl*) refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
        _refreshControl.translatesAutoresizingMaskIntoConstraints = NO;
        [_refreshControl addTarget:self action:@selector(pullToRefreshInitiated:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (PIRSeparator*)separator
{
    if (!_separator) {
        _separator = [PIRSeparator new];
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
        _separator.hidden = YES;
    }
    return _separator;
}


- (UIButton *)paymentByMailButton
{
    if(!_paymentByMailButton)
    {
        _paymentByMailButton = [UIButton new];
        _paymentByMailButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_paymentByMailButton setTitle:@"Send by Email or Phone" forState:UIControlStateNormal];
        _paymentByMailButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_paymentByMailButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_paymentByMailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _paymentByMailButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _paymentByMailButton.layer.borderWidth = 0.5;
        [_paymentByMailButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_paymentByMailButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_paymentByMailButton addTarget:self action:@selector(paymentByMailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        // disable for now
        [_paymentByMailButton setTitleColor:[PIRColor secondaryTextColor] forState:UIControlStateNormal];
    }
    return _paymentByMailButton;
}

#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}


- (void)setupNavigationBar
{
    self.navigationItem.title = NSLocalizedString(@"Send Payment", nil);
}

- (void)addSubviewTree
{
    [self.nearByUsersTableView addSubview:self.refreshControl];
    [self.contentView addSubview:self.noNearbyUsersLabel];
    [self.contentView addSubview:self.separator];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nearByUsersTableView];
    [self.contentView addSubview:self.paymentByMailButton];
    
    [self.view addSubview:self.contentView];
    
}


- (void)constrainViews
{
    NSDictionary * views = @{
                             @"separator":self.separator,
                             @"contentView":self.contentView,
                             @"nearByUsersTableView":self.nearByUsersTableView,
                             @"titleLabel":self.titleLabel,
                             @"noNearbyUsersLabel":self.noNearbyUsersLabel,
                             @"paymentByMailButton":self.paymentByMailButton,
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[contentView(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[contentView(568)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[nearByUsersTableView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[titleLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[noNearbyUsersLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[separator]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[paymentByMailButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|-120-[titleLabel]-20-[nearByUsersTableView(240)]-[separator(1)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:[titleLabel]-20-[noNearbyUsersLabel]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:[separator]-30-[paymentByMailButton(40)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    
}

#pragma mark - Event handlers

- (void)pullToRefreshInitiated:(id)sender
{
    [self scanForNearbyPeers];
    self.navigationItem.rightBarButtonItem = self.stopScanBarButtonItem;
}

- (void)stopScanningButtonTapped:(id)sender
{
    [self.refreshControl endRefreshing];
    [self stopScanningForNearbyPeers];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)paymentByMailButtonTapped:(id)sender
{
    DLog(@"paymentByMailButtonTapped");
    
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    if (currentUser.primaryBankAccount){
        PIRSendPaymentsEmailViewController *emailVC = [PIRSendPaymentsEmailViewController new];
        emailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:emailVC animated:YES];
    }else{
        MRProgressOverlayView * progressView = [MRProgressOverlayView new];
        progressView.titleLabelText = NSLocalizedString(@"Please add a primary bank account before sending payment.", nil);
        progressView.mode = MRProgressOverlayViewModeCross;
        [self.view.superview addSubview:progressView];
        [progressView show:YES];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [progressView dismiss:YES];
        });
    }
    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    if (currentUser.primaryBankAccount){
        PIRSendPaymentsAmountsViewController * sendVC = [PIRSendPaymentsAmountsViewController new];
        NSArray * keys = [self.nearByUsersDict allKeys];
        if ([keys count] > indexPath.row) {
            sendVC.toUser = self.nearByUsersDict[keys[indexPath.row]];
            [self.navigationController pushViewController:sendVC animated:YES];
        }
    }else{
        MRProgressOverlayView * progressView = [MRProgressOverlayView new];
        progressView.titleLabelText = NSLocalizedString(@"Please add a primary bank account before sending payment.", nil);
        progressView.mode = MRProgressOverlayViewModeCross;
        [self.view.superview addSubview:progressView];
        [progressView show:YES];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [progressView dismiss:YES];
        });
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return sPIRSendPaymentNearbyUsersCellHeight;
}

#pragma mark - UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIRSendPaymentNearbyUsersCell * cell = [tableView dequeueReusableCellWithIdentifier:sPIRSendPaymentNearbyUsersCellIdentifier forIndexPath:indexPath];
    NSArray * keys = [self.nearByUsersDict allKeys];
    PIRUser * user = self.nearByUsersDict[keys[indexPath.row]];
    cell.user = user;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.nearByUsersDict allKeys] count];
}

#pragma mark - Connectivity helps

- (void)stopScanningForNearbyPeers
{
    [[PIRBeaconServices sharedInstance] stopRangingBeacon];
}

- (void)scanForNearbyPeers
{
    [self.nearByUsersDict removeAllObjects];
    
    NSArray * nearByUsersDictKeys = [self.nearByUsersDict allKeys];
    PIRBeaconServices *beaconService = [PIRBeaconServices sharedInstance];
    [beaconService startRangingBeacon:^(NSArray *updatedBeacons, NSError *error) {
        
        if ([updatedBeacons count] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // reload table
                [self.nearByUsersDict removeAllObjects];
                self.nearByUsersTableView.hidden = NO;
                self.noNearbyUsersLabel.hidden = YES;
                [self.nearByUsersTableView reloadData];
                [self.refreshControl endRefreshing];
            });
        }
        
        [updatedBeacons enumerateObjectsUsingBlock:^(NSNumber *beaconMinorID, NSUInteger idx, BOOL *stop) {
            //
            if (![nearByUsersDictKeys containsObject:beaconMinorID]){
                NSString * pierID = [NSString stringWithFormat:@"%li", (long)[beaconMinorID integerValue]];
                [[PIRUserServices sharedService] retriveUserInfo:pierID success:^(PIRUser *user) {
                    self.nearByUsersDict[beaconMinorID] = user;
                    
                    if (idx == [updatedBeacons count]-1) {
                        // clean up old users
                        [nearByUsersDictKeys enumerateObjectsUsingBlock:^(NSNumber * beaconMinorID, NSUInteger idx, BOOL *stop) {
                            if (![updatedBeacons containsObject:beaconMinorID]) {
                                [self.nearByUsersDict removeObjectForKey:beaconMinorID];
                            }
                        }];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // reload table
                            self.nearByUsersTableView.hidden = NO;
                            self.noNearbyUsersLabel.hidden = YES;
                            [self.nearByUsersTableView reloadData];
                            [self.refreshControl endRefreshing];
                        });
                    }
                    
                } error:^(NSError *error) {
                    ELog(@"error in retrieving profile of nearby user: %@", error);
                }];
            }
        }];
        
        
    }];
    

}


@end
