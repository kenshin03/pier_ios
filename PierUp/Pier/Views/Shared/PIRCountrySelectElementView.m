//
//  PIRCountrySelectElementView.m

//
//  Created by Kenny Tang on 3/10/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRCountrySelectElementView.h"
#import "PIRSeparator.h"
#import "UIImage+PIRColor.h"

@interface PIRCountrySelectElementView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *usButton;
@property (nonatomic, strong) UIButton *cnButton;
@property (nonatomic, strong) PIRSeparator *separator;

@end


@implementation PIRCountrySelectElementView


#pragma mark - Public

#pragma mark - Initialization

- (instancetype) initWithTitle:(NSString*)title delegate:(id<PIRCountrySelectElementViewDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = title;
        self.delegate = delegate;
        [self addSubviewTree];
        [self constrainViews];
        self.usButton.backgroundColor = [PIRColor highlightedButtonColor];
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

- (UIButton*)usButton
{
    if (!_usButton) {
        _usButton = [UIButton new];
        _usButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_usButton setTitle:NSLocalizedString(@"US", nil) forState:UIControlStateNormal];
        [_usButton setTitleColor:[PIRColor primaryTextColor] forState:UIControlStateNormal];
        [_usButton setTitleColor:[PIRColor defaultBackgroundColor] forState:UIControlStateHighlighted];
        [_usButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_usButton addTarget:self action:@selector(usButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _usButton;
}

- (UIButton*)cnButton
{
    if (!_cnButton) {
        _cnButton = [UIButton new];
        _cnButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cnButton setTitle:NSLocalizedString(@"CN", nil) forState:UIControlStateNormal];
        [_cnButton setTitleColor:[PIRColor primaryTextColor] forState:UIControlStateNormal];
        [_cnButton setTitleColor:[PIRColor defaultBackgroundColor] forState:UIControlStateHighlighted];
        [_cnButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_cnButton addTarget:self action:@selector(cnButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _cnButton;
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
    [self addSubview:self.usButton];
    [self addSubview:self.cnButton];
    [self addSubview:self.separator];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"titleLabel":self.titleLabel,
                             @"usButton":self.usButton,
                             @"cnButton":self.cnButton,
                             @"separator":self.separator,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[separator]-5-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel(100)]-[usButton(80)]-[cnButton(80)]" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[usButton]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cnButton]-[separator(1)]|" options:0 metrics:nil views:views]];
}


#pragma mark - Event handlers

-(void)usButtonTapped:(id)sender
{
    self.usButton.backgroundColor = [PIRColor highlightedButtonColor];
    self.cnButton.backgroundColor = [PIRColor defaultBackgroundColor];
    [self.delegate countrySelectView:self usButtonTapped:YES];
}

-(void)cnButtonTapped:(id)sender
{
    self.usButton.backgroundColor = [PIRColor defaultBackgroundColor];
    self.cnButton.backgroundColor = [PIRColor highlightedButtonColor];
    [self.delegate countrySelectView:self cnButtonTapped:YES];
}

@end