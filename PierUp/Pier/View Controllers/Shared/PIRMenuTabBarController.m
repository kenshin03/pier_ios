//
//  PIRMenuTabBarController.m

//
//  Created by Kenny Tang on 1/1/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRMenuTabBarController.h"
#import "PIRProfileViewController.h"
#import "PIRReceivePaymentsViewController.h"
#import "PIRSendPaymentsViewController.h"

@interface PIRMenuTabBarController ()

@property (nonatomic, strong)UINavigationController * sendNavigationController;
@property (nonatomic, strong)UINavigationController * receiveNavigationController;
@property (nonatomic, strong)PIRProfileViewController * profileController;

@end

@implementation PIRMenuTabBarController


#pragma mark - Public

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTabBarController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties

- (UINavigationController *)sendNavigationController
{
    if(!_sendNavigationController)
    {
        PIRSendPaymentsViewController *payController = [PIRSendPaymentsViewController new];
        payController.title = NSLocalizedString(@"Send", nil);
        payController.tabBarItem.image = [[UIImage imageNamed:@"Share"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        _sendNavigationController = [[UINavigationController alloc] initWithRootViewController:payController];
        
    }
    return _sendNavigationController;
}

- (UINavigationController *)receiveNavigationController
{
    if(!_receiveNavigationController)
    {
        PIRReceivePaymentsViewController *receiveController = [PIRReceivePaymentsViewController new];
        receiveController.title = NSLocalizedString(@"Received", nil);
        receiveController.tabBarItem.image = [[UIImage imageNamed:@"Receive"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        _receiveNavigationController = [[UINavigationController alloc] initWithRootViewController:receiveController];
    }
    return _receiveNavigationController;
}

- (PIRProfileViewController *)profileController
{
    if(!_profileController)
    {
        _profileController = [PIRProfileViewController new];
        _profileController.title = NSLocalizedString(@"Profile", nil);
        _profileController.tabBarItem.image = [[UIImage imageNamed:@"ProfileTabBar"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    }
    return _profileController;
}


#pragma mark - Initialization helpers

#pragma mark - tabbarcontroller helpers

- (void)initTabBarController
{
    self.viewControllers = @[self.sendNavigationController,
                             self.receiveNavigationController,
                             self.profileController];
    self.selectedIndex = 2;
    self.tabBar.tintColor = [PIRColor defaultTintColor];
}

@end
