//
//  PIRSwitchFieldElementView.m

//
//  Created by Kenny Tang on 2/7/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRSwitchFieldElementView.h"
#import "PIRSeparator.h"

@interface PIRSwitchFieldElementView()

@property (nonatomic, weak) id<PIRSwitchFieldElementViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *titleValue;
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) PIRSeparator *separator;

@end

@implementation PIRSwitchFieldElementView

#pragma mark - Public

#pragma mark - Initialization

- (instancetype) initSwitchFieldElementViewWith:(NSString *)titleValue
                                       delagate:(id<PIRSwitchFieldElementViewDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _titleValue = titleValue;
        _delegate = delegate;
        [self addSubviewTree];
        [self constrainViews];
        
    }
    return self;
}

#pragma mark - Private

#pragma mark - Private properties

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = self.titleValue;
        _titleLabel.font = [PIRFont userInfoTitleFont];
        _titleLabel.textColor = [PIRColor placeholderTextColor];
    }
    return _titleLabel;
}


- (UISwitch*)switchControl
{
    if (!_switchControl) {
        _switchControl = [UISwitch new];
        _switchControl.translatesAutoresizingMaskIntoConstraints = NO;
        _switchControl.on = YES;
        _switchControl.tintColor = [PIRColor defaultTintColor];
        [_switchControl addTarget:self action:@selector(switchControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

- (PIRSeparator*)separator
{
    if (!_separator) {
        _separator = [PIRSeparator new];
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _separator;
}

-(CGSize)intrinsicContentSize
{
    return CGSizeMake(320.0, 44.0);
}

#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.switchControl];
    [self addSubview:self.separator];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"titleLabel":self.titleLabel,
                             @"switchControl":self.switchControl,
                             @"separator":self.separator,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[separator]-5-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[switchControl]-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[switchControl]-[separator(1)]|" options:0 metrics:nil views:views]];
}



#pragma mark - Event handlers

-(void)switchControlChanged:(UISwitch*)sender
{
    [self.delegate switchFieldElementView:self switchValueChanged:sender.on];
}

@end
