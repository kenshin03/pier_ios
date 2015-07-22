//
//  PIRVerifyAccountView.h

//
//  Created by Kenny Tang on 3/15/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRVerifyAccountViewDelegate;

@interface PIRVerifyAccountView : UIView

@property (nonatomic, weak) id<PIRVerifyAccountViewDelegate> delegate;

@end

@protocol PIRVerifyAccountViewDelegate <NSObject>

-(void)verifyAccountView:(PIRVerifyAccountView*)view verifyPhone:(NSString*)phoneVerifyCode verifyEmail:(NSString*)emailVerifyCode;

@end