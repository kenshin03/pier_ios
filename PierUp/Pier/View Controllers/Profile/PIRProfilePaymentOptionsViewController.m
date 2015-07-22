//
//  PIRProfilePaymentOptionsViewController.m

//
//  Created by Kenny Tang on 1/5/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfilePaymentOptionsViewController.h"
#import "PIRProfileDiscoveryOptionsViewController.h"

@interface PIRProfilePaymentOptionsViewController ()

@property (nonatomic, strong) UILabel * discoveryOptionTitleLabel;
@property (nonatomic, strong) UIButton * editDiscoveryOptionButton;

@end

@implementation PIRProfilePaymentOptionsViewController


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


#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Public mehtods

#pragma mark - Private

#pragma mark - Private properties


- (UILabel*)discoveryOptionTitleLabel
{
    if (!_discoveryOptionTitleLabel) {
        _discoveryOptionTitleLabel = [UILabel new];
        _discoveryOptionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _discoveryOptionTitleLabel.font = [PIRFont statusLabelFont];
        _discoveryOptionTitleLabel.text = @"Visibility to nearby Pier users:";
    }
    return _discoveryOptionTitleLabel;
}

- (UIButton*)editDiscoveryOptionButton
{
    if (!_editDiscoveryOptionButton) {
        _editDiscoveryOptionButton = [UIButton new];
        _editDiscoveryOptionButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_editDiscoveryOptionButton setTitle:@"All Pier users" forState:UIControlStateNormal];
        _editDiscoveryOptionButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_editDiscoveryOptionButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_editDiscoveryOptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _editDiscoveryOptionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _editDiscoveryOptionButton.layer.borderWidth = 0.5;
        [_editDiscoveryOptionButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_editDiscoveryOptionButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_editDiscoveryOptionButton addTarget:self action:@selector(discoveryOptionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editDiscoveryOptionButton;
}

#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [PIRColor defaultBackgroundColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}

- (void)addSubviewTree
{
    [self.view addSubview:self.discoveryOptionTitleLabel];
    [self.view addSubview:self.editDiscoveryOptionButton];
}

- (void)constrainViews
{
    NSMutableDictionary * views = [@{
                                     @"discoveryOptionTitleLabel":self.discoveryOptionTitleLabel,
                                     @"editDiscoveryOptionButton":self.editDiscoveryOptionButton
                                     } mutableCopy];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[discoveryOptionTitleLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[editDiscoveryOptionButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|-50-[discoveryOptionTitleLabel]-30-[editDiscoveryOptionButton(40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}



#pragma mark - Event handlers



- (void)discoveryOptionsButtonTapped:(id)sender
{
    DLog(@"discoveryOptionsButtonTapped");
    PIRProfileDiscoveryOptionsViewController * optionsVC = [PIRProfileDiscoveryOptionsViewController new];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:optionsVC];
    [self presentViewController:navController animated:YES completion:^{
        // nothing
    }];
    
    
}


@end
