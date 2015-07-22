//
//  PIRFont.m

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRFont.h"

@implementation PIRFont

#pragma mark - Shared

+ (UIFont *)navigationBarTitleFont
{
    static UIFont *sNavigationBarTitleFont;
    return [self fontWithCache:sNavigationBarTitleFont
                          name:@"HelveticaNeue-Light"
                          size:18.0];
}

+ (UIFont *)statusLabelFont
{
    static UIFont *sStatusLabelFont;
    return [self fontWithCache:sStatusLabelFont
                          name:@"HelveticaNeue-Light"
                          size:18.0];
}

+ (UIFont *)loginTitleFont
{
    static UIFont *sLoginTitleFont;
    return [self fontWithCache:sLoginTitleFont
                          name:@"HelveticaNeue-Light"
                          size:36.0];

}

+ (UIFont *)loginButtonTitleFont
{
    static UIFont *sLoginButtonTitleFont;
    return [self fontWithCache:sLoginButtonTitleFont
                          name:@"HelveticaNeue-Light"
                          size:18.0];
}

+ (UIFont *)paymentAmountsSmallLabelFont
{
    static UIFont *spaymentAmountsSmallLabelFont;
    return [self fontWithCache:spaymentAmountsSmallLabelFont
                          name:@"HelveticaNeue-Light"
                          size:32.0];
}

+ (UIFont *)paymentAmountsMediumLabelFont
{
    static UIFont *sPaymentAmountsMediumLabelFont;
    return [self fontWithCache:sPaymentAmountsMediumLabelFont
                          name:@"HelveticaNeue-Light"
                          size:40.0];
}

+ (UIFont *)paymentAmountsLabelFont
{
    static UIFont *sPaymentAmountsLabelFont;
    return [self fontWithCache:sPaymentAmountsLabelFont
                          name:@"HelveticaNeue-Light"
                          size:50.0];
}

+ (UIFont *)paymentLabelFont
{
    static UIFont *sPaymentLabelFont;
    return [self fontWithCache:sPaymentLabelFont
                          name:@"HelveticaNeue-Light"
                          size:18.0];
}


+ (UIFont *)avatarNameFont
{
    static UIFont *sPaymentLabelFont;
    return [self fontWithCache:sPaymentLabelFont
                          name:@"HelveticaNeue-Light"
                          size:24.0];
}

+ (UIFont *)avatarNameSmallFont
{
    static UIFont *sAvatarNameSmallFont;
    return [self fontWithCache:sAvatarNameSmallFont
                          name:@"HelveticaNeue-Light"
                          size:16.0];
}

+ (UIFont *)alertViewTitleFont
{
    static UIFont *sAlertViewTitleFont;
    return [self fontWithCache:sAlertViewTitleFont
                          name:@"HelveticaNeue-Light"
                          size:16.0];
}


+ (UIFont *)alertViewDesriptionFont
{
    static UIFont *alertViewDesriptionFont;
    return [self fontWithCache:alertViewDesriptionFont
                          name:@"HelveticaNeue-Light"
                          size:13.0];
}

+ (UIFont *)profileInfoTableViewTransactionLabelFont
{
    static UIFont * sProfileInfoTableViewTransactionLabelFont;
    return [self fontWithCache:sProfileInfoTableViewTransactionLabelFont
                          name:@"HelveticaNeue-Light"
                          size:14.0];
}

+ (UIFont *)profileInfoTableViewTitleLabelFont
{
    static UIFont * sProfileInfoTableViewTitleLabelFont;
    return [self fontWithCache:sProfileInfoTableViewTitleLabelFont
                          name:@"HelveticaNeue-Light"
                          size:16.0];
}

+ (UIFont *)profileInfoTableViewValueLabelFont
{
    static UIFont * sProfileInfoTableViewValueValueFont;
    return [self fontWithCache:sProfileInfoTableViewValueValueFont
                          name:@"HelveticaNeue-Medium"
                          size:16.0];
}

+ (UIFont *)profileOptionsLabelFont
{
    static UIFont *sProfileOptionsLabelFont;
    return [self fontWithCache:sProfileOptionsLabelFont
                          name:@"HelveticaNeue-Light"
                          size:17.0];
}

+ (UIFont *)userInfoTitleFont
{
    static UIFont *suserInfoTitleFont;
    return [self fontWithCache:suserInfoTitleFont
                          name:@"HelveticaNeue-Light"
                          size:18.0];
}
+ (UIFont *)longInputFont
{
    static UIFont *slongInputFont;
    return [self fontWithCache:slongInputFont
                          name:@"HelveticaNeue-Light"
                          size:18.0];
}
+ (UIFont *)introduceLabelFont
{
    static UIFont *sintroduceLabelFont;
    return [self fontWithCache:sintroduceLabelFont
                          name:@"HelveticaNeue-Light"
                          size:12.0];
}

+ (UIFont *)profileInfoTableViewTimetsampLabelFont
{
    static UIFont * sProfileInfoTableViewTimetsampLabelFont;
    return [self fontWithCache:sProfileInfoTableViewTimetsampLabelFont
                          name:@"HelveticaNeue-Light"
                          size:12.0];
}

+ (UIFont*)sectionTitleFont
{
    static UIFont * sSectionTitleFont;
    return [self fontWithCache:sSectionTitleFont
                          name:@"HelveticaNeue-Light"
                          size:17.0];

}


#pragma mark - Private
/*!
 *  Create or reuse a font
 *
 *  @param cachedFont Static variable for caching.
 *  @param name Name of the font.
 *  @param size Size of the font.
 *
 *  @return The font.
 */
+ (UIFont *)fontWithCache:(UIFont *)cachedFont
                     name:(NSString *)name
                     size:(CGFloat)size
{
    if (!cachedFont) {
        cachedFont = [UIFont fontWithName:name size:size];
    }
    return cachedFont;
}

@end
