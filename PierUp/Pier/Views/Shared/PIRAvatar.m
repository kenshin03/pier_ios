//
//  PIRAvatar.m

//
//  Created by Kenny Tang on 12/14/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRAvatar.h"

@interface PIRAvatar()

@property (nonatomic, strong) UIImageView * avatarImageView;

@end

@implementation PIRAvatar

#pragma mark - Public

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0.0f, 0.0f, 80.0, 80.0)];
    self.avatarImageView.frame = self.frame;
    [self addSubview:self.avatarImageView];
    return self;
}

- (void)setUser:(PIRUser *)user
{
    _user = user;
    [self updateViewWithUser:user];
}

- (void)setUserImage:(UIImage *)userImage
{
    _userImage = userImage;
    [self updateViewWithImage:userImage];
}

#pragma mark - Private

#pragma mark - Private properties

-(UIImageView*)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.layer.cornerRadius = self.frame.size.height/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"FriendsGenericProfilePic"];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

#pragma mark - Initialization helpers

- (void)updateViewWithImage:(UIImage*)userImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.avatarImageView.image = userImage;
        });
    });
    
}

- (void)updateViewWithUser:(PIRUser*)user
{
    if (user.thumbnailImage) {
        
        self.avatarImageView.image = user.thumbnailImage;
        
    }else if ([user.thumbnailURL length]) {
        
        NSString * thumbURLString = user.thumbnailURL;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL * thumbURL = [NSURL URLWithString:thumbURLString];
            UIImage * avatarImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:thumbURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarImageView.image = avatarImage;
            });
        });
    }
    
}


@end
