//
//  PIRLogger.h

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013  All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLog(s,...) [PIRLogger logLevel:PIRLogLevelVerbose file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define DLog(s,...) [PIRLogger logLevel:PIRLogLevelDebug file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define ILog(s,...) [PIRLogger logLevel:PIRLogLevelInfo file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define WLog(s,...) [PIRLogger logLevel:PIRLogLevelWarning file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define ELog(s,...) [PIRLogger logLevel:PIRLogLevelError file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]

typedef  NS_ENUM(NSInteger, PIRLogLevel){
    PIRLogLevelUndefined = 0,
    PIRLogLevelVerbose,
    PIRLogLevelDebug,
    PIRLogLevelInfo,
    PIRLogLevelWarning,
    PIRLogLevelError
} ;


@interface PIRLogger : NSObject

+(BOOL) logLevel:(NSInteger) level file:(char*)sourceFile methodName:(NSString *) methodName lineNumber:(int)lineNumber format:(NSString*)format, ...;

@end
