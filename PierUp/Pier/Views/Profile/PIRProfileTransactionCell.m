//
//  PIRProfileTransactionCell.m

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileTransactionCell.h"

@interface PIRProfileTransactionCell()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *fromUserLabel;
@property (nonatomic, strong) UILabel *actionLabel;
@property (nonatomic, strong) UILabel *toUserLabel;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation PIRProfileTransactionCell

#pragma mark - Public

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.frame = CGRectMake(0, 0, 320.0, 120.0);
        [self addSubviewTree];
        [self constrainViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public properties

- (UIView*)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIView*)centerView
{
    if (!_centerView) {
        _centerView = [UIView new];
        _centerView.translatesAutoresizingMaskIntoConstraints = NO;
        _centerView.backgroundColor = [UIColor clearColor];
    }
    return _centerView;
}

- (UIView*)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UILabel*)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _amountLabel.font = [PIRFont paymentAmountsLabelFont];
        _amountLabel.textAlignment = NSTextAlignmentLeft;
        _amountLabel.textColor = [PIRColor secondaryTextColor];
        _amountLabel.text = @"100.0";
    }
    return _amountLabel;
}

- (UILabel*)fromUserLabel
{
    if (!_fromUserLabel) {
        _fromUserLabel = [UILabel new];
        _fromUserLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _fromUserLabel.font = [PIRFont profileInfoTableViewTransactionLabelFont];
        _fromUserLabel.textAlignment = NSTextAlignmentRight;
        _fromUserLabel.textColor = [PIRColor primaryTextColor];
        _fromUserLabel.text = @"mmmm";
    }
    return _fromUserLabel;
}

- (UILabel*)toUserLabel
{
    if (!_toUserLabel) {
        _toUserLabel = [UILabel new];
        _toUserLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _toUserLabel.font = [PIRFont profileInfoTableViewTransactionLabelFont];
        _toUserLabel.textAlignment = NSTextAlignmentRight;
        _toUserLabel.textColor = [PIRColor primaryTextColor];
        _toUserLabel.text = @"tttt";
    }
    return _toUserLabel;
}

- (UILabel*)actionLabel
{
    if (!_actionLabel) {
        _actionLabel = [UILabel new];
        _actionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _actionLabel.text = NSLocalizedString(@"To", nil);
        _actionLabel.font = [PIRFont profileInfoTableViewTransactionLabelFont];
        _actionLabel.textAlignment = NSTextAlignmentRight;
        _actionLabel.textColor = [PIRColor primaryTextColor];
    }
    return _actionLabel;
}

- (UILabel*)timestampLabel
{
    if (!_timestampLabel) {
        _timestampLabel = [UILabel new];
        _timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timestampLabel.font = [PIRFont profileInfoTableViewTimetsampLabelFont];
        _timestampLabel.textAlignment = NSTextAlignmentRight;
        _timestampLabel.textColor = [PIRColor primaryTextColor];
    }
    return _timestampLabel;
}

-(UILabel*)statusLabel
{
    if (!_statusLabel){
        _statusLabel = [UILabel new];
        _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _statusLabel.font = [PIRFont profileInfoTableViewTimetsampLabelFont];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.textColor = [PIRColor primaryTextColor];
    }
    return _statusLabel;
}

#pragma mark - Private

#pragma mark - Private properties

#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self.topView addSubview:self.amountLabel];
    [self.centerView addSubview:self.fromUserLabel];
    [self.centerView addSubview:self.actionLabel];
    [self.centerView addSubview:self.toUserLabel];
    [self.bottomView addSubview:self.timestampLabel];
    [self.bottomView addSubview:self.statusLabel];
    
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.centerView];
    [self.contentView addSubview:self.bottomView];
    [self addSubview:self.contentView];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"topView":self.topView,
                             @"centerView":self.centerView,
                             @"bottomView":self.bottomView,
                             @"amountLabel":self.amountLabel,
                             @"fromUserLabel":self.fromUserLabel,
                             @"actionLabel":self.actionLabel,
                             @"toUserLabel":self.toUserLabel,
                             @"timestampLabel":self.timestampLabel,
                             @"statusLabel":self.statusLabel,
                             };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[topView]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[centerView]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[bottomView]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-10-[topView(60)][centerView(20)][bottomView(20)]|" options:0 metrics:nil views:views]];
    
    
    [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                  @"H:|[amountLabel(300)]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]
     ];
    [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|[amountLabel]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
    [self.centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"H:|[fromUserLabel]-20-[actionLabel]-20-[toUserLabel]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]
     ];
    
    [self.centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                  @"V:|[fromUserLabel(20)]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]
     ];
    [self.centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"V:|[actionLabel(20)]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]
     ];
    [self.centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"V:|[toUserLabel(20)]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]
     ];
    [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                  @"H:[timestampLabel]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]
     ];
    [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                  @"V:[timestampLabel(20)]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]
     ];
    [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"H:|[statusLabel]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]
     ];
    [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"V:|[statusLabel(20)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]
     ];

    
}


@end
