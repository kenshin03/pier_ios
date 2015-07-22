//
//  PIRHTTPSessionManager2.m

//
//  Created by Kenny Tang on 1/27/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRHTTPSessionManager2.h"

static NSString * const kPIERWebServiceBaseURL2 = @"http://piertransaction-env.elasticbeanstalk.com/";

@implementation PIRHTTPSessionManager2


+ (instancetype)sharedInstance {
    static PIRHTTPSessionManager2 *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PIRHTTPSessionManager2 alloc] initWithBaseURL:[NSURL URLWithString:kPIERWebServiceBaseURL2]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}

@end
