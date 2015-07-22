//
//  PIRHTTPSessionManager.h

//
//  Created by Kenny Tang on 12/29/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "AFHTTPSessionManager.h"

/**
 *  Wrapper class for AFNetworking's AFHTTPSessionManager
 */
@interface PIRHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@end
