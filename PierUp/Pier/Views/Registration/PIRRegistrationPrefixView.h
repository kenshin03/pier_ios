//
//  PIRRegistrationPrefixView.h

//
//  Created by Kenny Tang on 1/16/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRRegistrationPrefixViewDelegate;

@interface PIRRegistrationPrefixView : UIView

@property (nonatomic, weak) id<PIRRegistrationPrefixViewDelegate> delegate;

@end


@protocol PIRRegistrationPrefixViewDelegate <NSObject>

-(void)prefixView:(PIRRegistrationPrefixView*)view misterButtonTapped:(BOOL)tapped;
-(void)prefixView:(PIRRegistrationPrefixView*)view mrsButtonTapped:(BOOL)tapped;
-(void)prefixView:(PIRRegistrationPrefixView*)view missButtonTapped:(BOOL)tapped;

@end

