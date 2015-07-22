//
//  PIRSocialAccount+Extensions.h

//
//  Created by Kenny Tang on 1/6/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRSocialAccount.h"

typedef NS_ENUM(NSUInteger, PIRSocialAccountStatus)
{
    PIRSocialAccountStatusInActive = 0,
    PIRSocialAccountStatusActive = 1
};

typedef NS_ENUM(NSUInteger, PIRSocialAccountType)
{
    PIRSocialAccountTypeFacebook = 0,
    PIRSocialAccountTypeSina = 1,
    PIRSocialAccountTypeTencent = 2,
};

@interface PIRSocialAccount (Extensions)

@end
