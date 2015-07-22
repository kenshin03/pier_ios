//
//  PIRTextFieldElementView.h

//
//  Created by Kenny Tang on 12/30/13.
//  Copyright (c) 2013  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRTextFieldElementViewDelegate;

// validation options

typedef NS_OPTIONS(NSUInteger, PIRTextFieldElementViewValidationOptions) {
        PIRTextFieldElementViewValidationNonEmpty    = 1 << 0,
        PIRTextFieldElementViewValidationIsInteger   = 1 << 1,
        PIRTextFieldElementViewValidationIsDecimal   = 1 << 2,
        PIRTextFieldElementViewValidationIsEmail     = 1 << 3,
        PIRTextFieldElementViewValidationIsSSN       = 1 << 4,
        PIRTextFieldElementViewValidationIsAlphaOnly = 1 << 5,
        PIRTextFieldElementViewValidationLength      = 1 << 6,
        PIRTextFieldElementViewValidationIsAlphaNum  = 1 << 7,
};




/*!
 *  UIView subclass, contains a main UILabel and UITextField. Used for registration screens.
 */
@interface PIRTextFieldElementView : UIView

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
- (instancetype) initTextFieldElementViewWith:(NSString *)titleValue
                                 keyBoardType:(UIKeyboardType)typeValue
                                     delagate:(id<PIRTextFieldElementViewDelegate>)delegate;


// explicit method to call for validation. follows defined PIRTextFieldElementViewValidationOptions
- (BOOL) validateTextField;

// need to expose this for clients to set the text
@property (nonatomic, readonly) UITextField *elementTextField;

// a value from PIRTextFieldElementViewValidationOptions
@property (nonatomic) NSUInteger validateOptions;

// used with PIRTextFieldElementViewValidationLength
@property (nonatomic) CGFloat validateMinLength;
@property (nonatomic) CGFloat validateMaxLength;

@end

@protocol PIRTextFieldElementViewDelegate <NSObject>

@optional

- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidBeginEditing:(UITextField *)textField;

- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidEndEditing:(UITextField *)textField;

- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidChange:(UITextField *)textField;

@end
