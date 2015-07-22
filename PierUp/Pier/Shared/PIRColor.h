//
//  PIRColor.h

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIRColor : NSObject

#pragma mark - Default colors

+ (UIColor *)primaryTextColor;
+ (UIColor *)secondaryTextColor;
+ (UIColor *)placeholderTextColor;
+ (UIColor *)defaultTintColor;
+ (UIColor *)defaultBackgroundColor;
+ (UIColor *)highlightedButtonColor;

+ (UIColor *)profileMenuColor;


+ (UIColor *)profileOptionsButtonTextNormalColor;

+ (UIColor *)navigationBarTitleColor;
+ (UIColor *)navigationBarButtonItemsTitleColor;
+ (UIColor *)navigationBarBackgroundColor;
+ (UIColor *)separatorColor;

+ (UIColor *)alertViewContentBackgroundColor;

+ (UIColor *)defaultButtonTextColor;

+ (UIColor *)textFieldFailedValidationColor;

@end


