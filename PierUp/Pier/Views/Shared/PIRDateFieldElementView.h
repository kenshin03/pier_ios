//
//  PIRDateFieldElementView.h

//
//  Created by Kenny Tang on 1/27/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRDateFieldElementViewDelegate;


@interface PIRDateFieldElementView : UIView

/**
 *  Default init method
 *
 *  @param titleValue title of the label that appears next to the text field
 *  @param typeValue  specify the type of keyboard to open up
 *  @param tagValue   a tag to identify textfield for delegates
 *  @param delegate   delegate to the textfield subview
 *
 *  @return instance of class
 */
- (instancetype) initDateFieldElementViewWith:(NSString *)titleValue
                                     delagate:(id<PIRDateFieldElementViewDelegate>)delegate;


// explicit method to call for validation. follows defined PIRTextFieldElementViewValidationOptions
- (BOOL) validateDateField;

// need to expose this for clients to set the text
@property (nonatomic, readonly) UITextField *elementTextField;


@end


@protocol PIRDateFieldElementViewDelegate <NSObject>

- (void)dateField:(PIRDateFieldElementView*)view didTapOnCalendarButton:(BOOL)tapped;

@optional

- (void)textFieldElementView:(PIRDateFieldElementView*)view textFieldDidBeginEditing:(UITextField *)textField;

- (void)textFieldElementView:(PIRDateFieldElementView*)view textFieldDidEndEditing:(UITextField *)textField;

- (void)textFieldElementView:(PIRDateFieldElementView*)view textFieldDidChange:(UITextField *)textField;

@end
