//
//  PIRProfileTransactionsViewController.m

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileTransactionsViewController.h"
#import "PIRTransaction+Extensions.h"
#import "PIRProfileTransactionCell.h"
#import "PIRTransactionServices.h"
#import "PIRUserServices.h"

static CGFloat const kPIRProfileTransactionsTableViewCellHeight = 120.0;
static NSString * const kPIRProfileTransactionsTableViewCellIdentifier = @"kPIRProfileTransactionsTableViewCellIdentifier";

@interface PIRProfileTransactionsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * transactionsTableView;
@property (nonatomic, strong) PIRUser * currentUser;
@property (nonatomic, strong) NSArray * transactionsArray;
@property (nonatomic, strong) UILabel * noTransactionsLabel;

@end

@implementation PIRProfileTransactionsViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self addSubviewTree];
    [self constrainViews];
    self.currentUser = [[PIRUserServices sharedService] currentUser];
    [self subscribeToTransactionsUpdateNotification];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPIRConstantsTransactionsUpdatedNotification object:nil];

}

#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties


- (UILabel*)noTransactionsLabel
{
    if (!_noTransactionsLabel) {
        _noTransactionsLabel = [UILabel new];
        _noTransactionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noTransactionsLabel.text = NSLocalizedString(@"You have not sent or received any payments in ", nil);
        _noTransactionsLabel.font = [PIRFont statusLabelFont];
        _noTransactionsLabel.numberOfLines = 0;
    }
    return _noTransactionsLabel;
}


-(UITableView*)transactionsTableView
{
    if (!_transactionsTableView) {
        _transactionsTableView = [UITableView new];
        _transactionsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _transactionsTableView.backgroundColor = [UIColor clearColor];
        _transactionsTableView.dataSource = self;
        _transactionsTableView.delegate = self;
        
        // this line hides empty cells below the cells
        _transactionsTableView.tableFooterView = [UIView new];
        [_transactionsTableView registerClass:[PIRProfileTransactionCell class] forCellReuseIdentifier:kPIRProfileTransactionsTableViewCellIdentifier];
        
        NSSortDescriptor *timestampDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
        
        PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
        NSArray *sentTransactions = [[PIRTransactionServices sharedService] retrieveTransactionsSentBy:currentUser];
        sentTransactions = [sentTransactions sortedArrayUsingDescriptors:@[timestampDescriptor]];
        
        
        sentTransactions = [sentTransactions sortedArrayUsingDescriptors:@[timestampDescriptor]];
        
        NSArray *receivedTransactions = [[PIRTransactionServices sharedService] retrieveTransactionsReceivedBy:currentUser];
        receivedTransactions = [receivedTransactions sortedArrayUsingDescriptors:@[timestampDescriptor]];
        
        NSMutableArray * allTransactions = [@[] mutableCopy];
        if ([sentTransactions count]) {
            [allTransactions addObjectsFromArray:sentTransactions];
        }
        if ([receivedTransactions count]) {
            [allTransactions addObjectsFromArray:receivedTransactions];
        }
        
        self.transactionsArray = allTransactions;
    }
    return _transactionsTableView;
}

#pragma mark - Initialization helpers

- (void)subscribeToTransactionsUpdateNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processTransactionsUpdatedNotification:) name:kPIRConstantsTransactionsUpdatedNotification object:nil];
}

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}

- (void)addSubviewTree
{
    [self.view addSubview:self.noTransactionsLabel];
    [self.view addSubview:self.transactionsTableView];
}

- (void)constrainViews
{
    NSMutableDictionary * views = [@{
                                     @"transactionsTableView":self.transactionsTableView,
                                     } mutableCopy];
    
    if (self.noTransactionsLabel) {
        views[@"noTransactionsLabel"] = self.noTransactionsLabel;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noTransactionsLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                   @"H:[noTransactionsLabel(240)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                   @"V:|-[noTransactionsLabel(100)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[transactionsTableView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[transactionsTableView(568)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)refreshTransactionsTable
{
    PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
    NSArray * sentTransactions = [[currentUser sentTransactions] allObjects];
    
    NSSortDescriptor *timestampDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    sentTransactions = [sentTransactions sortedArrayUsingDescriptors:@[timestampDescriptor]];
    
    NSArray * receivedTransactions = [[currentUser receivedTransactions] allObjects];
    receivedTransactions = [receivedTransactions sortedArrayUsingDescriptors:@[timestampDescriptor]];
    NSMutableArray * allTransactions = [@[] mutableCopy];
    if ([sentTransactions count]) {
        [allTransactions addObjectsFromArray:sentTransactions];
    }
    if ([receivedTransactions count]) {
        [allTransactions addObjectsFromArray:receivedTransactions];
    }
    self.transactionsArray = allTransactions;
    [self.transactionsTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger transCount = [self.transactionsArray count];
    if (transCount == 0) {
        self.noTransactionsLabel.hidden = NO;
        self.transactionsTableView.hidden = YES;
    }else{
        self.noTransactionsLabel.hidden = YES;
        self.transactionsTableView.hidden = NO;
    }
    return transCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIRProfileTransactionCell * cell = [tableView dequeueReusableCellWithIdentifier:kPIRProfileTransactionsTableViewCellIdentifier];
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    PIRTransaction *transaction = (PIRTransaction*)self.transactionsArray[indexPath.row];
    
    cell.amountLabel.text = [NSString stringWithFormat:@"%.2f", [transaction.amount floatValue]];
    cell.timestampLabel.text = [PIRFormatter timestampStringFromTimestamp:transaction.timestamp.timeIntervalSince1970];
    cell.actionLabel.text = NSLocalizedString(@"To", nil);
    
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    
    if ([transaction.fromUser.pierID isEqualToString:currentUser.pierID]){
        // transaction sent
        cell.fromUserLabel.text = NSLocalizedString(@"Me", nil);
        
        if ([transaction.toUser.firstName length] && [transaction.toUser.lastName length]){
            NSString *recipientName = [NSString stringWithFormat:@"%@ %@", transaction.toUser.firstName, transaction.toUser.lastName];
            cell.toUserLabel.text = recipientName;
        }else if ([transaction.toUser.email length]){
            cell.toUserLabel.text = transaction.toUser.email;
            
        }else if ([transaction.toUser.phoneNumber length]){
            cell.toUserLabel.text = transaction.toUser.phoneNumber;
            
        }
        
        
    }else{
        // transaction received
        NSString *senderName = [NSString stringWithFormat:@"%@ %@", transaction.fromUser.firstName, transaction.fromUser.lastName];
        cell.fromUserLabel.text = senderName;
        cell.toUserLabel.text = NSLocalizedString(@"Me", nil);
    }
    
    NSString *statusString = nil;
    switch ([transaction.status integerValue]) {
        case PIRTransactionStatusInactive:
            statusString = NSLocalizedString(@"Failed", nil);
            break;
        case PIRTransactionStatusActive:
            statusString = NSLocalizedString(@"Success", nil);
            break;
        case PIRTransactionStatusLocked:
            statusString = NSLocalizedString(@"Locked", nil);
            break;
        case PIRTransactionStatusProcessed:
            statusString = NSLocalizedString(@"Processed", nil);
            break;
        case PIRTransactionStatusDeniedByPayee:
            statusString = NSLocalizedString(@"Denied", nil);
            break;
        default:
            break;
    }
    cell.statusLabel.text = statusString;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPIRProfileTransactionsTableViewCellHeight;
}



#pragma mark - Event handlers

- (void)processTransactionsUpdatedNotification:(NSNotification*)notification
{
    [self refreshTransactionsTable];
}

@end
