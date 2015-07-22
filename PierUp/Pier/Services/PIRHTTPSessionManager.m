//
//  PIRHTTPSessionManager.m

//
//  Created by Kenny Tang on 12/29/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRHTTPSessionManager.h"

static NSString * const kPIERWebServiceBaseURL = @"http://elasticbeanstalk.com/";

@implementation PIRHTTPSessionManager

+ (instancetype)sharedInstance {
    static PIRHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PIRHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kPIERWebServiceBaseURL]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}

@end
