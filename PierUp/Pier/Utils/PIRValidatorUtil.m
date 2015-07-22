//
//  PIRValidatorUtil.m

//
//  Created by Kenny Tang on 12/31/13.
//  Copyright (c) 2013  All rights reserved.
//

#import "PIRValidatorUtil.h"
#import "PIRUser+Extensions.h"

@implementation PIRValidatorUtil

#pragma mark - Public

#pragma mark - Public Methods

+ (BOOL)isInteger:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isDecimal:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isString:(NSString*)candidate
{
    NSString * stringRegex = @"^[A-Za-z]*$";
    NSPredicate * stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:candidate];
}

+ (BOOL)validateAlphaNum:(NSString *)candidate
{
    NSString * stringRegex = @"^[a-zA-Z0-9_-]*$";
    NSPredicate * stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:candidate];
}

+ (BOOL)validateSSN:(NSString *)candidate
{
    // to-do: implement later
    // http://www.raywenderlich.com/30288/nsregularexpression-tutorial-and-cheat-sheet
    return YES;
}

+ (BOOL)validateContainsZipCode:(NSString*)candidate
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z]{2}\\s+[0-9]{5}(-[0-9]{4})?$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:candidate
                                      options:0
                                        range:NSMakeRange(0, [candidate length])];
    
    return ([matches count] > 0);
}


+ (BOOL)validateEmptiness:(NSString *)candidate
{
    return ([candidate length]?YES:NO);
}

+ (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)validatePhone:(NSString *)candidate
{
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [candidate length]);
    NSArray *matches = [detector matchesInString:candidate options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}

+ (BOOL)validateDateFormat:(NSString *)candidate
{
    BOOL isDateValidated = NO;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm";
    NSDate * validateDate = [dateFormatter dateFromString:candidate];
    if (!validateDate){
        return isDateValidated;
    }
    // date must be greater than now and less than one month away
    if ([PIRValidatorUtil validateDateIsBiggerThanCurrentDate:validateDate] &&
        [PIRValidatorUtil validateDateIsSmallerThanOneMonthAway:validateDate]){
        isDateValidated = YES;
    }
    return isDateValidated;
}

+ (BOOL)validateLength:(NSString *)candidate min:(NSUInteger)min max:(NSUInteger)max
{
    return (([candidate length]>=min)&&([candidate length]<=max));
}

+ (BOOL)validateUserStatus:(NSString*)statusString
{
    NSInteger status = [statusString integerValue];
    return ((status==PIRUserStatusActive)||(status==PIRUserStatusInactive)||(status==PIRUserStatusLocked));
}

+ (BOOL)validateDateIsBiggerThanCurrentDate:(NSDate*)validateDate
{
    BOOL isDateInFuture;
    NSTimeInterval diffFromNow = [validateDate timeIntervalSinceNow];
    if (diffFromNow < 0){
        isDateInFuture = NO;
    }else{
        isDateInFuture = YES;
    }
    return isDateInFuture;
}

+ (BOOL)validateDateIsSmallerThanOneMonthAway:(NSDate*)validateDate
{
    BOOL isWithinMonth;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [NSDateComponents new];
    [offsetComponents setDay:30];
    NSDate *thirtyDaysDate = [calendar dateByAddingComponents:offsetComponents toDate:[NSDate new] options:0];
    
    
    NSTimeInterval diffFromThirtyDays = [validateDate timeIntervalSinceDate:thirtyDaysDate];
    if (diffFromThirtyDays > 0){
        isWithinMonth = NO;
    }else{
        isWithinMonth = YES;
    }
    return isWithinMonth;
}

@end
