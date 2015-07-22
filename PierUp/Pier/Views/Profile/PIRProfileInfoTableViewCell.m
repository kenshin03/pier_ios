//
//  PIRProfileInfoTableViewCell.m

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileInfoTableViewCell.h"

@interface PIRProfileInfoTableViewCell()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * valueLabel;

@end


@implementation PIRProfileInfoTableViewCell

#pragma mark - Public

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviewTree];
        [self constrainViews];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

#pragma mark - Public properties

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [PIRFont profileInfoTableViewTitleLabelFont];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [PIRColor secondaryTextColor];
    }
    return _titleLabel;
}

- (UILabel*)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel.font = [PIRFont profileInfoTableViewValueLabelFont];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.textColor = [PIRColor primaryTextColor];
        
    }
    return _valueLabel;
}


#pragma mark - Private

#pragma mark - Private properties

#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueLabel];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"titleLabel":self.titleLabel,
                             @"valueLabel":self.valueLabel,
                             @"contentView":self.contentView
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[contentView(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|[contentView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[titleLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:[valueLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:[titleLabel][valueLabel]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|[titleLabel]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|[valueLabel]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
}


@end
