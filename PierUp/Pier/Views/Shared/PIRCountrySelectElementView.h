//
//  PIRCountrySelectElementView.h

//
//  Created by Kenny Tang on 3/10/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRCountrySelectElementViewDelegate;

@interface PIRCountrySelectElementView : UIView

- (instancetype) initWithTitle:(NSString*)title delegate:(id<PIRCountrySelectElementViewDelegate>)delegate;

@property (nonatomic, weak) id<PIRCountrySelectElementViewDelegate> delegate;


@end


@protocol PIRCountrySelectElementViewDelegate <NSObject>

-(void)countrySelectView:(PIRCountrySelectElementView*)view usButtonTapped:(BOOL)tapped;
-(void)countrySelectView:(PIRCountrySelectElementView*)view cnButtonTapped:(BOOL)tapped;

@end

