//
//  PIRProfileAddBankAccountViewController.m

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileAddBankAccountViewController.h"
#import "MRProgress.h"
#import "PIRSeparator.h"
#import "PIRBankAccount+Extensions.h"
#import "PIRCountrySelectElementView.h"
#import "PIRTextFieldElementView.h"
#import "PIRSwitchFieldElementView.h"
#import "PIRUserServices.h"
#import "PIRTransactionServices.h"

@interface PIRProfileAddBankAccountViewController ()<
PIRSwitchFieldElementViewDelegate,
PIRTextFieldElementViewDelegate,
PIRCountrySelectElementViewDelegate
>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) PIRSeparator *separator;
@property (nonatomic, strong) PIRTextFieldElementView   *accountNumberView;
@property (nonatomic, strong) PIRTextFieldElementView   *routingNumberView;
@property (nonatomic, strong) PIRTextFieldElementView   *bankNameView;
@property (nonatomic, strong) PIRCountrySelectElementView *countryView;
@property (nonatomic, strong) UISegmentedControl        *accountTypeSwitch;
@property (nonatomic, strong) PIRSwitchFieldElementView *defaultAccountView;
@property (nonatomic) BOOL isDefaultAccountOn;
@property (nonatomic, strong) NSString *selectedCountry;
@end

@implementation PIRProfileAddBankAccountViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self addSubviewTree];
    [self setupNavigationBar];
    [self constrainViews];
    self.isDefaultAccountOn = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties

- (PIRSwitchFieldElementView*)defaultAccountView
{
    if (!_defaultAccountView){
        _defaultAccountView = [[PIRSwitchFieldElementView alloc] initSwitchFieldElementViewWith:NSLocalizedString(@"Primary Account?", nil) delagate:self];
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

- (UIBarButtonItem*)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismissButtonTapped:)];
        _dismissButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
    }
    return _dismissButton;
}

- (UIButton *)doneButton
{
    if(!_doneButton)
    {
        _doneButton = [UIButton new];
        _doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_doneButton setTitle:NSLocalizedString(@"Add Bank Account", nil) forState:UIControlStateNormal];
        [_doneButton setTintColor:[PIRColor defaultButtonTextColor]];
        _doneButton.backgroundColor = [PIRColor defaultTintColor];
        _doneButton.layer.cornerRadius = 3.0;
        _doneButton.layer.masksToBounds = YES;
        [_doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (PIRTextFieldElementView *)accountNumberView
{
    if(!_accountNumberView) {
        _accountNumberView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Account No:", nil) keyBoardType:UIKeyboardTypeNumberPad delagate:nil];
        _accountNumberView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsInteger |
        PIRTextFieldElementViewValidationLength;
        _accountNumberView.validateMinLength = 1;
        _accountNumberView.validateMaxLength = 12;
        [_accountNumberView.elementTextField becomeFirstResponder];
        
    }
    return _accountNumberView;
}

- (PIRTextFieldElementView *)routingNumberView
{
    if(!_routingNumberView) {
        _routingNumberView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Routing No:", nil) keyBoardType:UIKeyboardTypeNumberPad delagate:self];
        _routingNumberView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsInteger |
        PIRTextFieldElementViewValidationLength;
        _routingNumberView.validateMinLength = 1;
        _routingNumberView.validateMaxLength = 9;
        _routingNumberView.elementTextField.placeholder = @"e.g.321171184";
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

- (PIRCountrySelectElementView *)countryView
{
    if(!_countryView) {
        _countryView = [[PIRCountrySelectElementView alloc] initWithTitle:NSLocalizedString(@"Country", nil) delegate:self];
    }
    return _countryView;
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
    self.navigationItem.title = NSLocalizedString(@"Add Bank Account", nil);
    self.navigationItem.rightBarButtonItem = self.dismissButton;
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
    [self.contentView addSubview:self.doneButton];
    
    [self.view addSubview:self.contentView];
}

- (void)constrainViews
{
    
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"accountNumberView":self.accountNumberView,
                             @"routingNumberView":self.routingNumberView,
                             @"bankNameView":self.bankNameView,
                             @"countryView":self.countryView,
                             @"accountTypeSwitch":self.accountTypeSwitch,
                             @"defaultAccountView":self.defaultAccountView,
                             @"doneButton":self.doneButton,
                             };
    
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
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[doneButton]-|"
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
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-80-[accountTypeSwitch]-20-[accountNumberView]-[routingNumberView]-[bankNameView]-[countryView]-[defaultAccountView]-20-[doneButton]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
    
}

#pragma mark - Event handlers

- (BOOL)validateTextFields
{
    BOOL isValidated = YES;
    BOOL accountNumberValidated = ([self.accountNumberView validateTextField]);
    BOOL routingNumberValidated = ([self.routingNumberView validateTextField]);
    BOOL bankNameValidated = ([self.bankNameView validateTextField]);
    if (!(accountNumberValidated && routingNumberValidated && bankNameValidated)) {
        isValidated = NO;
    }
    return isValidated;
}

- (void)populateBankNameFieldFromRoutingNumber
{
    NSString * routingName = self.routingNumberView.elementTextField.text;
    if ([routingName length]) {
        NSString * bankName = [[PIRTransactionServices sharedService] lookUpBankNameWithRoutingNumber:routingName];
        self.bankNameView.elementTextField.text = bankName;
    }
}


- (void)doneButtonTapped:(id)sender
{
    [self populateBankNameFieldFromRoutingNumber];
    
    BOOL validated = [self validateTextFields];
    
    if (validated) {
        [self.accountNumberView.elementTextField resignFirstResponder];
        [self.routingNumberView.elementTextField resignFirstResponder];
        [self.bankNameView.elementTextField resignFirstResponder];
        
        NSString * accountNumberString = self.accountNumberView.elementTextField.text;
        
        MRProgressOverlayView * progressView = [MRProgressOverlayView new];
        progressView.titleLabelText = NSLocalizedString(@"Adding...", nil);
        progressView.mode = MRProgressOverlayViewModeIndeterminate;
        [self.view.superview addSubview:progressView];
        [progressView show:YES];
        
        
        PIRBankAccount * bankAccount = [PIRBankAccount createInContext:[NSManagedObjectContext defaultContext]];
        
        bankAccount.accountNumber = accountNumberString;
        bankAccount.routingNumber = self.routingNumberView.elementTextField.text;
        bankAccount.country = self.selectedCountry?self.selectedCountry:@"US";
        bankAccount.bankName = self.bankNameView.elementTextField.text;
        bankAccount.status = @(PIRBankAccountStatusActive);
        bankAccount.isDefault = @(self.isDefaultAccountOn);
        
        switch (self.accountTypeSwitch.selectedSegmentIndex) {
            case 0:
                bankAccount.accountType = @(PIRBankAccountTypeChecking);
                break;
            case 1:
                bankAccount.accountType = @(PIRBankAccountTypeSavings);
                break;
            default:
                bankAccount.accountType = @(PIRBankAccountTypeChecking);
                break;
        }
        
        [[PIRUserServices sharedService] addBankAccount:bankAccount success:^{
            
            MRProgressOverlayView * progressView = [MRProgressOverlayView new];
            progressView.titleLabelText = NSLocalizedString(@"Adding Bank Account...", nil);
            progressView.mode = MRProgressOverlayViewModeIndeterminate;
            [self.view.superview addSubview:progressView];
            [progressView show:YES];
            
            DLog(@"add bank account success");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dismissButton.enabled = NO;
                progressView.mode = MRProgressOverlayViewModeCheckmark;
                progressView.titleLabelText = NSLocalizedString(@"Pier will make two small deposits to this account. Please check and return to verify those deposits to ", nil);
                
                double delayInSeconds = 6.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    progressView.mode = MRProgressOverlayViewModeCheckmark;
                    [progressView dismiss:YES];
                    [self dismissButtonTapped:nil];
                    
                    if (bankAccount.isDefault){
                        [self resetDefaultStatusForOtherBankAccounts:bankAccount];
                    }
                });
                
                
            });
        } error:^(NSError *error) {
            DLog(@"add bank acocunt failure");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *errorString = NSLocalizedString(@"An error occurred. Please try again later.", nil);
                progressView.titleLabelText = errorString;
                progressView.mode = MRProgressOverlayViewModeCross;
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [progressView dismiss:YES];
                });
            });
        }];
    }
}

- (void)dismissButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // nothing
    }];
}

#pragma mark - doneButtonTapped helper method

- (void)resetDefaultStatusForOtherBankAccounts:(PIRBankAccount*)bankAccount
{
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    [currentUser.accounts enumerateObjectsUsingBlock:^(PIRBankAccount *account, BOOL *stop) {
        if ([account.accountNumber integerValue] != [bankAccount.accountNumber integerValue]){
            account.isDefault = NO;
        }
    }];
    
}

#pragma mark - PIRTextFieldElementViewDelegate methods

- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidChange:(UITextField *)textField
{
    if (view == self.routingNumberView) {
        [self populateBankNameFieldFromRoutingNumber];
    }
}

#pragma mark - PIRSwitchFieldElementViewDelegate methods

-(void)switchFieldElementView:(PIRSwitchFieldElementView*)view switchValueChanged:(BOOL)isOn
{
    self.isDefaultAccountOn = isOn;
}

#pragma mark - PIRCountrySelectElementViewDelegate methods

- (void)countrySelectView:(PIRCountrySelectElementView *)view cnButtonTapped:(BOOL)tapped
{
    self.selectedCountry = @"CN";
}

- (void)countrySelectView:(PIRCountrySelectElementView *)view usButtonTapped:(BOOL)tapped
{
    self.selectedCountry = @"US";
    
}

@end
