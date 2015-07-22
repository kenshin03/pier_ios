//
//  PIRColor.m

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#define PIRCOLORALPHA(name, hexValue, alphaValue) \
+ (UIColor *)name {\
return [self colorFromHex:hexValue alpha:alphaValue];\
}

#define PIRCOLOR(name, hex) PIRCOLORALPHA(name, hex, 1.0)

#define PIRCOLORALIAS(alias, paletteName)\
+ (UIColor *)alias {\
return [self paletteName];\
}

#import "PIRColor.h"

@implementation PIRColor

#pragma mark - Palette

#pragma mark - Indicator shades

PIRCOLOR(primaryTextColor, @"000000");
PIRCOLOR(secondaryTextColor, @"b0b0b0");
PIRCOLOR(defaultTintColor, @"76cdad");

PIRCOLOR(highlightedButtonColor, @"74CEAB");

PIRCOLOR(profileMenuColor, @"7ACEAB");
PIRCOLOR(profileOptionsButtonTextNormalColor, @"E1E3E2");

PIRCOLOR(defaultBackgroundColor, @"ffffff");
PIRCOLOR(defaultButtonTextColor, @"ffffff");


PIRCOLOR(separatorColor, @"DCDCDC");

PIRCOLORALIAS(placeholderTextColor, secondaryTextColor);

PIRCOLOR(navigationBarTitleColor, @"ffffff");
PIRCOLOR(navigationBarButtonItemsTitleColor, @"ffffff");

PIRCOLORALIAS(navigationBarBackgroundColor, defaultTintColor);

PIRCOLOR(alertViewContentBackgroundColor, @"ffffff");

PIRCOLOR(textFieldFailedValidationColor, @"ff0000");

#pragma mark - Private

+ (UIColor *)colorFromHex:(NSString *)hexValue alpha:(CGFloat)alpha
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexValue];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:alpha];
}

@end
