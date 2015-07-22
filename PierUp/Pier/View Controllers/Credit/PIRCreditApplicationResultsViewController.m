//
//  PIRCreditApplicationResultsViewController.m

//
//  Created by Kenny Tang on 3/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRCreditApplicationResultsViewController.h"

@interface PIRCreditApplicationResultsViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *resultsHeaderLabel;
@property (nonatomic, strong) UILabel *resultsLabel;
@property (nonatomic, strong) UILabel *resultsSubLabel;
@property (nonatomic, strong) UIBarButtonItem * dismissButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation PIRCreditApplicationResultsViewController


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
	// Do any additional setup after loading the view.
}

- (void)dealloc
{
}

#pragma mark - Initialization

#pragma mark - Public properties

- (void)setCreditAmount:(NSNumber *)creditAmount
{
    _creditAmount = creditAmount;
    if (creditAmount){
        self.resultsLabel.text = [NSString stringWithFormat:@"$%.2f", [creditAmount floatValue]];
    }
}

- (void)setApplicationSucessful:(BOOL)applicationSucessful
{
    _applicationSucessful = applicationSucessful;
    if (!applicationSucessful){
        self.resultsHeaderLabel.text = NSLocalizedString(@"Sorry. We are unable to pre-qualify a credit application for you.\n\nPlease try again later.", nil);
        self.confirmButton.hidden = YES;
    }else{
        self.resultsHeaderLabel.text = NSLocalizedString(@"You are pre-qualified for a credit of:", nil);
        [self.confirmButton setTitle:NSLocalizedString(@"Find out more", nil) forState:UIControlStateNormal];
        self.confirmButton.hidden = NO;
    }
}

#pragma mark - Private

#pragma mark - Private properties

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}


- (UILabel*)resultsHeaderLabel
{
    if (!_resultsHeaderLabel) {
        _resultsHeaderLabel = [UILabel new];
        _resultsHeaderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _resultsHeaderLabel.font = [PIRFont statusLabelFont];
        _resultsHeaderLabel.numberOfLines = 0;
    }
    return _resultsHeaderLabel;
}


- (UILabel*)resultsLabel
{
    if (!_resultsLabel) {
        _resultsLabel = [UILabel new];
        _resultsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _resultsLabel.font = [PIRFont paymentAmountsMediumLabelFont];
        _resultsLabel.numberOfLines = 0;
    }
    return _resultsLabel;
}

- (UILabel*)resultsSubLabel
{
    if (!_resultsSubLabel) {
        _resultsSubLabel = [UILabel new];
        _resultsSubLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _resultsSubLabel.font = [PIRFont paymentAmountsSmallLabelFont];
        _resultsSubLabel.numberOfLines = 0;
    }
    return _resultsSubLabel;
}

- (UIBarButtonItem*)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismissButtonTapped:)];
        _dismissButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
        
    }
    return _dismissButton;
}

- (UIButton *)confirmButton
{
    if(!_confirmButton)
    {
        _confirmButton = [UIButton new];
        _confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_confirmButton setTitle:@"Confirm application?" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_confirmButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _confirmButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _confirmButton.layer.borderWidth = 0.5;
        [_confirmButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}


#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [PIRColor defaultBackgroundColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}

- (void)setupNavigationBar
{
    self.navigationItem.title = nil;
    self.navigationItem.rightBarButtonItem = self.dismissButton;
    self.navigationItem.hidesBackButton = YES;
}

- (void)addSubviewTree
{
    [self.contentView addSubview:self.resultsHeaderLabel];
    [self.contentView addSubview:self.resultsLabel];
    [self.contentView addSubview:self.resultsSubLabel];
    [self.contentView addSubview:self.confirmButton];
    [self.view addSubview:self.contentView];
}

- (void)constrainViews
{
    NSMutableDictionary * views = [@{
                                     @"contentView":self.contentView,
                                     @"resultsHeaderLabel":self.resultsHeaderLabel,
                                     @"resultsLabel":self.resultsLabel,
                                     @"resultsSubLabel":self.resultsSubLabel,
                                     @"confirmButton":self.confirmButton,
                                     } mutableCopy];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[contentView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[contentView(568)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[resultsLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[resultsHeaderLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[confirmButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-140-[resultsHeaderLabel]-[resultsLabel]-[resultsSubLabel]-40-[confirmButton(44)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
}

#pragma mark - Event handlers



- (void)confirmButtonTapped:(id)sender
{
    DLog(@"confirmButtonTapped");
}


- (void)dismissButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // nothing
    }];
}


@end
