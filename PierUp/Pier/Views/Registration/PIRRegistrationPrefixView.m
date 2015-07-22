//
//  PIRRegistrationPrefixView.m

//
//  Created by Kenny Tang on 1/16/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRRegistrationPrefixView.h"
#import "PIRSeparator.h"
#import "UIImage+PIRColor.h"

@interface PIRRegistrationPrefixView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *mrsButton;
@property (nonatomic, strong) UIButton *missButton;
@property (nonatomic, strong) UIButton *mrButton;

@property (nonatomic, strong) PIRSeparator *separator;

@end

@implementation PIRRegistrationPrefixView


#pragma mark - Public

#pragma mark - Initialization

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubviewTree];
        [self constrainViews];
        [self mrButtonTapped:nil];
    }
    return self;
}

#pragma mark - Public properties

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = NSLocalizedString(@"Prefix:", nil);
        _titleLabel.font = [PIRFont userInfoTitleFont];
        _titleLabel.textColor = [PIRColor placeholderTextColor];
    }
    return _titleLabel;
}

- (UIButton*)mrButton
{
    if (!_mrButton) {
        _mrButton = [UIButton new];
        _mrButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_mrButton setTitle:NSLocalizedString(@"Mr.", nil) forState:UIControlStateNormal];
        [_mrButton setTitleColor:[PIRColor primaryTextColor] forState:UIControlStateNormal];
        [_mrButton setTitleColor:[PIRColor defaultBackgroundColor] forState:UIControlStateHighlighted];
        [_mrButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_mrButton addTarget:self action:@selector(mrButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _mrButton;
}

- (UIButton*)missButton
{
    if (!_missButton) {
        _missButton = [UIButton new];
        _missButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_missButton setTitle:NSLocalizedString(@"Ms.", nil) forState:UIControlStateNormal];
        [_missButton setTitleColor:[PIRColor primaryTextColor] forState:UIControlStateNormal];
        [_missButton setTitleColor:[PIRColor defaultBackgroundColor] forState:UIControlStateHighlighted];
        [_missButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_missButton addTarget:self action:@selector(missButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _missButton;
}

- (UIButton*)mrsButton
{
    if (!_mrsButton) {
        _mrsButton = [UIButton new];
        _mrsButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_mrsButton setTitle:NSLocalizedString(@"Mrs.", nil) forState:UIControlStateNormal];
        [_mrsButton setTitleColor:[PIRColor primaryTextColor] forState:UIControlStateNormal];
        [_mrsButton setTitleColor:[PIRColor defaultBackgroundColor] forState:UIControlStateHighlighted];
        [_mrsButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_mrsButton addTarget:self action:@selector(mrsButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _mrsButton;
}

- (PIRSeparator*)separator
{
    if (!_separator) {
        _separator = [PIRSeparator new];
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _separator;
}

#pragma mark - Private

#pragma mark - Private properties

#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.mrButton];
    [self addSubview:self.mrsButton];
    [self addSubview:self.missButton];
    [self addSubview:self.separator];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"titleLabel":self.titleLabel,
                             @"mrsButton":self.mrsButton,
                             @"missButton":self.missButton,
                             @"mrButton":self.mrButton,
                             @"separator":self.separator,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[separator]-5-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel(100)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[mrButton(60)]-[mrsButton(60)]-[missButton(60)]-(5)-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mrsButton]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[missButton]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mrButton]-[separator(1)]|" options:0 metrics:nil views:views]];
}


#pragma mark - Event handlers

-(void)mrButtonTapped:(id)sender
{
    self.mrButton.backgroundColor = [PIRColor highlightedButtonColor];
    self.mrsButton.backgroundColor = [PIRColor defaultBackgroundColor];
    self.missButton.backgroundColor = [PIRColor defaultBackgroundColor];
}

-(void)mrsButtonTapped:(id)sender
{
    self.mrButton.backgroundColor = [PIRColor defaultBackgroundColor];
    self.mrsButton.backgroundColor = [PIRColor highlightedButtonColor];
    self.missButton.backgroundColor = [PIRColor defaultBackgroundColor];
}

-(void)missButtonTapped:(id)sender
{
    self.mrButton.backgroundColor = [PIRColor defaultBackgroundColor];
    self.mrsButton.backgroundColor = [PIRColor defaultBackgroundColor];
    self.missButton.backgroundColor = [PIRColor highlightedButtonColor];
}


@end
