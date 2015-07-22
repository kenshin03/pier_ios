//
//  PIRProfileVerifyBankAccountViewController.m

//
//  Created by Kenny Tang on 3/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileVerifyBankAccountViewController.h"
#import "MRProgress.h"
#import "PIRBankAccount+Extensions.h"
#import "PIRTextFieldElementView.h"
#import "PIRUserServices.h"
#import "PIRTransactionServices.h"

@interface PIRProfileVerifyBankAccountViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) PIRTextFieldElementView   *amount1View;
@property (nonatomic, strong) PIRTextFieldElementView   *amount2View;

@end

@implementation PIRProfileVerifyBankAccountViewController

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

#pragma mark - Initialization

#pragma mark - Public properties

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

- (UIButton *)doneButton
{
    if(!_doneButton)
    {
        _doneButton = [UIButton new];
        _doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_doneButton setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
        [_doneButton setTintColor:[PIRColor defaultButtonTextColor]];
        _doneButton.backgroundColor = [PIRColor defaultTintColor];
        _doneButton.layer.cornerRadius = 3.0;
        _doneButton.layer.masksToBounds = YES;
        [_doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (PIRTextFieldElementView *)amount1View
{
    if(!_amount1View) {
        _amount1View = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"$0.", nil) keyBoardType:UIKeyboardTypeNumberPad delagate:nil];
        _amount1View.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsInteger |
        PIRTextFieldElementViewValidationLength;
        _amount1View.validateMinLength = 1;
        _amount1View.validateMaxLength = 2;
        [_amount1View.elementTextField becomeFirstResponder];
        
    }
    return _amount1View;
}

- (PIRTextFieldElementView *)amount2View
{
    if(!_amount2View) {
        _amount2View = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"$0.", nil) keyBoardType:UIKeyboardTypeNumberPad delagate:nil];
        _amount2View.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsInteger |
        PIRTextFieldElementViewValidationLength;
        _amount2View.validateMinLength = 1;
        _amount2View.validateMaxLength = 2;
    }
    return _amount2View;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = NSLocalizedString(@"Please enter the two amounts Pier deposited into your bank account.", nil);
        _titleLabel.font = [PIRFont statusLabelFont];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
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
    self.navigationItem.title = NSLocalizedString(@"Verify Account", nil);
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)addSubviewTree
{
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.amount1View];
    [self.contentView addSubview:self.amount2View];
    [self.contentView addSubview:self.doneButton];
    
    [self.view addSubview:self.contentView];
}

- (void)constrainViews
{
    
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"titleLabel":self.titleLabel,
                             @"amount1View":self.amount1View,
                             @"amount2View":self.amount2View,
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
                                      @"H:|-[titleLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[amount1View]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[amount2View]|"
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
                                      @"V:|-100-[titleLabel]-40-[amount1View]-20-[amount2View]-40-[doneButton(44)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
    
}

#pragma mark - Event handlers

- (BOOL)validateTextFields
{
    BOOL isValidated = YES;
    if (!([self.amount1View validateTextField] && [self.amount2View validateTextField])) {
        isValidated = NO;
    }
    return isValidated;
}


- (void)doneButtonTapped:(id)sender
{
    BOOL validated = [self validateTextFields];
    
    if (validated) {
        [self.amount1View.elementTextField resignFirstResponder];
        [self.amount2View.elementTextField resignFirstResponder];
        
        MRProgressOverlayView * progressView = [MRProgressOverlayView new];
        progressView.titleLabelText = NSLocalizedString(@"Updating...", nil);
        progressView.mode = MRProgressOverlayViewModeIndeterminate;
        [self.view.superview addSubview:progressView];
        [progressView show:YES];
        
        NSUInteger amount1 = [self.amount1View.elementTextField.text integerValue];
        NSUInteger amount2 = [self.amount2View.elementTextField.text integerValue];
        
        [[PIRUserServices sharedService] verifyBankAccount:self.bankAccount amount1:amount1 amount2:amount2 success:^{
            
            DLog(@"verify bank account success");
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView dismiss:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } error:^(NSError *error) {
            DLog(@"verify bank acocunt failure");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *errorString = NSLocalizedString(@"An error occurred. Please try again later.", nil);
                progressView.titleLabelText = errorString;
                progressView.mode = MRProgressOverlayViewModeCross;
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [progressView dismiss:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        }];
        
        /*
        [[PIRUserServices sharedService] addBankAccount:bankAccount success:^{
            
            // to-do: call web service, get accountID from server
            
            MRProgressOverlayView * progressView = [MRProgressOverlayView new];
            progressView.titleLabelText = NSLocalizedString(@"Adding Bank Account...", nil);
            progressView.mode = MRProgressOverlayViewModeIndeterminate;
            [self.view.superview addSubview:progressView];
            [progressView show:YES];
            
            DLog(@"add bank account success");
            dispatch_async(dispatch_get_main_queue(), ^{
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
         */
    }
}


@end
