//
//  PIRProfileBankAccountsViewController.m

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileBankAccountsViewController.h"
#import "MRProgress.h"
#import "PIRBankAccount.h"
#import "PIRProfileAddBankAccountViewController.h"
#import "PIRProfileInfoTableViewCell.h"
#import "PIRProfileUpdateBankAccountViewController.h"
#import "PIRUserServices.h"

static CGFloat const kPIRProfileBankAccountsTableViewCellHeight = 44.0;
static NSString * const kPIRProfileBankAccountsTableViewCellIdentifier = @"kPIRProfileBankAccountsTableViewCellIdentifier";


@interface PIRProfileBankAccountsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * bankAccountsTableView;
@property (nonatomic, strong) PIRUser * currentUser;
@property (nonatomic, strong) NSArray * bankAccountsArray;
@property (nonatomic, strong) UIButton * addBankAccountButton;
@property (nonatomic, strong) UILabel * noBankAccountsLabel;

@end

@implementation PIRProfileBankAccountsViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self addSubviewTree];
    [self constrainViews];
    [self prepareAccountsTable];
    self.currentUser = [[PIRUserServices sharedService] currentUser];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self prepareAccountsTable];
    [super viewDidAppear:animated];
}


#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Public mehtods

- (void)stopEditing
{
    [self.bankAccountsTableView setEditing:NO animated:YES];
}

#pragma mark - Private

#pragma mark - Private properties

- (UILabel*)noBankAccountsLabel
{
    if (!_noBankAccountsLabel) {
        _noBankAccountsLabel = [UILabel new];
        _noBankAccountsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noBankAccountsLabel.text = NSLocalizedString(@"Add bank accounts to send and receive payments.", nil);
        _noBankAccountsLabel.font = [PIRFont statusLabelFont];
        _noBankAccountsLabel.numberOfLines = 0;
    }
    return _noBankAccountsLabel;
}

- (UIButton*)addBankAccountButton
{
    if (!_addBankAccountButton) {
        _addBankAccountButton = [UIButton new];
        _addBankAccountButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_addBankAccountButton setTitle:@"Add Bank Account" forState:UIControlStateNormal];
        _addBankAccountButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_addBankAccountButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_addBankAccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _addBankAccountButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _addBankAccountButton.layer.borderWidth = 0.5;
        [_addBankAccountButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_addBankAccountButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_addBankAccountButton addTarget:self action:@selector(addBankAccountButtonTapped:) forControlEvents:UIControlEventTouchDown];
        
    }
    return _addBankAccountButton;
}

-(UITableView*)bankAccountsTableView
{
    if (!_bankAccountsTableView) {
        _bankAccountsTableView = [UITableView new];
        _bankAccountsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _bankAccountsTableView.backgroundColor = [UIColor clearColor];
        _bankAccountsTableView.dataSource = self;
        _bankAccountsTableView.delegate = self;
        
        // this line hides empty cells below the cells
        _bankAccountsTableView.tableFooterView = [UIView new];
        [_bankAccountsTableView registerClass:[PIRProfileInfoTableViewCell class] forCellReuseIdentifier:kPIRProfileBankAccountsTableViewCellIdentifier];
    }
    return _bankAccountsTableView;
}


#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}

- (void)addSubviewTree
{
    [self.view addSubview:self.noBankAccountsLabel];
    [self.view addSubview:self.bankAccountsTableView];
    [self.view addSubview:self.addBankAccountButton];
}

- (void)constrainViews
{
    NSMutableDictionary * views = [@{
                             @"bankAccountsTableView":self.bankAccountsTableView,
                             @"addBankAccountButton":self.addBankAccountButton
                             } mutableCopy];
    
    if (self.noBankAccountsLabel) {
        views[@"noBankAccountsLabel"] = self.noBankAccountsLabel;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noBankAccountsLabel
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                   @"H:[noBankAccountsLabel(240)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                   @"V:|-[noBankAccountsLabel(100)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[bankAccountsTableView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[addBankAccountButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[bankAccountsTableView(210)]-[addBankAccountButton(40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)prepareAccountsTable
{
    self.bankAccountsArray = [[[[PIRUserServices sharedService] currentUser] accounts] allObjects];
    if ([self.bankAccountsArray count]) {
        self.noBankAccountsLabel.hidden = YES;
    }else{
        self.noBankAccountsLabel.hidden = NO;
    }
    [self.bankAccountsTableView reloadData];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bankAccountsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIRProfileInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kPIRProfileBankAccountsTableViewCellIdentifier forIndexPath:indexPath];
    
    PIRBankAccount * bankAccount = self.bankAccountsArray[indexPath.row];
    cell.titleLabel.text = bankAccount.bankName ;
    cell.valueLabel.text = [NSString stringWithFormat:@"%@", bankAccount.accountNumber];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PIRBankAccount * bankAccount = self.bankAccountsArray[indexPath.row];
    PIRProfileUpdateBankAccountViewController *vc = [PIRProfileUpdateBankAccountViewController new];
    vc.bankAccount = bankAccount;
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:^{
        // nothing
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPIRProfileBankAccountsTableViewCellHeight;
}


#pragma mark - Event handlers



- (void)addBankAccountButtonTapped:(id)sender
{
    DLog(@"addBankAccountButtonTapped");
    
    PIRProfileAddBankAccountViewController * bankVC = [PIRProfileAddBankAccountViewController new];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:bankVC];
    [self presentViewController:navController animated:YES completion:^{
        // nothing
    }];
    
}

@end
