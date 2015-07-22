//
//  PIRRegisterView.m

//
//  Created by Kenny Tang on 2/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRRegisterView.h"
#import "PIRSeparator.h"

@interface PIRRegisterView()

@property (nonatomic, strong) UIButton *signUpWithFBButton;
@property (nonatomic, strong) UIButton *signUpWithTencentButton;
@property (nonatomic, strong) UIButton *signUpWithSinaButton;
@property (nonatomic, strong) UIButton *signUpButton;

@end

@implementation PIRRegisterView

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

- (UIButton *)signUpWithFBButton
{
    if(!_signUpWithFBButton)
    {
        _signUpWithFBButton =  [UIButton new];
        _signUpWithFBButton.enabled = NO;
        _signUpWithFBButton.translatesAutoresizingMaskIntoConstraints = NO;
        _signUpWithFBButton.titleLabel.font = [PIRFont loginButtonTitleFont];
        [_signUpWithFBButton setTitle:NSLocalizedString(@"Sign up with Facebook", nil) forState:UIControlStateNormal];
        [_signUpWithFBButton setTitleColor:[PIRColor placeholderTextColor] forState:UIControlStateNormal];
        [_signUpWithFBButton setBackgroundColor:[UIColor clearColor]];
        [_signUpWithFBButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateHighlighted];
        [_signUpWithFBButton addTarget:self action:@selector(signUpWithFBButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpWithFBButton;
}

- (UIButton *)signUpWithTencentButton
{
    if(!_signUpWithTencentButton)
    {
        _signUpWithTencentButton =  [UIButton new];
        _signUpWithTencentButton.enabled = NO;
        _signUpWithTencentButton.translatesAutoresizingMaskIntoConstraints = NO;
        _signUpWithTencentButton.titleLabel.font = [PIRFont loginButtonTitleFont];
        [_signUpWithTencentButton setTitle:NSLocalizedString(@"Sign up with Tencent Weibo", nil) forState:UIControlStateNormal];
        [_signUpWithTencentButton setTitleColor:[PIRColor placeholderTextColor] forState:UIControlStateNormal];
        [_signUpWithTencentButton setBackgroundColor:[UIColor clearColor]];
        [_signUpWithTencentButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateHighlighted];
        [_signUpWithTencentButton addTarget:self action:@selector(signUpWithTencentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpWithTencentButton;
}


- (UIButton *)signUpWithSinaButton
{
    if(!_signUpWithSinaButton)
    {
        _signUpWithSinaButton =  [UIButton new];
        _signUpWithSinaButton.enabled = NO;
        _signUpWithSinaButton.translatesAutoresizingMaskIntoConstraints = NO;
        _signUpWithSinaButton.titleLabel.font = [PIRFont loginButtonTitleFont];
        [_signUpWithSinaButton setTitle:NSLocalizedString(@"Sign up with Sina Weibo", nil) forState:UIControlStateNormal];
        [_signUpWithSinaButton setTitleColor:[PIRColor placeholderTextColor] forState:UIControlStateNormal];
        [_signUpWithSinaButton setBackgroundColor:[UIColor clearColor]];
        [_signUpWithSinaButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateHighlighted];
        [_signUpWithSinaButton addTarget:self action:@selector(signUpWithSinaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpWithSinaButton;
}

- (UIButton *)signUpButton
{
    if(!_signUpButton)
    {
        _signUpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _signUpButton.translatesAutoresizingMaskIntoConstraints = NO;
        _signUpButton.titleLabel.font = [PIRFont loginButtonTitleFont];
        [_signUpButton setTitle:NSLocalizedString(@"Sign up with Email", nil) forState:UIControlStateNormal];
        [_signUpButton setTitleColor:[PIRColor placeholderTextColor] forState:UIControlStateNormal];
        [_signUpButton setBackgroundColor:[UIColor clearColor]];
        [_signUpButton setTitleColor:[PIRColor primaryTextColor] forState:UIControlStateNormal];
        [_signUpButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateHighlighted];
        [_signUpButton addTarget:self action:@selector(signUpWithEmailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _signUpButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _signUpButton.layer.borderWidth = 0.5;
        [_signUpButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_signUpButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        
    }
    return _signUpButton;
}

#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self addSubview:self.signUpWithFBButton];
    [self addSubview:self.signUpWithTencentButton];
    [self addSubview:self.signUpWithSinaButton];
    [self addSubview:self.signUpButton];
}

- (void)constrainViews
{
    
    NSDictionary * views = @{
                             @"signUpWithFBButton":self.signUpWithFBButton,
                             @"signUpWithTencentButton":self.signUpWithTencentButton,
                             @"signUpWithSinaButton":self.signUpWithSinaButton,
                             @"signUpButton":self.signUpButton,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[signUpWithFBButton(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[signUpWithTencentButton(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[signUpWithSinaButton(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[signUpButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[signUpWithFBButton(44)]-[signUpWithTencentButton(44)]-[signUpWithSinaButton(44)]-20-[signUpButton(44)]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}


#pragma mark - Event handlers

- (void)signUpWithFBButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(registerView:didRegisterWithFacebook:)]){
        [self.delegate registerView:self didRegisterWithFacebook:YES];
    }
}

- (void)signUpWithSinaButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(registerView:didRegisterWithSina:)]){
        [self.delegate registerView:self didRegisterWithSina:YES];
    }
}

- (void)signUpWithTencentButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(registerView:didRegisterWithTencent:)]){
        [self.delegate registerView:self didRegisterWithTencent:YES];
    }
}


- (void)signUpWithEmailButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(registerView:didRegisterWithEmail:)]){
        [self.delegate registerView:self didRegisterWithEmail:YES];
    }
}


@end
