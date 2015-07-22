//
//  PIRDateFieldElementView.m

//
//  Created by Kenny Tang on 1/27/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRDateFieldElementView.h"
#import "PIRSeparator.h"
#import "PIRValidatorUtil.h"

@interface PIRDateFieldElementView()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *elementTextField;
@property (nonatomic, strong) PIRSeparator *separator;
@property (nonatomic, strong) NSString *titleValue;
@property (nonatomic, strong) UIButton * calendarButton;
@property (nonatomic, strong) UIImageView * calendarButtonBackgroundImageView;
@property (nonatomic, strong) UIToolbar * dismissKeyboardToolbar;
@property (nonatomic, strong) UIButton * dismissKeyboardButton;

@property (nonatomic, weak) id<PIRDateFieldElementViewDelegate> delegate;

@end


@implementation PIRDateFieldElementView

#pragma mark - Public

#pragma mark - Initailization

- (instancetype) initDateFieldElementViewWith:(NSString *)titleValue
                                     delagate:(id<PIRDateFieldElementViewDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _titleValue = titleValue;
        _delegate = delegate;
        [self addSubviewTree];
        [self constrainViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.elementTextField];
        
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL) validateDateField
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


- (UIImageView*)calendarButtonBackgroundImageView
{
    if (!_calendarButtonBackgroundImageView) {
        UIImage * calendarImage = [[UIImage imageNamed:@"calendar_25x25"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _calendarButtonBackgroundImageView = [[UIImageView alloc] initWithImage:calendarImage];
        _calendarButtonBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _calendarButtonBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _calendarButtonBackgroundImageView;
}

- (UIButton*)calendarButton
{
    if (!_calendarButton) {
        _calendarButton = [UIButton new];
        _calendarButton.translatesAutoresizingMaskIntoConstraints = NO;
        _calendarButton.backgroundColor = [UIColor clearColor];
        [_calendarButton addTarget:self action:@selector(calendarButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _calendarButton;
}

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
        _elementTextField.keyboardType = UIKeyboardTypeNumberPad;
        _elementTextField.adjustsFontSizeToFitWidth = YES;
        _elementTextField.minimumFontSize = 10.0;
        _elementTextField.delegate = self;
        _elementTextField.autocorrectionType = UITextAutocapitalizationTypeNone;
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
    [self addSubview:self.calendarButton];
    [self addSubview:self.separator];
    [self addSubview:self.calendarButtonBackgroundImageView];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"titleLabel":self.titleLabel,
                             @"elementTextField":self.elementTextField,
                             @"separator":self.separator,
                             @"calendarButton":self.calendarButton,
                             @"calendarButtonBackgroundImageView":self.calendarButtonBackgroundImageView,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[separator]-5-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel(100)]-[elementTextField]-20-[calendarButton(44)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[calendarButtonBackgroundImageView(25)]-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[elementTextField]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[calendarButton]-[separator(1)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[calendarButtonBackgroundImageView(25)]-12-[separator(1)]|" options:0 metrics:nil views:views]];
    
}

#pragma mark - UITextFieldTextDidChangeNotification methods

- (void)textFieldDidChange:(id)notification
{
    [self validateDateField];
    
    if ([self.delegate respondsToSelector:@selector(textFieldElementView:textFieldDidChange:)]) {
        [self.delegate textFieldElementView:self textFieldDidChange:self.elementTextField];
    }
    
}

#pragma mark - UITextField delegate methods

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    BOOL allowEdit = YES;
    
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
    BOOL isValidated = [PIRValidatorUtil validateDateFormat:text];
    return isValidated;
    
}

#pragma mark - event handler methods

- (void) dismissKeyboardButtonTapped:(id)sender
{
    // force a validation
    [self textFieldDidEndEditing:self.elementTextField];
    [self.elementTextField resignFirstResponder];
}

- (void)calendarButtonTapped:(id)sender
{
    [self.elementTextField resignFirstResponder];
    DLog(@"calendarButtonTapped:");
    if ([self.delegate respondsToSelector:@selector(dateField:didTapOnCalendarButton:)]){
        [self.delegate dateField:self didTapOnCalendarButton:YES];
    }
}

#pragma mark - House Keeping method

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.elementTextField];
}



@end
