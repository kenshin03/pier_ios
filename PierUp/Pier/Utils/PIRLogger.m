//
//  PIRLogger.m

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRLogger.h"

static BOOL const  kDefaultMethodNameDisplay = YES;
static NSInteger currentLogLevel;

// Logging Descriptions
static NSString * const kPIRLogLevelUndefined = @"Undefined";
static NSString * const kPIRLogLevelVerbose = @"Verbose";
static NSString * const kPIRLogLevelDebug = @"Debug";
static NSString * const kPIRLogLevelInfo = @"Info";
static NSString * const kPIRLogLevelWarn = @"Warn";
static NSString * const kPIRLogLevelError = @"Error";


@implementation PIRLogger


+(BOOL) logLevel:(NSInteger) level file:(char*)sourceFile methodName:(NSString *) methodName lineNumber:(int)lineNumber format:(NSString*)format, ...; {
    BOOL success = NO;
    
#if DEBUG
    currentLogLevel = 2; // debug
#else
    currentLogLevel = 5; // error
#endif
    
    if (level >= currentLogLevel) {
        va_list ap;
        va_start(ap,format);
        NSString * fileName = [[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding];
        NSString * printString = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        NSString * displayMethodName = (kDefaultMethodNameDisplay) ? methodName : @"";
        NSString * logString = [NSString stringWithFormat:@"[%s:%@:%d] %@: %@",[[fileName lastPathComponent] UTF8String],
                                displayMethodName, lineNumber, [[self class] logDescriptionBasedOnLogLevel:level], printString];
        success = [[self class] logOutputString:logString];
    }
    return success;
}

+(BOOL) logOutputString:(NSString *) logString {
    NSLog(@"%@", logString);
    return YES;
}

+(NSString *) logDescriptionBasedOnLogLevel:(PIRLogLevel) level {
    NSString * description = kPIRLogLevelUndefined;
    switch (level) {
        case PIRLogLevelVerbose:
            description = kPIRLogLevelVerbose;
            break;
        case PIRLogLevelDebug:
            description = kPIRLogLevelDebug;
            break;
        case PIRLogLevelInfo:
            description = kPIRLogLevelInfo;
            break;
        case PIRLogLevelWarning:
            description = kPIRLogLevelWarn;
            break;
        case PIRLogLevelError:
            description = kPIRLogLevelError;
            break;
        default:
            description = kPIRLogLevelUndefined;
            break;
    }
    return description;
}



@end
