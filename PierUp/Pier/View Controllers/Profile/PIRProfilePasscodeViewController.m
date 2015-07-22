//
//  PIRProfilePasscodeViewController.m

//
//  Created by Kenny Tang on 1/4/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfilePasscodeViewController.h"
#import "MRProgress.h"
#import "PIRSeparator.h"
#import "PIRBankAccount+Extensions.h"
#import "PIRTextFieldElementView.h"
#import "PIRUserServices.h"

@interface PIRProfilePasscodeViewController ()

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIBarButtonItem * dismissButton;
@property (nonatomic, strong) UIButton * doneButton;
@property (nonatomic, strong) PIRSeparator * separator;
@property (nonatomic, strong) PIRTextFieldElementView * passcodeView;

@end

@implementation PIRProfilePasscodeViewController

#pragma mark - Public

#pragma mark - View lifecycle


- (void)loadView
{
    self.view = [self mainView];
    [self addSubviewTree];
    [self setupNavigationBar];
    [self constrainViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties


- (PIRSeparator*)separator
{
    if (!_separator) {
        _separator = [PIRSeparator new];
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _separator;
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (UIBarButtonItem*)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismissButtonTapped:)];
        _dismissButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
        
    }
    return _dismissButton;
}

- (UIButton *)doneButton
{
    if(!_doneButton)
    {
        _doneButton = [UIButton new];
        _doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_doneButton setTitle:NSLocalizedString(@"Update Passcode", nil) forState:UIControlStateNormal];
        [_doneButton setTintColor:[PIRColor defaultButtonTextColor]];
        _doneButton.backgroundColor = [PIRColor defaultTintColor];
        _doneButton.layer.cornerRadius = 3.0;
        _doneButton.layer.masksToBounds = YES;
        [_doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (PIRTextFieldElementView *)passcodeView
{
    if(!_passcodeView) {
        _passcodeView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Passcode:", nil) keyBoardType:UIKeyboardTypeNumberPad delagate:nil];
        _passcodeView.validateOptions = PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsInteger |
        PIRTextFieldElementViewValidationLength;
        
        // pass codes must be 6 chars long
        _passcodeView.validateMinLength = 6;
        _passcodeView.validateMaxLength = 6;
        [_passcodeView.elementTextField becomeFirstResponder];
        
    }
    return _passcodeView;
}

#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [PIRColor defaultBackgroundColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}

- (void)setupNavigationBar
{
    self.navigationItem.title = NSLocalizedString(@"Update Passcode", nil);
    self.navigationItem.rightBarButtonItem = self.dismissButton;
}

- (void)addSubviewTree
{
    
    [self.contentView addSubview:self.separator];
    [self.contentView addSubview:self.passcodeView];
    [self.contentView addSubview:self.doneButton];
    
    [self.view addSubview:self.contentView];
}

- (void)constrainViews
{
    
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"passcodeView":self.passcodeView,
                             @"doneButton":self.doneButton,
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[contentView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[contentView(568)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[passcodeView(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[doneButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-150-[passcodeView]-40-[doneButton]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
}


#pragma mark - Event handlers

- (void)doneButtonTapped:(id)sender
{
    if ([self.passcodeView.elementTextField.text length]) {
        [self.passcodeView.elementTextField resignFirstResponder];
        NSString * passCode = self.passcodeView.elementTextField.text;
        
        MRProgressOverlayView * progressView = [MRProgressOverlayView new];
        progressView.titleLabelText = NSLocalizedString(@"Updating...", nil);
        progressView.mode = MRProgressOverlayViewModeIndeterminate;
        [self.view.superview addSubview:progressView];
        [progressView show:YES];
        
        PIRUser * user = [[PIRUserServices sharedService] currentUser];
        user.passCode = passCode;
        [[PIRUserServices sharedService] updateCurrentUser:user];
        
        [self dismissButtonTapped:nil];
        
    }
}

- (void)dismissButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // nothing
    }];
}

@end
