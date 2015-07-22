//
//  PIRTextFieldElementView.m

//
//  Created by Kenny Tang on 12/30/13.
//  Copyright (c) 2013  All rights reserved.
//

#import "PIRTextFieldElementView.h"
#import "PIRSeparator.h"
#import "PIRValidatorUtil.h"


@interface PIRTextFieldElementView()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *elementTextField;
@property (nonatomic, strong) PIRSeparator *separator;
@property (nonatomic, strong) NSString *titleValue;
@property (nonatomic, strong) UIToolbar * dismissKeyboardToolbar;
@property (nonatomic, strong) UIButton * dismissKeyboardButton;
@property (nonatomic) UIKeyboardType typeValue;
@property (nonatomic, weak) id<PIRTextFieldElementViewDelegate> delegate;

@end


@implementation PIRTextFieldElementView

#pragma mark - Public

#pragma mark - Initailization

- (instancetype) initTextFieldElementViewWith:(NSString *)titleValue
                                 keyBoardType:(UIKeyboardType)typeValue
                                     delagate:(id<PIRTextFieldElementViewDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _titleValue = titleValue;
        _typeValue = typeValue;
        _delegate = delegate;
        [self addSubviewTree];
        [self constrainViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.elementTextField];
        
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL) validateTextField
{
    BOOL isValidated = [self validateTextFieldText:self.elementTextField.text];
    if (!isValidated) {
        self.titleLabel.textColor = [PIRColor textFieldFailedValidationColor];
        self.elementTextField.textColor = [PIRColor textFieldFailedValidationColor];
    }else{
        self.titleLabel.textColor = [PIRColor placeholderTextColor];
        self.elementTextField.textColor = [PIRColor primaryTextColor];
    }
    
    return isValidated;
}


#pragma mark - Private

#pragma mark - Private properties

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = self.titleValue;
        _titleLabel.font = [PIRFont userInfoTitleFont];
        _titleLabel.textColor = [PIRColor placeholderTextColor];
    }
    return _titleLabel;
}


- (UITextField*)elementTextField
{
    if (!_elementTextField) {
        _elementTextField = [UITextField new];
        _elementTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _elementTextField.textAlignment = NSTextAlignmentRight;
        _elementTextField.font = [PIRFont userInfoTitleFont];
        _elementTextField.textColor = [PIRColor primaryTextColor];
        _elementTextField.keyboardType = self.typeValue;
        _elementTextField.adjustsFontSizeToFitWidth = YES;
        _elementTextField.minimumFontSize = 10.0;
        _elementTextField.delegate = self;
        _elementTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return _elementTextField;
}

- (PIRSeparator*)separator
{
    if (!_separator) {
        _separator = [PIRSeparator new];
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _separator;
}

- (UIToolbar*)dismissKeyboardToolbar
{
    if (!_dismissKeyboardToolbar) {
        // has to use frames as toolbar does not have superview
        _dismissKeyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320.0, 44.0)];
    }
    return _dismissKeyboardToolbar;
}

- (UIButton*)dismissKeyboardButton
{
    if (!_dismissKeyboardButton) {
        _dismissKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_dismissKeyboardButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        _dismissKeyboardButton.tintColor = [PIRColor defaultTintColor];
        _dismissKeyboardButton.frame = CGRectMake(230.0, 0.0, 100.0, 44.0);
        [_dismissKeyboardButton setTitle:NSLocalizedString(@"Done", Nil) forState:UIControlStateNormal];
        [_dismissKeyboardButton addTarget:self action:@selector(dismissKeyboardButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _dismissKeyboardButton;
}

#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.elementTextField];
    [self addSubview:self.separator];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"titleLabel":self.titleLabel,
                             @"elementTextField":self.elementTextField,
                             @"separator":self.separator,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[separator]-5-|" options:0 metrics:nil views:views]];
    
    if ([self.titleLabel.text length]){
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel(<=150)]-[elementTextField]-|" options:0 metrics:nil views:views]];
    }else{
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-[elementTextField]-|" options:0 metrics:nil views:views]];
        
    }
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[elementTextField]-[separator(1)]|" options:0 metrics:nil views:views]];
}

#pragma mark - UITextFieldTextDidChangeNotification methods

- (void)textFieldDidChange:(id)notification
{
    [self validateTextField];
    
    if ([self.delegate respondsToSelector:@selector(textFieldElementView:textFieldDidChange:)]) {
        [self.delegate textFieldElementView:self textFieldDidChange:self.elementTextField];
    }
    
}

#pragma mark - UITextField delegate methods

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    BOOL allowEdit = YES;
    
    BOOL validateLength = (self.validateOptions & PIRTextFieldElementViewValidationLength) != 0;
    if (validateLength) {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        if (newLength > self.validateMaxLength) {
            allowEdit = NO;
        }
    }
    
    return allowEdit;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.dismissKeyboardToolbar addSubview:self.dismissKeyboardButton];
    [textField setInputAccessoryView:self.dismissKeyboardToolbar];
    
    if ([self.delegate respondsToSelector:@selector(textFieldElementView:textFieldDidBeginEditing:)]) {
        [self.delegate textFieldElementView:self textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // validate textfield
    BOOL isValidated = [self validateTextFieldText:textField.text];
    if (!isValidated) {
        self.titleLabel.textColor = [PIRColor textFieldFailedValidationColor];
        self.elementTextField.textColor = [PIRColor textFieldFailedValidationColor];
    }else{
        self.titleLabel.textColor = [PIRColor placeholderTextColor];
        self.elementTextField.textColor = [PIRColor primaryTextColor];
    }
}

#pragma mark - validation helper method

- (BOOL) validateTextFieldText:(NSString*)text
{
    BOOL validateEmptiness = (self.validateOptions & PIRTextFieldElementViewValidationNonEmpty) != 0;
    BOOL validateEmail = (self.validateOptions & PIRTextFieldElementViewValidationIsEmail) != 0;
    BOOL validateInteger = (self.validateOptions & PIRTextFieldElementViewValidationIsInteger) != 0;
    BOOL validateDecimal = (self.validateOptions & PIRTextFieldElementViewValidationIsDecimal) != 0;
    BOOL validateSSN = (self.validateOptions & PIRTextFieldElementViewValidationIsSSN) != 0;
    BOOL validateAlphaOnly = (self.validateOptions & PIRTextFieldElementViewValidationIsAlphaOnly) != 0;
    BOOL validateLength = (self.validateOptions & PIRTextFieldElementViewValidationLength) != 0;
    BOOL validateAlphaNum = (self.validateOptions & PIRTextFieldElementViewValidationIsAlphaNum) != 0;
    
    __block BOOL isTextValidated = YES;
    
    // suppress warning. we know PIRValidatorUtil repsonds to the selectors
    #pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    #pragma GCC diagnostic ignored  "-Wundeclared-selector"
    
    NSMutableArray * validateArray = [@[] mutableCopy];
    if (validateEmail) {
        [validateArray addObject:@"validateEmail:"];
    }
    if (validateEmptiness) {
        [validateArray addObject:@"validateEmptiness:"];
    }
    if (validateInteger) {
        [validateArray addObject:@"isInteger:"];
    }
    if (validateDecimal) {
        [validateArray addObject:@"isDecimal:"];
    }
    if (validateSSN) {
        [validateArray addObject:@"validateSSN:"];
    }
    if (validateAlphaOnly) {
        [validateArray addObject:@"isString:"];
    }
    if (validateAlphaNum) {
        [validateArray addObject:@"validateAlphaNum:"];
    }
    
    [validateArray enumerateObjectsUsingBlock:^(NSString * selectorString, NSUInteger idx, BOOL *stop) {
        
        NSMethodSignature * signature = [[PIRValidatorUtil class] methodSignatureForSelector:NSSelectorFromString(selectorString)];
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = NSSelectorFromString(selectorString);
        invocation.target = [PIRValidatorUtil class];
        [invocation setArgument:(void *)&text atIndex:2];
        
        [invocation invoke];
        BOOL returnValue;
        [invocation getReturnValue:&returnValue];
        
        if (!returnValue) {
            isTextValidated = NO;
            *stop = YES;
        }
    }];
    #pragma end
    
    if ((isTextValidated) && (validateLength)) {
        isTextValidated = [PIRValidatorUtil validateLength:text min:self.validateMinLength max:self.validateMaxLength];
    }
    if (validateSSN) {
        // to-do: implement later
        isTextValidated = YES;
    }
    
    return isTextValidated;
    
}

-(CGSize)intrinsicContentSize
{
    return CGSizeMake(320.0, 44.0);
}

#pragma mark - event handler methods

- (void) dismissKeyboardButtonTapped:(id)sender
{
    // force a validation
    [self textFieldDidEndEditing:self.elementTextField];
    [self.elementTextField resignFirstResponder];
}

#pragma mark - House Keeping method

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.elementTextField];
}

@end
