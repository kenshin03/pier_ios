//
//  PIRRegisterView.h

//
//  Created by Kenny Tang on 2/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRRegisterViewDelegate;

@interface PIRRegisterView : UIView

@property (nonatomic, weak) id<PIRRegisterViewDelegate> delegate;

@end

@protocol PIRRegisterViewDelegate <NSObject>

@optional

-(void)registerView:(PIRRegisterView*)view didRegisterWithFacebook:(BOOL)login;
-(void)registerView:(PIRRegisterView*)view didRegisterWithTencent:(BOOL)login;
-(void)registerView:(PIRRegisterView*)view didRegisterWithSina:(BOOL)login;
-(void)registerView:(PIRRegisterView*)view didRegisterWithEmail:(BOOL)login;

@end