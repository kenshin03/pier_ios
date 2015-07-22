//
//  PIRCreditApplicationViewController.m

//
//  Created by Kenny Tang on 1/24/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRCreditApplicationViewController.h"
#import "PIRCreditApplication.h"
#import "PIRCreditApplicationResultsViewController.h"
#import "PIRSeparator.h"
#import "PIRTextFieldElementView.h"
#import "PIRTransactionServices.h"
#import "PIRUserServices.h"
#import "PIRValidatorUtil.h"

@interface PIRCreditApplicationViewController ()<PIRTextFieldElementViewDelegate>

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIBarButtonItem * dismissButton;
@property (nonatomic, strong) PIRTextFieldElementView * ssnEditView;
//@property (nonatomic, strong) PIRTextFieldElementView * dobEditView;
//@property (nonatomic, strong) PIRTextFieldElementView * homeAddressEditView;
@property (nonatomic, strong) PIRTextFieldElementView * zipEditView;
@property (nonatomic, strong) PIRSeparator * separator;
@property (nonatomic, strong) UIButton * confirmButton;

@end

@implementation PIRCreditApplicationViewController


#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)dealloc
{
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

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = NSLocalizedString(@"Pre-qualify for Pier Credit", nil);
        _titleLabel.font = [PIRFont statusLabelFont];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (PIRTextFieldElementView *)ssnEditView
{
    if(!_ssnEditView)
    {
        _ssnEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"SSN:", nil) keyBoardType:UIKeyboardTypeNumberPad  delagate:self];
        _ssnEditView.translatesAutoresizingMaskIntoConstraints = NO;
        _ssnEditView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationLength;
        _ssnEditView.elementTextField.placeholder = NSLocalizedString(@"111111111", @"");
        _ssnEditView.validateMinLength = 9;
        _ssnEditView.validateMaxLength = 9;
    }
    return _ssnEditView;
}


- (PIRTextFieldElementView *)zipEditView
{
    if(!_zipEditView)
    {
        _zipEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"ZIP:", nil) keyBoardType:UIKeyboardTypeDefault  delagate:self];
        _zipEditView.translatesAutoresizingMaskIntoConstraints = NO;
        _zipEditView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty | PIRTextFieldElementViewValidationIsInteger;
        _zipEditView.elementTextField.placeholder = NSLocalizedString(@"94105", @"");
    }
    return _zipEditView;
}

/*
- (PIRTextFieldElementView *)dobEditView
{
    if(!_dobEditView)
    {
        _dobEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Birth:", nil) keyBoardType:UIKeyboardTypeDefault  delagate:self];
        _dobEditView.translatesAutoresizingMaskIntoConstraints = NO;
        _dobEditView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty;
        _dobEditView.elementTextField.placeholder = NSLocalizedString(@"MM/DD/YYYY", @"");
    }
    return _dobEditView;
}

- (PIRTextFieldElementView *)homeAddressEditView
{
    if(!_homeAddressEditView)
    {
        _homeAddressEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Address:", nil) keyBoardType:UIKeyboardTypeDefault  delagate:self];
        _homeAddressEditView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationLength;
        _homeAddressEditView.validateMinLength = 10;
        _homeAddressEditView.validateMaxLength = 200;
    }
    return _homeAddressEditView;
}
*/
- (UIBarButtonItem*)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismissButtonTapped:)];
        _dismissButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
        
    }
    return _dismissButton;
}

- (UIButton *)confirmButton
{
    if(!_confirmButton)
    {
        _confirmButton = [UIButton new];
        _confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_confirmButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _confirmButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _confirmButton.layer.borderWidth = 0.5;
        [_confirmButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
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
    self.navigationItem.title = NSLocalizedString(@"Pier Credit", nil);
    self.navigationItem.rightBarButtonItem = self.dismissButton;
}

- (void)addSubviewTree
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.separator];
    [self.contentView addSubview:self.ssnEditView];
    [self.contentView addSubview:self.zipEditView];
    
//    [self.contentView addSubview:self.dobEditView];
//    [self.contentView addSubview:self.homeAddressEditView];
    [self.contentView addSubview:self.confirmButton];
    [self.view addSubview:self.contentView];
}

- (void)constrainViews
{
    NSMutableDictionary * views = [@{
                                     @"contentView":self.contentView,
                                     @"titleLabel":self.titleLabel,
                                     @"separator":self.separator,
                                     @"ssnEditView":self.ssnEditView,
                                     @"zipEditView":self.zipEditView,
//                                     @"dobEditView":self.dobEditView,
//                                     @"homeAddressEditView":self.homeAddressEditView,
                                     @"confirmButton":self.confirmButton,
                                     } mutableCopy];
    
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
                               @"H:|-[titleLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[separator]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[ssnEditView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[zipEditView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
//                                      @"H:|[dobEditView]|"
//                                                                             options:0
//                                                                             metrics:nil
//                                                                               views:views]
//     ];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
//                                      @"H:|[homeAddressEditView]|"
//                                                                             options:0
//                                                                             metrics:nil
//                                                                               views:views]
//     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[confirmButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    /*
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-100-[titleLabel]-20-[separator]-[ssnEditView]-[dobEditView]-[homeAddressEditView]-40-[confirmButton(44)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
     */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-100-[titleLabel]-20-[separator]-[ssnEditView]-[zipEditView]-40-[confirmButton(44)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
}

#pragma mark - Event handlers



- (void)confirmButtonTapped:(id)sender
{
    DLog(@"confirmButtonTapped");
    // validation
    if([self.zipEditView validateTextField] &&
       [self.ssnEditView validateTextField]){
        
            PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
        
            currentUser.zipCode = self.zipEditView.elementTextField.text;
            currentUser.ssn = self.ssnEditView.elementTextField.text;
            
            PIRCreditApplication *application = [PIRCreditApplication createEntity];
            application.user = currentUser;
            
            [[PIRTransactionServices sharedService] applyForCredit:application success:^(NSNumber *amount) {
                
                PIRCreditApplicationResultsViewController *vc = [PIRCreditApplicationResultsViewController new];
                if (amount){
                    vc.applicationSucessful = YES;
                    vc.creditAmount = amount;
                    
                }else{
                    vc.applicationSucessful = NO;
                    vc.creditAmount = nil;
                }
                [self.navigationController pushViewController:vc animated:YES];
                
                NSLog(@"qualified: %f", [amount floatValue]);
                
            } error:^(NSError *error) {
                NSLog(@"Error in confirmButtonTapped: %@", error);
            }];
    }

    
}


- (void)dismissButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // nothing
    }];
}

#pragma mark - PIRTextFieldElementViewDelegate methods

- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidChange:(UITextField *)textField
{
}

@end
