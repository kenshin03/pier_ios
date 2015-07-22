//
//  PIRWebServices.m

//
//  Created by Kenny Tang on 2/5/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRWebServices.h"
#import "PIRAccessTokens.h"
#import "PIRDeviceTokens.h"
#import "PIRUser.h"
#import "PIRUserServices.h"

@implementation PIRWebServices

#pragma mark - Public

#pragma mark - Public methods

-(NSDictionary*)requestTokens
{
    PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
    NSDictionary * params = @{
                              @"platform":@"API",
                              @"accessToken":currentUser.accessTokens.accessToken?currentUser.accessTokens.accessToken:@"",
                              @"access_token":currentUser.accessTokens.accessToken?currentUser.accessTokens.accessToken:@"",
                              @"token":currentUser.accessTokens.accessToken?currentUser.accessTokens.accessToken:@"",
                              @"device_token":currentUser.deviceTokens.deviceToken?currentUser.deviceTokens.deviceToken:@"",
                              @"deviceToken":currentUser.deviceTokens.deviceToken?currentUser.deviceTokens.deviceToken:@""
                              };
    return params;
}

#pragma mark - Private

#pragma mark - Private properties


@end
