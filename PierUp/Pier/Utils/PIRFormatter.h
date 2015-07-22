//
//  PIRFormatter.h

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIRFormatter : NSObject

/**
 *  Convert timestamp object to formatted string
 *
 *  @param time unix time stamp
 *
 *  @return NSString
 */
+ (NSString *)timestampStringFromTimestamp:(NSTimeInterval)time;

@end
