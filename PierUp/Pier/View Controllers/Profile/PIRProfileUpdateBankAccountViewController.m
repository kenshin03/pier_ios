//
//  PIRProfileUpdateBankAccountViewController.m

//
//  Created by Kenny Tang on 2/26/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileUpdateBankAccountViewController.h"
#import "MRProgress.h"
#import "PIRSeparator.h"
#import "PIRBankAccount+Extensions.h"
#import "PIRProfileVerifyBankAccountViewController.h"
#import "PIRTextFieldElementView.h"
#import "PIRSwitchFieldElementView.h"
#import "PIRUserServices.h"
#import "PIRTransactionServices.h"

@interface PIRProfileUpdateBankAccountViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIButton *verifyButton;
@property (nonatomic, strong) UIButton *deactivateButton;
@property (nonatomic, strong) PIRSeparator *separator;
@property (nonatomic, strong) PIRTextFieldElementView   *accountNumberView;
@property (nonatomic, strong) PIRTextFieldElementView   *routingNumberView;
@property (nonatomic, strong) PIRTextFieldElementView   *bankNameView;
@property (nonatomic, strong) PIRTextFieldElementView   *countryView;
@property (nonatomic, strong) UISegmentedControl        *accountTypeSwitch;
@property (nonatomic, strong) PIRSwitchFieldElementView *defaultAccountView;

@end

@implementation PIRProfileUpdateBankAccountViewController


#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self addSubviewTree];
    [self setupNavigationBar];
    [self constrainViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.bankAccount){
        [self updateViewsWithBankAccount:self.bankAccount];
    }
}

#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties

- (PIRSwitchFieldElementView*)defaultAccountView
{
    if (!_defaultAccountView){
        _defaultAccountView = [[PIRSwitchFieldElementView alloc] initSwitchFieldElementViewWith:NSLocalizedString(@"Primary Account?", nil) delagate:nil];
        _defaultAccountView.switchControl.enabled = NO;
    }
    return _defaultAccountView;
}

- (UISegmentedControl*)accountTypeSwitch
{
    if (!_accountTypeSwitch) {
        _accountTypeSwitch = [[UISegmentedControl alloc] initWithItems:@[
                                                                         NSLocalizedString(@"Checking", nil), NSLocalizedString(@"Saving", nil)]];
        _accountTypeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        _accountTypeSwitch.selectedSegmentIndex = 0;
        _accountTypeSwitch.enabled = NO;
    }
    return _accountTypeSwitch;
}

- (PIRSeparator*)separator
{
    if (!_separator) {
        _separator = [PIRSeparator new];
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _separator;
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (UIBarButtonItem*)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissButtonTapped:)];
        _doneButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
    }
    return _doneButton;
}

- (UIButton *)verifyButton
{
    if(!_verifyButton)
    {
        _verifyButton = [UIButton new];
        _verifyButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_verifyButton setTitle:@"Verify Account" forState:UIControlStateNormal];
        _verifyButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_verifyButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _verifyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _verifyButton.layer.borderWidth = 0.5;
        [_verifyButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_verifyButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_verifyButton addTarget:self action:@selector(verifyButtonTapped:) forControlEvents:UIControlEventTouchDown];
        
        
    }
    return _verifyButton;
}

- (UIButton *)deactivateButton
{
    if(!_deactivateButton)
    {
        _deactivateButton = [UIButton new];
        _deactivateButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_deactivateButton setTitle:NSLocalizedString(@"Deactivate Account", nil) forState:UIControlStateNormal];
        [_deactivateButton setTintColor:[PIRColor defaultButtonTextColor]];
        _deactivateButton.backgroundColor = [PIRColor defaultTintColor];
        _deactivateButton.layer.cornerRadius = 3.0;
        _deactivateButton.layer.masksToBounds = YES;
        [_deactivateButton addTarget:self action:@selector(deactivateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deactivateButton;
}


- (PIRTextFieldElementView *)accountNumberView
{
    if(!_accountNumberView) {
        _accountNumberView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Account No:", nil) keyBoardType:UIKeyboardTypeNumberPad delagate:nil];
        _accountNumberView.elementTextField.enabled = NO;
    }
    return _accountNumberView;
}

- (PIRTextFieldElementView *)routingNumberView
{
    if(!_routingNumberView) {
        _routingNumberView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Routing No:", nil) keyBoardType:UIKeyboardTypeNumberPad delagate:nil];
        _routingNumberView.elementTextField.enabled = NO;
    }
    return _routingNumberView;
}

- (PIRTextFieldElementView *)bankNameView
{
    if(!_bankNameView) {
        _bankNameView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Bank Name:", nil) keyBoardType:UIKeyboardTypeDefault delagate:nil];
        _bankNameView.elementTextField.enabled = NO;
    }
    return _bankNameView;
}

- (PIRTextFieldElementView *)countryView
{
    if(!_countryView) {
        _countryView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Country:", nil) keyBoardType:UIKeyboardTypeDefault delagate:nil];
        _countryView.elementTextField.enabled = NO;
    }
    return _countryView;
}


-(void)setBankAccount:(PIRBankAccount *)bankAccount
{
    _bankAccount = bankAccount;
    [self updateViewsWithBankAccount:bankAccount];
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
    self.navigationItem.title = NSLocalizedString(@"Update Bank Account", nil);
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)addSubviewTree
{
    
    [self.contentView addSubview:self.separator];
    [self.contentView addSubview:self.accountNumberView];
    [self.contentView addSubview:self.routingNumberView];
    [self.contentView addSubview:self.bankNameView];
    [self.contentView addSubview:self.countryView];
    [self.contentView addSubview:self.accountTypeSwitch];
    [self.contentView addSubview:self.defaultAccountView];
//    if ([self.bankAccount.status integerValue] == P)
    [self.contentView addSubview:self.verifyButton];
    [self.contentView addSubview:self.deactivateButton];
    
    [self.view addSubview:self.contentView];
}

- (void)constrainViews
{
    
    NSMutableDictionary * views = [@{
                             @"contentView":self.contentView,
                             @"accountNumberView":self.accountNumberView,
                             @"routingNumberView":self.routingNumberView,
                             @"bankNameView":self.bankNameView,
                             @"countryView":self.countryView,
                             @"accountTypeSwitch":self.accountTypeSwitch,
                             @"defaultAccountView":self.defaultAccountView,
                             @"deactivateButton":self.deactivateButton
                             } mutableCopy];
    if (self.verifyButton.superview){
        views[@"verifyButton"] = self.verifyButton;
    }
    
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
                                      @"H:|[accountNumberView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[routingNumberView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[bankNameView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[countryView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    if (views[@"verifyButton"]){
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"H:|-[verifyButton]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]
         ];
    }
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[deactivateButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[accountTypeSwitch]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[defaultAccountView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    if (views[@"verifyButton"]){
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"V:|-80-[accountTypeSwitch]-20-[accountNumberView]-[routingNumberView]-[bankNameView]-[countryView]-[defaultAccountView]-20-[verifyButton(44)]-40-[deactivateButton(44)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }else{
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"V:|-80-[accountTypeSwitch]-20-[accountNumberView]-[routingNumberView]-[bankNameView]-[countryView]-[defaultAccountView]-40-[deactivateButton(44)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }

}

- (void)updateViewsWithBankAccount:(PIRBankAccount*)bankAccount
{
    self.accountNumberView.elementTextField.text = bankAccount.accountNumber;
    self.routingNumberView.elementTextField.text = bankAccount.routingNumber;
    self.bankNameView.elementTextField.text =  bankAccount.bankName;
    self.countryView.elementTextField.text = bankAccount.country;
    if ([bankAccount.accountType integerValue] == PIRBankAccountTypeChecking){
        self.accountTypeSwitch.selectedSegmentIndex = 0;
    }else{
        self.accountTypeSwitch.selectedSegmentIndex = 1;
    }
    self.defaultAccountView.switchControl.on = [bankAccount.isDefault boolValue];
    if ([bankAccount.isVerified integerValue] == YES){
        self.verifyButton.hidden = YES;
    }
}

#pragma mark - Event handlers


- (void)deactivateButtonTapped:(id)sender
{
    MRProgressOverlayView * progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = NSLocalizedString(@"Updating...", nil);
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view.superview addSubview:progressView];
    [progressView show:YES];
    
    [[PIRUserServices sharedService] removeBankAccount:self.bankAccount success:^{
        
        DLog(@"remove bank account success");
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressView dismiss:YES];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                // nothing
                [self.bankAccount deleteEntity];
            }];
        });
    } error:^(NSError *error) {
        DLog(@"remove bank acocunt failure");
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressView dismiss:YES];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    
}


- (void)verifyButtonTapped:(id)sender
{
    PIRProfileVerifyBankAccountViewController *vc = [PIRProfileVerifyBankAccountViewController new];
    vc.bankAccount = self.bankAccount;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dismissButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // nothing
    }];
}



@end
