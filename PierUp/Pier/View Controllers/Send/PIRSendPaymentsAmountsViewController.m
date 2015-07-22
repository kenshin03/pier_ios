//
//  PIRSendPaymentsAmountsViewController.m

//
//  Created by Kenny Tang on 12/13/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRSendPaymentsAmountsViewController.h"
#import "MRProgress.h"
#import "PIRAvatar.h"
#import "PIRMenuTabBarController.h"
#import "PIRPeerConnectivity.h"
#import "PIRSeparator.h"
#import "PIRUserServices.h"
#import "PIRTextFieldElementView.h"
#import "PIRDateFieldElementView.h"
#import "PIRTransactionServices.h"
#import "PIRCountrySelectElementView.h"

static  NSString* const kPIRSendPaymentsAmountsViewControllerDateFormat = @"MM/dd/yyyy HH:mm";

@interface PIRSendPaymentsAmountsViewController ()<
PIRTextFieldElementViewDelegate,
PIRDateFieldElementViewDelegate,
PIRCountrySelectElementViewDelegate
>
@property (nonatomic, strong) PIRUser *currentUser;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PIRPayeeInfoView *payeeInfoView;
@property (nonatomic, strong) PIRTextFieldElementView *paymentAmountView;
@property (nonatomic, strong) UILabel *convertedCurrencyLabel;
@property (nonatomic, strong) PIRTextFieldElementView *paymentNotesView;
@property (nonatomic, strong) PIRDateFieldElementView *paymentScheduleView;
@property (nonatomic, strong) PIRTextFieldElementView *messageView;
@property (nonatomic, strong) PIRCountrySelectElementView *countryView;
@property (nonatomic, strong) UIBarButtonItem *sendButton;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *datePickerToolbar;
@property (nonatomic, strong) UIButton *dismissPickerButton;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *selectedCountry;

@end

@implementation PIRSendPaymentsAmountsViewController


#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
    self.selectedCountry = @"USD";
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initialization

#pragma mark - Public properties

- (void)setToUser:(PIRUser*)user {
    _toUser = user;
    [self updateViewWithUser:user];
}

#pragma mark - Private

#pragma mark - Private properties

-(UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

-(UIBarButtonItem*)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendButtonTapped:)];
        _sendButton.enabled = NO;
        _sendButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
    }
    return _sendButton;
}

-(PIRPayeeInfoView*)payeeInfoView
{
    if (!_payeeInfoView) {
        _payeeInfoView = [PIRPayeeInfoView new];
        _payeeInfoView.backgroundColor = [UIColor clearColor];
    }
    return _payeeInfoView;
}

-(PIRTextFieldElementView*)paymentAmountView
{
    if (!_paymentAmountView) {
        _paymentAmountView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Amount:", nil) keyBoardType:UIKeyboardTypeNumberPad  delagate:self];
        _paymentAmountView.translatesAutoresizingMaskIntoConstraints = NO;
        _paymentAmountView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsDecimal;
        _paymentAmountView.elementTextField.placeholder = NSLocalizedString(@"0.00", @"");
    }
    return _paymentAmountView;
}

-(PIRTextFieldElementView*)paymentNotesView
{
    if (!_paymentNotesView) {
        _paymentNotesView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Note:", nil) keyBoardType:UIKeyboardTypeDefault delagate:self];
        _paymentNotesView.translatesAutoresizingMaskIntoConstraints = NO;
        _paymentNotesView.elementTextField.placeholder = NSLocalizedString(@"Add a note", @"");
    }
    return _paymentNotesView;
}

-(PIRDateFieldElementView*)paymentScheduleView
{
    if (!_paymentScheduleView) {
        _paymentScheduleView = [[PIRDateFieldElementView alloc] initDateFieldElementViewWith:NSLocalizedString(@"When:", nil) delagate:self];
        _paymentScheduleView.translatesAutoresizingMaskIntoConstraints = NO;
        _paymentScheduleView.elementTextField.placeholder = NSLocalizedString(@"MM/DD/YY", @"");
        _paymentScheduleView.elementTextField.enabled = NO;
    }
    return _paymentScheduleView;
}

-(PIRTextFieldElementView*)messageView
{
    if (!_messageView) {
        _messageView = [PIRTextFieldElementView new];
        _messageView.backgroundColor = [UIColor clearColor];
    }
    return _messageView;
}

-(PIRCountrySelectElementView*)countryView
{
    if (!_countryView) {
        _countryView = [[PIRCountrySelectElementView alloc] initWithTitle:NSLocalizedString(@"Currency:", nil) delegate:self];
    }
    return _countryView;
}

-(UILabel*)convertedCurrencyLabel
{
    if (!_convertedCurrencyLabel) {
        _convertedCurrencyLabel = [UILabel new];
        _convertedCurrencyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _convertedCurrencyLabel.font = [PIRFont introduceLabelFont];
        _convertedCurrencyLabel.textAlignment = NSTextAlignmentRight;
        _convertedCurrencyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _convertedCurrencyLabel;
}


- (UIDatePicker*) datePicker
{
    if (!_datePicker) {
        _datePicker = [UIDatePicker new];
        _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDate * currentDate = [NSDate new];
        
        _datePicker.minimumDate = currentDate;
        _datePicker.minuteInterval = 30;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [NSDateComponents new];
        [offsetComponents setDay:30];
        NSDate *thirtyDaysDate = [calendar dateByAddingComponents:offsetComponents toDate:currentDate options:0];
        
        _datePicker.maximumDate = thirtyDaysDate;
        
        [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker.hidden = YES;
    }
    return _datePicker;
}


-(UIToolbar*)datePickerToolbar
{
    if (!_datePickerToolbar) {
        _datePickerToolbar = [UIToolbar new];
        _datePickerToolbar.translatesAutoresizingMaskIntoConstraints = NO;
        UIButton * dismissPickerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [dismissPickerButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        dismissPickerButton.tintColor = [PIRColor defaultTintColor];
        dismissPickerButton.frame = CGRectMake(230.0, 0.0, 100.0, 44.0);
        [dismissPickerButton setTitle:NSLocalizedString(@"Done", Nil) forState:UIControlStateNormal];
        [dismissPickerButton addTarget:self action:@selector(dismissDatePickerButtonTapped:) forControlEvents:UIControlEventTouchDown];
        _datePickerToolbar.hidden = YES;
        [_datePickerToolbar addSubview:dismissPickerButton];
    }
    return _datePickerToolbar;
}

-(NSDateFormatter*)dateFormatter
{
    if (!_dateFormatter){
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = kPIRSendPaymentsAmountsViewControllerDateFormat;
    }
    return _dateFormatter;
}

#pragma mark - update view helpers


-(void)updateViewWithUser:(PIRUser*)user
{
    self.payeeInfoView.user = user;
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
    self.navigationItem.title = NSLocalizedString(@"Enter Amount", nil);
    self.navigationItem.rightBarButtonItem = self.sendButton;
}

- (void)addSubviewTree
{
    [self.contentView addSubview:self.payeeInfoView];
    [self.contentView addSubview:self.paymentAmountView];
    [self.contentView addSubview:self.convertedCurrencyLabel];
    [self.contentView addSubview:self.paymentNotesView];
    [self.contentView addSubview:self.paymentScheduleView];
    [self.contentView addSubview:self.countryView];
    [self.contentView addSubview:self.datePickerToolbar];
    [self.contentView addSubview:self.datePicker];
    [self.view addSubview:self.contentView];
    
}


- (void)constrainViews
{
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"payeeInfoView":self.payeeInfoView,
                             @"paymentAmountView":self.paymentAmountView,
                             @"convertedCurrencyLabel":self.convertedCurrencyLabel,
                             @"paymentNotesView":self.paymentNotesView,
                             @"paymentScheduleView":self.paymentScheduleView,
                             @"countryView":self.countryView,
                             @"datePickerToolbar":self.datePickerToolbar,
                             @"datePickerView":self.datePicker
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[contentView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[contentView(548)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[payeeInfoView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[paymentAmountView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:[convertedCurrencyLabel(<=300)]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[paymentNotesView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[countryView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[paymentScheduleView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[datePickerView(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[datePickerToolbar(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[payeeInfoView(130)]-30-[paymentAmountView(44)]-[paymentNotesView(44)]-[countryView(44)]-[convertedCurrencyLabel]-[paymentScheduleView(44)][datePickerToolbar(44)][datePickerView]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

#pragma mark - Event Handler methods

- (void)dismissDatePickerButtonTapped:(id)sender
{
    self.datePicker.hidden = YES;
    self.datePickerToolbar.hidden = YES;
}

- (void)datePickerChanged:(UIDatePicker*)picker
{
    NSDate * selectedDate = picker.date;
    NSString * formattedString = [self.dateFormatter stringFromDate:selectedDate];
    self.paymentScheduleView.elementTextField.text = formattedString;
    [self checkAllFieldsFilledIn];
}


- (void)sendButtonTapped:(id)sender
{
    // TODO: validation
    
    [self.paymentAmountView resignFirstResponder];
    
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];

    PIRTransaction * trans = [PIRTransaction createInContext:[NSManagedObjectContext defaultContext]];
    trans.requestType = PIRTransactionRequestTypePay;
    trans.status = @(PIRTransactionStatusActive);
    trans.amount = [[NSDecimalNumber alloc] initWithFloat:[self.paymentAmountView.elementTextField.text floatValue]];
    trans.fromUser = currentUser;
    trans.notes = self.paymentNotesView.elementTextField.text?self.paymentNotesView.elementTextField.text:@"";
    NSDate *currentDate = [NSDate date];
    trans.created = currentDate;
    trans.currency = self.selectedCountry;
    trans.toUser = self.toUser;
    
    NSString *scheduledDateString = self.paymentScheduleView.elementTextField.text;
    trans.scheduledDate = [self.dateFormatter dateFromString:scheduledDateString];
    trans.timestamp = currentDate;
    
    MRProgressOverlayView * progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = NSLocalizedString(@"Sending Payment...", nil);
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view.superview addSubview:progressView];
    [progressView show:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPIRConstantsTransactionsUpdatedNotification object:self];
    
    
    PIRTransactionServices * transactionServices = [PIRTransactionServices sharedService];
    [transactionServices sendPayment:trans toUser:self.toUser success:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.titleLabelText = NSLocalizedString(@"Completed.", nil);
            progressView.mode = MRProgressOverlayViewModeCheckmark;
            
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [progressView dismiss:YES];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        });
        
    } error:^(NSError *error) {
        ELog(@"Error in sendButtonTapped: %@", error);
        
        NSString *errorString = nil;
        NSDictionary *errorDict = error.userInfo;
        NSString *errorStringFromServer = errorDict[@"message"];
        errorStringFromServer = errorStringFromServer?errorStringFromServer:@"";
        
        switch (error.code) {
            
                
            case PIRUserServicesErrorCodePrimaryBankAccountNotSetupError:
                errorString = NSLocalizedString(@"Please add a primary bank account before sending payment.", nil);
                break;
            case PIRUserServicesErrorCodePierAccountNotFound:
                errorString = NSLocalizedString(@"Recipient account not found. Please check again.", nil);
                break;
            case PIRTransactionServicesErrorCodeLowBalanceFrom:
                errorString = NSLocalizedString(@"Insufficient balance in bank account. Please check again.", nil);
                break;
            case PIRTransactionServicesErrorCodeLowBalanceTo:
                errorString = NSLocalizedString(@"Insufficient balance in bank account. Please check again.", nil);
                break;
            case PIRTransactionServicesErrorCodeInvalidFromAccount:
                errorString = NSLocalizedString(@"Selected bank account invalid. Please check again.", nil);
                break;
            case PIRTransactionServicesErrorCodeInvalidToAccount:
                errorString = NSLocalizedString(@"Recipient bank account invalid. Please check again.", nil);
                break;
            case PIRTransactionServicesErrorCodeInvalidAmount:
                errorString = NSLocalizedString(@"Amount invalid. Please check again.", nil);
                break;
            case PIRTransactionServicesErrorCodePhoneEmailNotVerified:
                errorString = NSLocalizedString(@"User not verified by account email or phone. Please check again.", nil);
                break;
                
            default:
                errorString = NSLocalizedString(@"An error occurred. Please try again later.", nil);
                break;
        }
        
        NSString *errorStringFull = [NSString stringWithFormat:@"%@\n%@",errorString, errorStringFromServer];

        progressView.titleLabelText = errorStringFull;
        progressView.mode = MRProgressOverlayViewModeCross;
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [progressView dismiss:YES];
        });
        
    }];
}

#pragma mark - PIRTextFieldElementViewDelegate methods

- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidBeginEditing:(UITextField *)textField
{
    [self dismissDatePickerButtonTapped:nil];
}

- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidChange:(UITextField *)textField
{
    if (view == self.paymentAmountView){
        [self updateConvertedConcurrencyView];
    }
    
    [self checkAllFieldsFilledIn];
}

#pragma mark - PIRTextFieldElementViewDelegate helper

- (void)updateConvertedConcurrencyView
{
    NSNumber *cnyToUSDRate = [[PIRTransactionServices sharedService] cnyToUSDRate];
    
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    if ([currentUser.country isEqualToString:@"US"]) {
        
        if ([self.selectedCountry isEqualToString:@"CNY"]){
            
            CGFloat fromAmount = [self.paymentAmountView.elementTextField.text floatValue];
            CGFloat toAmount = fromAmount /  [cnyToUSDRate floatValue];
            self.convertedCurrencyLabel.text = [NSString stringWithFormat:@"Converted amount: %.2f", toAmount];
            
        }else if ([self.selectedCountry isEqualToString:@"USD"]){
            
            CGFloat fromAmount = [self.paymentAmountView.elementTextField.text floatValue];
            CGFloat toAmount = fromAmount * 1.0;
            self.convertedCurrencyLabel.text = [NSString stringWithFormat:@"Converted amount: %.2f", toAmount];
        }
        
    }else if ([currentUser.country isEqualToString:@"CN"]) {
        
        if ([self.selectedCountry isEqualToString:@"CNY"]){
            
            CGFloat fromAmount = [self.paymentAmountView.elementTextField.text floatValue];
            CGFloat toAmount = fromAmount * 1;
            self.convertedCurrencyLabel.text = [NSString stringWithFormat:@"Converted amount: %.2f", toAmount];
            
        }else if ([self.selectedCountry isEqualToString:@"USD"]){
            
            CGFloat fromAmount = [self.paymentAmountView.elementTextField.text floatValue];
            CGFloat toAmount = fromAmount * [cnyToUSDRate floatValue];
            self.convertedCurrencyLabel.text = [NSString stringWithFormat:@"Converted amount: %.2f", toAmount];
        }
        
    }
}

#pragma mark - PIRDateFieldElementViewDelegate methods

- (void)dateField:(PIRDateFieldElementView*)view didTapOnCalendarButton:(BOOL)tapped
{
    self.datePicker.hidden = !self.datePicker.hidden;
    self.datePickerToolbar.hidden = !self.datePickerToolbar.hidden;
}

#pragma mark - PIRTextFieldElementViewDelegate helpers

- (void)checkAllFieldsFilledIn
{
    BOOL isAmountValidated = [self.paymentAmountView validateTextField];
    CGFloat amount = [self.paymentAmountView.elementTextField.text floatValue];
    if ((isAmountValidated) && (amount > 0)){
        isAmountValidated = YES;
    }else{
        isAmountValidated = NO;
    }
    BOOL isScheduleValidated = [self.paymentScheduleView validateDateField];
    if (isAmountValidated && isScheduleValidated){
        self.sendButton.enabled = YES;
    }
}

#pragma mark - PIRCountrySelectElementViewDelegate methods

-(void)countrySelectView:(PIRCountrySelectElementView*)view usButtonTapped:(BOOL)tapped
{
    self.selectedCountry = @"USD";
    [self updateConvertedConcurrencyView];
}

-(void)countrySelectView:(PIRCountrySelectElementView*)view cnButtonTapped:(BOOL)tapped
{
    self.selectedCountry = @"CNY";
    [self updateConvertedConcurrencyView];
}

@end


@interface PIRPayeeInfoView()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) PIRSeparator * separator;
@property (nonatomic, strong) PIRAvatar * avatar;

@end

@implementation PIRPayeeInfoView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubviewTree];
        [self constrainViews];
    }
    return self;
}

#pragma mark - Public properties

- (void)setUser:(PIRUser*)user {
    _user = user;
    [self updateViewWithUser:user];
}


#pragma mark - Private

#pragma mark - Private properties

- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.contentMode = UIViewContentModeLeft;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [PIRFont avatarNameFont];
        _nameLabel.textColor = [PIRColor primaryTextColor];
        _nameLabel.minimumScaleFactor = 0.4;
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
}

- (PIRSeparator*)separator
{
    if (!_separator) {
        _separator = [PIRSeparator new];
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
        _separator.backgroundColor = [UIColor redColor];
    }
    return _separator;
}

- (PIRAvatar*)avatar
{
    if (!_avatar) {
        _avatar = [PIRAvatar new];
        _avatar.backgroundColor = [UIColor clearColor];
        _avatar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _avatar;
}



#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self addSubview:self.nameLabel];
    [self addSubview:self.avatar];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"nameLabel":self.nameLabel,
                             @"avatar":self.avatar,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[avatar(60)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[avatar(60)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameLabel(190)]" options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.avatar
                                                     attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:1.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.avatar
                                                     attribute:NSLayoutAttributeRight multiplier:1.0 constant:40.0]];
    
}

-(void)updateViewWithUser:(PIRUser*)user
{
    if (([user.firstName length]) || ([user.lastName length])){
        self.nameLabel.font = [PIRFont avatarNameFont];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        self.avatar.user = self.user;
    }else{
        self.nameLabel.font = [PIRFont avatarNameSmallFont];
        if (user.email){
            self.nameLabel.text = user.email;
        }
        if (user.phoneNumber){
            self.nameLabel.text = user.phoneNumber;
        }
    }
}





@end

