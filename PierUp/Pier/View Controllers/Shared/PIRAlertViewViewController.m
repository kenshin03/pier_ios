//
//  PIRAlertViewViewController.m

//
//  Created by Kenny Tang on 12/18/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRAlertViewViewController.h"
#import "PIRAlertView.h"

@interface PIRAlertViewViewController ()<PIRAlertViewDelegate>

@property (nonatomic, strong) PIRAlertView * alertView;
@property (nonatomic, strong) AlertViewCallback callBack;

@end

@implementation PIRAlertViewViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (instancetype)initWithTitle:(NSString*)title desc:(NSString*)desc buttonsLabels:(NSArray*)buttonLabels completion:(AlertViewCallback)completion
{
    self = [super init];
    if (self) {
        PIRAlertView * alertView = [[PIRAlertView alloc] initWithTitle:title desc:desc buttonsLabels:buttonLabels];
        alertView.translatesAutoresizingMaskIntoConstraints = NO;
        alertView.delegate = self;
        alertView.presentingViewControllerImage = [self snapShotOfPresentingView];
        self.alertView = alertView;
        self.callBack = completion;
    }
    return self;
}


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

- (void)viewWillAppear:(BOOL)animated
{
    [self fadeInAnimation:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - loadView helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}

- (UIImage*) snapShotOfPresentingView
{
    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    // use this instead of drawViewHierarchyInRect: to include the navbar in the image
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

#pragma mark - Private properties



#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.alertView];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"alertView":self.alertView,
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[alertView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[alertView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}


#pragma mark - Event handlers



#pragma mark - PIRAlertView delegate

- (void)alertView:(PIRAlertView*)view tappedButtonAtIndex:(NSUInteger)index
{
    // todo: check for cancel button tapped
    [self fadeOutAnimationCallback:^{
        self.callBack(index, NO);
    }];
    
}

#pragma mark - animation helpers

- (void)fadeInAnimation:(BOOL)animated
{
    self.view.alpha = 0.0;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [super viewWillDisappear:animated];
    }];
    
}

- (void)fadeOutAnimationCallback:(void(^)()) completion
{
    self.view.alpha = 1.0;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        completion();
    }];
    
}

@end
