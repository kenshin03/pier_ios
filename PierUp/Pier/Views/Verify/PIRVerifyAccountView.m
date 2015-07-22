//
//  PIRVerifyAccountView.m

//
//  Created by Kenny Tang on 3/15/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRVerifyAccountView.h"
#import "PIRTextFieldElementView.h"


@interface PIRVerifyAccountView()<
PIRTextFieldElementViewDelegate
>

@property (nonatomic, strong) PIRTextFieldElementView * emailView;
@property (nonatomic, strong) PIRTextFieldElementView * phoneView;
@property (nonatomic, strong) UIButton * confirmButton;

@end


@implementation PIRVerifyAccountView


#pragma mark - Public

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubviewTree];
        [self constrainViews];
    }
    return self;
}

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties

-(PIRTextFieldElementView*)emailView
{
    if (!_emailView){
        _emailView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Email Verification:", nil) keyBoardType:UIKeyboardTypeNumberPad  delagate:self];
        _emailView.validateOptions =  PIRTextFieldElementViewValidationIsInteger |
        PIRTextFieldElementViewValidationLength;
        _emailView.validateMinLength = 8;
        _emailView.validateMaxLength = 8;
        _emailView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _emailView;
}

-(PIRTextFieldElementView*)phoneView
{
    if (!_phoneView){
        _phoneView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Phone Verification:", nil) keyBoardType:UIKeyboardTypeNumberPad  delagate:self];
        _phoneView.validateOptions =  PIRTextFieldElementViewValidationIsInteger |
        PIRTextFieldElementViewValidationLength;
        
        // pass codes must be 6 chars long
        _phoneView.validateMinLength = 8;
        _phoneView.validateMaxLength = 8;
        _phoneView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _phoneView;
}

-(UIButton*)confirmButton
{
    if (!_confirmButton){
        _confirmButton = [UIButton new];
        _confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_confirmButton setTitle:NSLocalizedString(@"Verify", nil) forState:UIControlStateNormal];
        [_confirmButton setTintColor:[PIRColor defaultButtonTextColor]];
        _confirmButton.backgroundColor = [PIRColor defaultTintColor];
        _confirmButton.layer.cornerRadius = 3.0;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self addSubview:self.emailView];
    [self addSubview:self.phoneView];
    [self addSubview:self.confirmButton];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"emailView":self.emailView,
                             @"phoneView":self.phoneView,
                             @"confirmButton":self.confirmButton,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[emailView(320)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[phoneView(320)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[confirmButton]-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[emailView(44)]-[phoneView(44)]-80-[confirmButton(44)]" options:0 metrics:nil views:views]];
    
    
}

#pragma mark - Event handlers

-(void)confirmButtonTapped:(UIButton*)sender
{
    if([self.emailView validateTextField] && [self.phoneView validateTextField]) {
        NSString * emailCode = self.emailView.elementTextField.text;
        NSString * phoneCode = self.phoneView.elementTextField.text;
        [self.delegate verifyAccountView:self verifyPhone:phoneCode verifyEmail:emailCode];
    }
    
}



@end
