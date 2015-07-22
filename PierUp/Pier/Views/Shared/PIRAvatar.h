//
//  PIRAvatar.h

//
//  Created by Kenny Tang on 12/14/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIRUser+Extensions.h"

@interface PIRAvatar : UIView

@property (nonatomic, strong) PIRUser *user;
@property (nonatomic, strong) UIImage *userImage;

@end
