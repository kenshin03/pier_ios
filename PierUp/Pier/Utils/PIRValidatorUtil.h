//
//  PIRValidatorUtil.h

//
//  Created by Kenny Tang on 12/31/13.
//  Copyright (c) 2013  All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  Util class for performing validations
 */
@interface PIRValidatorUtil : NSObject

/**
 *  Check if input string is integer
 *
 *  @param string input
 *
 *  @return BOOL
 */
+ (BOOL)isInteger:(NSString*)string;

/**
 *  Check if input string is decimal
 *
 *  @param string input
 *
 *  @return BOOL
 */
+ (BOOL)isDecimal:(NSString*)string;

/**
 *  Check if input string contains only chars
 *
 *  @param string input
 *
 *  @return BOOL
 */
+ (BOOL)isString:(NSString*)string;

/**
 *  Validate if string constains a valid email
 *
 *  @param candidate email string
 *
 *  @return BOOL
 */
+ (BOOL)validateEmail:(NSString *)candidate;

+ (BOOL)validatePhone:(NSString *)candidate;

/**
 *  Validate if string is a valid SSN
 *
 *  @param candidate user input
 *
 *  @return BOOL
 */
+ (BOOL)validateSSN:(NSString *)candidate;

+ (BOOL)validateContainsZipCode:(NSString*)candidate;

+ (BOOL)validateEmptiness:(NSString *)candidate;


/**
 *  Validate if string is alpha numeric
 *
 *  @param candidate input string
 *
 *  @return BOOL
 */
+ (BOOL)validateAlphaNum:(NSString *)candidate;

/**
 *  Validate if a string is within the specified min and max lengths
 *
 *  @param candidate string input
 *  @param min       min as integer
 *  @param max       max as integer
 *
 *  @return BOOL
 */
+ (BOOL)validateLength:(NSString *)candidate min:(NSUInteger)min max:(NSUInteger)max;


/**
 *  Validate if a string contains valid status string
 *
 *  @param statusString input status string
 *
 *  @return BOOL
 */
+ (BOOL)validateUserStatus:(NSString*)statusString;


/**
 *  Validate if a string contains a valid date which is bigger than current time and within 30 days away
 *
 *  @param candidate input string date, in format of MM/dd/yyyy
 *
 *  @return BOOL
 */
+ (BOOL)validateDateFormat:(NSString *)candidate;

@end
