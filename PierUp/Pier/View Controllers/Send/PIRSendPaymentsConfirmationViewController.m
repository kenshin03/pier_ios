//
//  PIRSendPaymentsConfirmationViewController.m

//
//  Created by Kenny Tang on 12/18/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRSendPaymentsConfirmationViewController.h"
#import "PIRMenuTabBarController.h"

@interface PIRSendPaymentsConfirmationViewController ()

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * descriptionLabel;
@property (nonatomic, strong) UIImageView * statusIconImageView;
@property (nonatomic, strong) UIBarButtonItem * doneButton;

@end

@implementation PIRSendPaymentsConfirmationViewController

#pragma mark - Public

#pragma mark - Initialization

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
//    [self update];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (UIBarButtonItem*)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
        _doneButton.enabled = NO;
        _doneButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
    }
    return _doneButton;
}


- (UILabel*)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _statusLabel.text = @"Done.";
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.font = [PIRFont statusLabelFont];
        _statusLabel.textColor = [PIRColor primaryTextColor];
    }
    return _statusLabel;
}

- (UILabel*)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _descriptionLabel.textColor = [PIRColor primaryTextColor];
        _descriptionLabel.numberOfLines = 0;
    }
    return _descriptionLabel;
}

- (UIImageView*)statusIconImageView
{
    if (!_statusIconImageView) {
        _statusIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReceiveIcon"]];
        _statusIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _statusIconImageView;
}


#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self.contentView addSubview:self.statusIconImageView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.view addSubview:self.contentView];
}

#pragma mark - loadView helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    mainView.backgroundColor = [UIColor whiteColor];
    return mainView;
}

- (void)setupNavigationBar
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}


- (void)constrainViews
{
    NSDictionary * views = @{
                             @"statusLabel":self.statusLabel,
                             @"descriptionLabel":self.descriptionLabel,
                             @"statusLabel":self.statusLabel,
                             @"statusIconImageView":self.statusIconImageView,
                             @"contentView":self.contentView,
                             
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[contentView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[contentView(568)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[statusIconImageView(50)]-30-[statusLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-200-[statusLabel]-[descriptionLabel]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-200-[statusIconImageView(70)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:[descriptionLabel(200)]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
}


- (void)update
{
    // if transfer successful
    self.descriptionLabel.text = NSLocalizedString(@"Payment request sent. You will be notified of the status very soon.", nil);
    
    // todo: payee rejected request
    
}


#pragma mark - Event handlers

-(void)doneButtonTapped:(id)sender
{
    DLog(@"doneButtonTapped");
    
    UIViewController * rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    if ([[rootViewController class] isKindOfClass:[PIRMenuTabBarController class]]) {
        PIRMenuTabBarController * menuViewController = (PIRMenuTabBarController*)rootViewController;
        menuViewController.selectedIndex = 2;
        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



@end
