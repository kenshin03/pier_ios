//
//  PIRAlertView.h

//
//  Created by Kenny Tang on 12/18/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRAlertViewDelegate;


/*!
 *  Replacement of UIAlertView which is a non-modal.
 */
@interface PIRAlertView : UIView

- (instancetype)initWithTitle:(NSString*)title desc:(NSString*)desc buttonsLabels:(NSArray*)buttonLabels;

@property (nonatomic, weak) id<PIRAlertViewDelegate> delegate;
@property (nonatomic, strong) UIImage * presentingViewControllerImage;

@end


@protocol PIRAlertViewDelegate <NSObject>

- (void)alertView:(PIRAlertView*)view tappedButtonAtIndex:(NSUInteger)index;

@end