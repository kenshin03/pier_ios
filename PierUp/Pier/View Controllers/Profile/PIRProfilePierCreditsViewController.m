//
//  PIRProfilePierCreditsViewController.m

//
//  Created by Kenny Tang on 1/18/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfilePierCreditsViewController.h"
#import "PIRCreditApplicationViewController.h"

@interface PIRProfilePierCreditsViewController ()

@property (nonatomic, strong) UIButton * applyPierCreditButton;
@property (nonatomic, strong) UILabel * noPierCreditLabel;

@end

@implementation PIRProfilePierCreditsViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
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

- (UILabel*)noPierCreditLabel
{
    if (!_noPierCreditLabel) {
        _noPierCreditLabel = [UILabel new];
        _noPierCreditLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noPierCreditLabel.text = NSLocalizedString(@"Apply credit directly from  Enjoy extra low rates. ", nil);
        _noPierCreditLabel.font = [PIRFont statusLabelFont];
        _noPierCreditLabel.numberOfLines = 0;
    }
    return _noPierCreditLabel;
}

- (UIButton*)applyPierCreditButton
{
    if (!_applyPierCreditButton) {
        _applyPierCreditButton = [UIButton new];
        _applyPierCreditButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_applyPierCreditButton setTitle:@"Pre-qualify for free" forState:UIControlStateNormal];
        _applyPierCreditButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_applyPierCreditButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_applyPierCreditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _applyPierCreditButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _applyPierCreditButton.layer.borderWidth = 0.5;
        [_applyPierCreditButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_applyPierCreditButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_applyPierCreditButton addTarget:self action:@selector(applyPierCreditButtonTapped:) forControlEvents:UIControlEventTouchDown];
        
    }
    return _applyPierCreditButton;
}


#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    mainView.userInteractionEnabled = YES;
    return mainView;
}

- (void)addSubviewTree
{
    [self.view addSubview:self.noPierCreditLabel];
    [self.view addSubview:self.applyPierCreditButton];
}

- (void)constrainViews
{
    NSMutableDictionary * views = [@{
                                     @"applyPierCreditButton":self.applyPierCreditButton
                                     } mutableCopy];
    
    if (self.noPierCreditLabel) {
        views[@"noPierCreditLabel"] = self.noPierCreditLabel;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noPierCreditLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                   @"H:[noPierCreditLabel(240)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[applyPierCreditButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|-200-[noPierCreditLabel(100)]-20-[applyPierCreditButton(40)]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    
}

#pragma mark - Event handlers



- (void)applyPierCreditButtonTapped:(id)sender
{
    DLog(@"applyPierCreditButtonTapped");
    PIRCreditApplicationViewController * creditVC = [PIRCreditApplicationViewController new];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:creditVC];
    [self presentViewController:navController animated:YES completion:^{
        // nothing
    }];
    
}



@end
