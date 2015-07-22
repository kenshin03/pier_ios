//
//  PIRSendPaymentNearbyUsersCell.m

//
//  Created by Kenny Tang on 12/13/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRSendPaymentNearbyUsersCell.h"
#import "PIRAvatar.h"

@interface PIRSendPaymentNearbyUsersCell()

@property (nonatomic, strong) PIRAvatar * avatar;
@property (nonatomic, strong) UILabel * nameLabel;

@end

@implementation PIRSendPaymentNearbyUsersCell

#pragma mark - Public

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.translatesAutoresizingMaskIntoConstraints = NO;
        // Initialization code
        [self addSubviewTree];
        [self constrainViews];
    }
    return self;
}


#pragma mark - Initialization

#pragma mark - Public properties

- (void)setUser:(PIRUser *)user
{
    _user = user;
    [self updateViewsWithUser:user];
}

#pragma mark - Private

#pragma mark - Private properties

- (PIRAvatar*)avatar
{
    if (!_avatar) {
        _avatar = [PIRAvatar new];
        _avatar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _avatar;
}


- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.font = [PIRFont avatarNameFont];
        _nameLabel.textColor = [PIRColor primaryTextColor];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.nameLabel];
}

- (void)updateViewsWithUser:(PIRUser*)user
{
    self.avatar.user = user;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"avatar":self.avatar,
                             @"nameLabel":self.nameLabel,
                             @"contentView":self.contentView,
                             
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[contentView]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[avatar]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel]"
//                                                                             options:0
//                                                                             metrics:nil
//                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[avatar(60)]-50-[nameLabel]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.avatar attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0 constant:10.0]];
    
    
}

#pragma mark - Event handlers




@end
