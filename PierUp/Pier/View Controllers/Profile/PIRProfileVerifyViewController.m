//
//  PIRProfileVerifyViewController.m

//
//  Created by Kenny Tang on 3/16/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileVerifyViewController.h"
#import "MRProgress.h"
#import "PIRSeparator.h"
#import "PIRBankAccount+Extensions.h"
#import "PIRTextFieldElementView.h"
#import "PIRUserServices.h"
#import "PIRVerifyAccountView.h"

@interface PIRProfileVerifyViewController ()<
PIRVerifyAccountViewDelegate
>

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIBarButtonItem * dismissButton;
@property (nonatomic, strong) PIRVerifyAccountView * verifyAccountView;
@property (nonatomic, strong) UIButton * doneButton;
@end


@implementation PIRProfileVerifyViewController


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


- (PIRVerifyAccountView *)verifyAccountView
{
    if(!_verifyAccountView) {
        _verifyAccountView = [PIRVerifyAccountView new];
        _verifyAccountView.translatesAutoresizingMaskIntoConstraints = NO;
        _verifyAccountView.delegate = self;
    }
    return _verifyAccountView;
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
    self.navigationItem.title = NSLocalizedString(@"Verify Email/Pone", nil);
    self.navigationItem.rightBarButtonItem = self.dismissButton;
}

- (void)addSubviewTree
{
    
    [self.contentView addSubview:self.verifyAccountView];
    [self.view addSubview:self.contentView];
}

- (void)constrainViews
{
    
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"verifyAccountView":self.verifyAccountView,
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
                                      @"H:|[verifyAccountView(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-150-[verifyAccountView(300)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
}


#pragma mark - Event handlers

- (void)dismissButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // nothing
    }];
}

#pragma mark - PIRVerifyAccountViewDelegate methods

- (void)verifyAccountView:(PIRVerifyAccountView *)view verifyPhone:(NSString *)phoneVerifyCode verifyEmail:(NSString *)emailVerifyCode
{
    MRProgressOverlayView * progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = NSLocalizedString(@"Verifying...", nil);
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view.superview addSubview:progressView];
    [progressView show:YES];
    
    
    [[PIRUserServices sharedService] verifyPhoneCode:phoneVerifyCode email:emailVerifyCode success:^{
        
        progressView.titleLabelText = NSLocalizedString(@"Thanks!", nil);
        progressView.mode = MRProgressOverlayViewModeCheckmark;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [progressView dismiss:YES];
            //progressView should be removed from superView
            [progressView removeFromSuperview];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
    } error:^(NSError *error) {
        
        progressView.mode = MRProgressOverlayViewModeCross;
        NSDictionary *errorDict = error.userInfo;
        NSString *errorStringFromServer = errorDict[@"serverMessage"];
        errorStringFromServer = errorStringFromServer?errorStringFromServer:@"";
        
        NSString *errorStringFull = [NSString stringWithFormat:@"%@. %@", NSLocalizedString(@"Verification failed", nil), errorStringFromServer];
        progressView.titleLabelText = errorStringFull;
        progressView.mode = MRProgressOverlayViewModeCheckmark;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [progressView dismiss:YES];
            //progressView should be removed from superView
            [progressView removeFromSuperview];
        });
        
    }];
    
}


@end
