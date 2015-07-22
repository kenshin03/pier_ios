//
//  PIRLoginView.m

//
//  Created by Kenny Tang on 2/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRLoginView.h"
#import "PIRTextFieldElementView.h"


@interface PIRLoginView()<
PIRTextFieldElementViewDelegate
>

@property (nonatomic, strong) PIRTextFieldElementView * userNameView;
@property (nonatomic, strong) PIRTextFieldElementView * passcodeView;
@property (nonatomic, strong) UIButton * confirmButton;

@end

@implementation PIRLoginView


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

-(void)setCurrentUser:(PIRUser *)currentUser
{
    _currentUser = currentUser;
    if (currentUser){
        self.userNameView.elementTextField.text = currentUser.userName;
    }
}

#pragma mark - Private

#pragma mark - Private properties

-(PIRTextFieldElementView*)userNameView
{
    if (!_userNameView){
        _userNameView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Username:", nil) keyBoardType:UIKeyboardTypeDefault  delagate:self];
        _userNameView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsAlphaNum |
        PIRTextFieldElementViewValidationLength;
        _userNameView.validateMinLength = 1;
        _userNameView.validateMaxLength = 20;
        _userNameView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _userNameView;
}

-(PIRTextFieldElementView*)passcodeView
{
    if (!_passcodeView){
        _passcodeView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Passcode:", nil) keyBoardType:UIKeyboardTypeNumberPad  delagate:self];
        _passcodeView.validateOptions = PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsInteger |
        PIRTextFieldElementViewValidationLength;
        
        // pass codes must be 6 chars long
        _passcodeView.validateMinLength = 6;
        _passcodeView.validateMaxLength = 6;
        _passcodeView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _passcodeView;
}

-(UIButton*)confirmButton
{
    if (!_confirmButton){
        _confirmButton = [UIButton new];
        _confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_confirmButton setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
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
    [self addSubview:self.userNameView];
    [self addSubview:self.passcodeView];
    [self addSubview:self.confirmButton];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"userNameView":self.userNameView,
                             @"passcodeView":self.passcodeView,
                             @"confirmButton":self.confirmButton,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userNameView(320)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[passcodeView(320)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[confirmButton]-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[userNameView(44)]-[passcodeView(44)]-80-[confirmButton(44)]" options:0 metrics:nil views:views]];
    
    
}

#pragma mark - Event handlers

-(void)confirmButtonTapped:(UIButton*)sender
{
    if([self.userNameView validateTextField] && [self.passcodeView validateTextField]) {
        NSString * userName = self.userNameView.elementTextField.text;
        NSString * passcode = self.passcodeView.elementTextField.text;
        [self loginUser:userName passcode:passcode];
        
    }
}

#pragma mark - confirm button helpers

- (void)loginUser:(NSString*)userName passcode:(NSString*)passcode
{
    [self.delegate loginView:self didSignIn:userName passcode:passcode];
}


#pragma mark - PIRTextFieldElementViewDelegate methods

@end
