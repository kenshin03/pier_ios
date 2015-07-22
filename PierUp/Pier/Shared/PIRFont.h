//
//  PIRFont.h

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIRFont : NSObject

#pragma mark - Shared

+ (UIFont *)navigationBarTitleFont;
+ (UIFont *)statusLabelFont;

+ (UIFont *)paymentAmountsLabelFont;
+ (UIFont *)paymentLabelFont;

+ (UIFont *)avatarNameFont;
+ (UIFont *)avatarNameSmallFont;

+ (UIFont *)alertViewTitleFont;
+ (UIFont *)alertViewDesriptionFont;

+ (UIFont *)loginTitleFont;
+ (UIFont *)loginButtonTitleFont;
+ (UIFont *)paymentAmountsMediumLabelFont;
+ (UIFont *)paymentAmountsSmallLabelFont;
+ (UIFont *)userInfoTitleFont;
+ (UIFont *)longInputFont;

+ (UIFont *)introduceLabelFont;

+ (UIFont *)profileOptionsLabelFont;

+ (UIFont *)profileInfoTableViewTitleLabelFont;
+ (UIFont *)profileInfoTableViewValueLabelFont;

+ (UIFont *)profileInfoTableViewTransactionLabelFont;
+ (UIFont *)profileInfoTableViewTimetsampLabelFont;

+ (UIFont *)sectionTitleFont;

@end
