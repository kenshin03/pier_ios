//
//  PIRReceivePaymentsViewController.m

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRReceivePaymentsViewController.h"
#import "PIRProfileTransactionCell.h"
#import "PIRTransaction.h"
#import "PIRUser.h"
#import "PIRUserServices.h"
#import "PIRTransactionServices.h"
#import "PIRSeparator.h"

static CGFloat const kPIRProfileTransactionsTableViewCellHeight = 44.0;
static NSString * const kPIRProfileTransactionsTableViewCellIdentifier = @"kPIRProfileTransactionsTableViewCellIdentifier";


@interface PIRReceivePaymentsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * receivedChargeRequestsTitleLabel;
@property (nonatomic, strong) UILabel * noReceivedTransactionsLabel;

@property (nonatomic, strong) PIRSeparator * separator;

@property (nonatomic, strong) NSArray * receivedTransactions;
@property (nonatomic, strong) UITableView * transactionsTableView;



@end

@implementation PIRReceivePaymentsViewController

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
    [self update];
    [self subscribeToTransactionsReceivedNotification];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPIRConstantsTransactionsReceivedNotification object:nil];
    
}

#pragma mark - public properties

#pragma mark - Private

#pragma mark - private properties

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (NSArray*)receivedTransactions
{
    if (!_receivedTransactions) {
        _receivedTransactions = [NSArray new];
    }
    return _receivedTransactions;
}

- (PIRSeparator*)separator
{
    if (!_separator) {
        _separator = [PIRSeparator new];
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _separator;
}

- (UILabel*)receivedChargeRequestsTitleLabel
{
    if (!_receivedChargeRequestsTitleLabel) {
        _receivedChargeRequestsTitleLabel = [UILabel new];
        _receivedChargeRequestsTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _receivedChargeRequestsTitleLabel.font = [PIRFont sectionTitleFont];
        _receivedChargeRequestsTitleLabel.textColor = [PIRColor primaryTextColor];
        _receivedChargeRequestsTitleLabel.text = NSLocalizedString(@"Received Charges & Payments:", nil);
    }
    return _receivedChargeRequestsTitleLabel;
}

- (UILabel*)noReceivedTransactionsLabel
{
    if (!_noReceivedTransactionsLabel) {
        _noReceivedTransactionsLabel = [UILabel new];
        _noReceivedTransactionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noReceivedTransactionsLabel.font = [PIRFont statusLabelFont];
        _noReceivedTransactionsLabel.text = NSLocalizedString(@"You have not received any payments or charges in ", nil);
        _noReceivedTransactionsLabel.textColor = [PIRColor secondaryTextColor];
        _noReceivedTransactionsLabel.numberOfLines = 0;
    }
    return _noReceivedTransactionsLabel;
}

-(UITableView*)transactionsTableView
{
    if (!_transactionsTableView) {
        _transactionsTableView = [UITableView new];
        _transactionsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _transactionsTableView.backgroundColor = [UIColor clearColor];
        _transactionsTableView.dataSource = self;
        _transactionsTableView.hidden = YES;
        
        // this line hides empty cells below the cells
        _transactionsTableView.tableFooterView = [UIView new];
        [_transactionsTableView registerClass:[PIRProfileTransactionCell class] forCellReuseIdentifier:kPIRProfileTransactionsTableViewCellIdentifier];
        
    }
    return _transactionsTableView;
}


#pragma mark - loadView helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [PIRColor defaultBackgroundColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}


- (void)setupNavigationBar
{
    self.navigationItem.title = NSLocalizedString(@"Received", @"Received");
}

- (void)addSubviewTree
{
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.receivedChargeRequestsTitleLabel];
    [self.contentView addSubview:self.noReceivedTransactionsLabel];
    [self.contentView addSubview:self.transactionsTableView];
    [self.contentView addSubview:self.separator];
}

- (void)constrainViews
{
    NSDictionary * baseViews = @{
                             @"separator":self.separator,
                             @"contentView":self.contentView,
                             @"receivedChargeRequestsTitleLabel":self.receivedChargeRequestsTitleLabel,
                             };
    NSMutableDictionary * views = [@{} mutableCopy];
    if ([self.receivedTransactions count] == 0){
        views[@"noReceivedTransactionsLabel"] = self.noReceivedTransactionsLabel;
    }else{
        views[@"transactionsTableView"] = self.transactionsTableView;
    }
    
    [views addEntriesFromDictionary:baseViews];
    
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
                                      @"H:|-[receivedChargeRequestsTitleLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-120-[receivedChargeRequestsTitleLabel]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    if (views[@"noReceivedTransactionsLabel"]) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"V:[receivedChargeRequestsTitleLabel]-30-[noReceivedTransactionsLabel]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]
         ];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"H:|-[noReceivedTransactionsLabel]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]
         ];
    }
    if (views[@"transactionsTableView"]) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"V:[receivedChargeRequestsTitleLabel]-30-[transactionsTableView(250)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]
         ];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"H:|-[transactionsTableView]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]
         ];
    }
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[separator]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
}

- (void)update
{
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    NSArray *receivedTransactions = [[PIRTransactionServices sharedService] retrieveTransactionsReceivedBy:currentUser];
    self.receivedTransactions = receivedTransactions;
    if ([self.receivedTransactions count] == 0){
        self.noReceivedTransactionsLabel.hidden = NO;
        self.transactionsTableView.hidden = YES;
    }else{
        self.noReceivedTransactionsLabel.hidden = YES;
        self.transactionsTableView.hidden = NO;
    }
    
}

- (void)subscribeToTransactionsReceivedNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processTransactionsReceivedNotification:) name:kPIRConstantsTransactionsReceivedNotification object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.receivedTransactions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIRProfileTransactionCell * cell = [tableView dequeueReusableCellWithIdentifier:kPIRProfileTransactionsTableViewCellIdentifier forIndexPath:indexPath];
    
    PIRTransaction * receivedTransaction = self.receivedTransactions[indexPath.row];
    
    NSString *fromUserName = [NSString stringWithFormat:@"%@ %@", receivedTransaction.fromUser.firstName, receivedTransaction.fromUser.lastName];
    cell.amountLabel.text = [NSString stringWithFormat:@"%.2f", [receivedTransaction.amount floatValue]];
    cell.fromUserLabel.text = fromUserName;
    cell.actionLabel.text = NSLocalizedString(@"To", nil);
    cell.toUserLabel.text = NSLocalizedString(@"Me", nil);
    cell.timestampLabel.text = [PIRFormatter timestampStringFromTimestamp:receivedTransaction.timestamp.timeIntervalSince1970];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPIRProfileTransactionsTableViewCellHeight;
}



#pragma mark - Event handler methods

-(void)processTransactionsReceivedNotification:(NSNotificationCenter*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
        self.receivedTransactions = [[currentUser receivedTransactions] allObjects];
        [self.transactionsTableView reloadData];
    });
    
}


@end
