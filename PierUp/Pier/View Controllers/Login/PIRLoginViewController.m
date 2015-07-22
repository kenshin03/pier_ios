//
//  PIRLoginViewController.m
//

#import "PIRLoginViewController.h"
#import "MRProgress.h"
#import "PIRAppDelegate.h"
#import "PIRLoginView.h"
#import "PIRMenuTabBarController.h"
#import "PIRRegisterView.h"
#import "PIRRegisterViewController.h"
#import "PIRVerifyAccountView.h"
#import "PIRSeparator.h"
#import "PIRSocialAccount+Extensions.h"
#import "PIRTransactionServices.h"
#import "PIRUserServices.h"


@interface PIRLoginViewController ()<
UIScrollViewDelegate,
PIRLoginViewDelegate,
PIRRegisterViewDelegate,
PIRVerifyAccountViewDelegate
>


@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) PIRLoginView *loginView;
@property (nonatomic, strong) PIRRegisterView *registerView;
@property (nonatomic, strong) PIRVerifyAccountView *verifyAccountView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) MRProgressOverlayView *progressView;

@end


@implementation PIRLoginViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
    [self updateViewWithUser];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ((![self.verifyPhoneCode length]) || (![self.verifyEmailCode length])){
        [self.contentScrollView scrollRectToVisible:CGRectMake(320.0, 0.0, 320.0, 568.0) animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
#pragma mark - Private properties

- (UIImageView *) logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pier_logo"]];
        _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _logoImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [PIRColor primaryTextColor];
        _titleLabel.font = [PIRFont loginTitleFont];
        _titleLabel.text = NSLocalizedString(@"Welcome", nil);
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

-(UIScrollView*)contentScrollView
{
    if (!_contentScrollView){
        _contentScrollView = [UIScrollView new];
        _contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (PIRLoginView*)loginView
{
    if (!_loginView){
        _loginView = [PIRLoginView new];
        _loginView.translatesAutoresizingMaskIntoConstraints = NO;
        _loginView.delegate = self;
    }
    return _loginView;
}


- (PIRVerifyAccountView*)verifyAccountView
{
    if (!_verifyAccountView){
        _verifyAccountView = [PIRVerifyAccountView new];
        _verifyAccountView.translatesAutoresizingMaskIntoConstraints = NO;
        _verifyAccountView.delegate = self;
    }
    return _verifyAccountView;
}

- (PIRRegisterView*)registerView
{
    if (!_registerView){
        _registerView = [PIRRegisterView new];
        _registerView.translatesAutoresizingMaskIntoConstraints = NO;
        _registerView.delegate = self;
    }
    return _registerView;
}

-(UIPageControl*)pageControl
{
    if (!_pageControl){
        _pageControl = [UIPageControl new];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [PIRColor defaultTintColor];
        _pageControl.numberOfPages = 3;
    }
    return _pageControl;
}

-(MRProgressOverlayView*)progressView
{
    if (!_progressView){
        _progressView = [MRProgressOverlayView new];
        _progressView.mode = MRProgressOverlayViewModeIndeterminate;
    }
    return _progressView;
}

#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    [mainView.superview addSubview:self.progressView];
    return mainView;
}

- (void)setupNavigationBar
{
}

- (void)addSubviewTree
{
    [self.contentScrollView addSubview:self.verifyAccountView];
    [self.contentScrollView addSubview:self.loginView];
    [self.contentScrollView addSubview:self.registerView];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.pageControl];
}

- (void)constrainViews
{
    NSDictionary *scrollViewViews = @{
                                      @"logoImageView":self.logoImageView,
                                      @"verifyAccountView":self.verifyAccountView,
                                      @"loginView":self.loginView,
                                      @"registerView":self.registerView,
                                      };
    [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[verifyAccountView(320)][loginView(320)][registerView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:scrollViewViews]];
    [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                            @"V:|[verifyAccountView(300)]"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:scrollViewViews]];
    [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                            @"V:|[loginView(300)]"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:scrollViewViews]];
    [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                            @"V:|[registerView]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:scrollViewViews]];
    
    
    NSDictionary * views = @{
                             @"logoImage":self.logoImageView,
                             @"titleLabel":self.titleLabel,
                             @"contentScrollView":self.contentScrollView,
                             @"pageControl":self.pageControl
                             };
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-20-[logoImage(60)][titleLabel]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[contentScrollView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|-120-[titleLabel(60)]-[contentScrollView(>=300)]-40-[pageControl(44)]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|-120-[logoImage(60)]-[contentScrollView(>=300)]-40-[pageControl(44)]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentScrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

-(void)updateViewWithUser
{
    PIRUser *lastUser = [[PIRUserServices sharedService] currentUser];
    if (lastUser){
        self.loginView.currentUser = lastUser;
    }
}


#pragma mark - PIRLoginViewDelegate methods

-(void)loginView:(PIRLoginView*)view didSignIn:(NSString*)userName passcode:(NSString*)passcode
{
    DLog(@"didSignIn");

    self.progressView.titleLabelText = NSLocalizedString(@"Signing in...", nil);
    [self.progressView show:YES];
    [self.view.superview addSubview:self.progressView];
    
    [[PIRUserServices sharedService] signIn:userName passcode:passcode success:^{
        [self processSignInSuccess];
        
    } error:^(NSError *error) {
        [self processSignInError:error];
    }];
}

#pragma mark - didSignIn helper methods

-(void)processSignInSuccess
{
    [self updateCurrency];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.titleLabelText = NSLocalizedString(@"Welcome back!", nil);
        self.progressView.mode = MRProgressOverlayViewModeCheckmark;
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView dismiss:YES];
            
            PIRMenuTabBarController * menuController = [PIRMenuTabBarController new];
            
            [UIView
             transitionWithView:[[[UIApplication sharedApplication] delegate] window]
             duration:0.4
             options:UIViewAnimationOptionTransitionCrossDissolve
             animations:^(void) {
                 BOOL oldState = [UIView areAnimationsEnabled];
                 [UIView setAnimationsEnabled:NO];
                 [[[UIApplication sharedApplication] delegate] window].rootViewController = menuController;
                 [UIView setAnimationsEnabled:oldState];
             }
             completion:nil];
            
            
            
        });
    });
}

- (void)updateCurrency
{
    [[PIRTransactionServices sharedService] refreshCNYtoUSDExchangeRate:^(NSNumber *exchange) {
        // don't need this for now
    } error:^(NSError *error) {
        // ignore
    }];
    
}

- (void)processSignInError:(NSError*)error
{
    DLog(@"login not successful");
    NSString *errorString = nil;
    if (error.code == PIRUserServicesErrorCodeInvalidUsernameOrPasscode){
        errorString = NSLocalizedString(@"Username or passcode incorrect. Please try again.", nil);
    }else{
        errorString = NSLocalizedString(@"An error occurred. Please try again later.", nil);
    }
    
    NSDictionary *errorDict = error.userInfo;
    NSString *errorStringFromServer = errorDict[@"serverMessage"];
    errorStringFromServer = errorStringFromServer?errorStringFromServer:@"";
    
    NSString *errorStringFull = [NSString stringWithFormat:@"%@. %@", errorString, errorStringFromServer];
    
    self.progressView.titleLabelText = errorStringFull;
    self.progressView.mode = MRProgressOverlayViewModeCross;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.progressView dismiss:YES];
    });
}

#pragma mark - PIRRegisterViewDelegate methods

-(void)registerView:(PIRRegisterView*)view didRegisterWithFacebook:(BOOL)login
{
    MRProgressOverlayView * progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = NSLocalizedString(@"Signing in...", nil);
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view.superview addSubview:progressView];
    [progressView show:YES];
    
    
    __weak PIRLoginViewController * weakSelf = self;
    [[PIRUserServices sharedService] retriveOwnFacebookProfile:^(NSDictionary *userDict) {
        
        [progressView dismiss:YES];
        //progressView should be removed from superView
        [progressView removeFromSuperview];
        
        // successful login
        DLog(@"login successful");
        
        // get data from facebook profile
        PIRSocialAccount * facebookAccount = [PIRSocialAccount createInContext:[NSManagedObjectContext defaultContext]];
        facebookAccount.type = @(PIRSocialAccountTypeFacebook);
        facebookAccount.userID = userDict[@"id"];
        facebookAccount.status = @(PIRSocialAccountStatusActive);
        
        PIRUser * user = [PIRUser createInContext:[NSManagedObjectContext defaultContext]];
        user.isMe = @(YES);
        user.firstName = userDict[@"first_name"];
        user.lastName = userDict[@"last_name"];
        user.thumbnailURL = userDict[@"picture"][@"data"][@"url"];
        user.email = userDict[@"email"];
        [user addSocialAccountsObject:facebookAccount];
        
        // backfill phone number from address book
        NSDictionary * userInfoFromAddressBook = [[PIRUserServices sharedService] lookupOwnUserInfoFromAddressBook];
        if (userInfoFromAddressBook) {
            if (userInfoFromAddressBook[@"phoneNumbers"]) {
                user.phoneNumber = userInfoFromAddressBook[@"phoneNumbers"];
            }
        }
        
        PIRRegisterViewController *signUpController = [PIRRegisterViewController new];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:signUpController animated:YES];
        });
        
    } error:^(NSError *error) {
        
        [progressView dismiss:YES];
        [progressView removeFromSuperview];
        // facebook not set up
        
        if (error.code == PIRUserServicesErrorCodeFacebookSetupError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AlertViewCallback callBack = ^(NSUInteger buttonSelectedIndex, BOOL isCanceledButtonTapped) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                };
                NSString * message = NSLocalizedString(@"We weren't able to login with Facebook. Please check your account settings in Settings > Facebook", nil);
                PIRAlertViewViewController * alertVC = [[PIRAlertViewViewController alloc] initWithTitle:@"Login Failed" desc:message buttonsLabels:nil completion:callBack];
                [weakSelf presentViewController:alertVC animated:NO completion:nil];
            });
            
        }
    }];
}

-(void)registerView:(PIRRegisterView*)view didRegisterWithTencent:(BOOL)login
{
    MRProgressOverlayView * progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = NSLocalizedString(@"Signing in...", nil);
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view.superview addSubview:progressView];
    [progressView show:YES];
    
    
    __weak PIRLoginViewController * weakSelf = self;
    [[PIRUserServices sharedService] retriveOwnTencentProfile:^(NSDictionary *userDict) {
        
        [progressView dismiss:YES];
        //progressView should be removed from superView
        [progressView removeFromSuperview];
        
        // successful login
        DLog(@"login successful");
        
        DLog(@"%@",userDict);
        // get data from sinaWeibo profile
        PIRSocialAccount * tencentWeiboAccount = [PIRSocialAccount createInContext:[NSManagedObjectContext defaultContext]];
        tencentWeiboAccount.type = @(PIRSocialAccountTypeTencent);
        tencentWeiboAccount.userID = userDict[@"data"][@"openid"];
        tencentWeiboAccount.status = @(PIRSocialAccountStatusActive);
        
        PIRUser * user = [PIRUser createInContext:[NSManagedObjectContext defaultContext]];
        user.isMe = @(YES);
        user.firstName = userDict[@"data"][@"nick"];
        user.lastName = userDict[@"data"][@"nick"];
        user.thumbnailURL = userDict[@"data"][@"head"];
        user.email = userDict[@"email"];
        [user addSocialAccountsObject:tencentWeiboAccount];
        
        // backfill phone number from address book
        NSDictionary * userInfoFromAddressBook = [[PIRUserServices sharedService] lookupOwnUserInfoFromAddressBook];
        if (userInfoFromAddressBook) {
            if (userInfoFromAddressBook[@"phoneNumbers"]) {
                user.phoneNumber = userInfoFromAddressBook[@"phoneNumbers"];
            }
        }
        
        PIRRegisterViewController *signUpController = [PIRRegisterViewController new];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:signUpController animated:YES];
        });
        
    } error:^(NSError *error) {
        
        [progressView dismiss:YES];
        [progressView removeFromSuperview];
        // tencentWeibo not set up
        
        if (error.code == PIRUserServicesErrorCodeTencentWeiboSetupError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AlertViewCallback callBack = ^(NSUInteger buttonSelectedIndex, BOOL isCanceledButtonTapped) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                };
                NSString * message = NSLocalizedString(@"We weren't able to login with TencentWeibo. Please check your account settings in Settings > Tencent", nil);
                PIRAlertViewViewController * alertVC = [[PIRAlertViewViewController alloc] initWithTitle:@"Login Failed" desc:message buttonsLabels:nil completion:callBack];
                [weakSelf presentViewController:alertVC animated:NO completion:nil];
            });
            
        }
    }];
}

-(void)registerView:(PIRRegisterView*)view didRegisterWithSina:(BOOL)login
{
    MRProgressOverlayView * progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = NSLocalizedString(@"Signing in...", nil);
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view.superview addSubview:progressView];
    [progressView show:YES];
    
    
    __weak PIRLoginViewController * weakSelf = self;
    [[PIRUserServices sharedService] retriveOwnSinaProfile:^(NSDictionary *userDict) {
        
        [progressView dismiss:YES];
        //progressView should be removed from superView
        [progressView removeFromSuperview];
        
        // successful login
        DLog(@"login successful");
        
        DLog(@"%@",userDict);
        // get data from sinaWeibo profile
        PIRSocialAccount * sinaWeiboAccount = [PIRSocialAccount createInContext:[NSManagedObjectContext defaultContext]];
        sinaWeiboAccount.type = @(PIRSocialAccountTypeSina);
        sinaWeiboAccount.userID = userDict[@"idstr"];
        sinaWeiboAccount.status = @(PIRSocialAccountStatusActive);
        
        PIRUser * user = [PIRUser createInContext:[NSManagedObjectContext defaultContext]];
        user.isMe = @(YES);
        user.firstName = userDict[@"screen_name"];
        user.lastName = userDict[@"screen_name"];
        user.thumbnailURL = userDict[@"avatar_hd"];
        user.email = userDict[@"email"];
        [user addSocialAccountsObject:sinaWeiboAccount];
        
        // backfill phone number from address book
        NSDictionary * userInfoFromAddressBook = [[PIRUserServices sharedService] lookupOwnUserInfoFromAddressBook];
        if (userInfoFromAddressBook) {
            if (userInfoFromAddressBook[@"phoneNumbers"]) {
                user.phoneNumber = userInfoFromAddressBook[@"phoneNumbers"];
            }
        }
        
        PIRRegisterViewController *signUpController = [PIRRegisterViewController new];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:signUpController animated:YES];
        });
        
    } error:^(NSError *error) {
        
        [progressView dismiss:YES];
        [progressView removeFromSuperview];
        // sinaWeibo not set up
        
        if (error.code == PIRUserServicesErrorCodeSinaWeiboSetupError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AlertViewCallback callBack = ^(NSUInteger buttonSelectedIndex, BOOL isCanceledButtonTapped) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                };
                NSString * message = NSLocalizedString(@"We weren't able to login with SinaWeibo. Please check your account settings in Settings > SinaWeibo", nil);
                PIRAlertViewViewController * alertVC = [[PIRAlertViewViewController alloc] initWithTitle:@"Login Failed" desc:message buttonsLabels:nil completion:callBack];
                [weakSelf presentViewController:alertVC animated:NO completion:nil];
            });
            
        }
    }];
}

-(void)registerView:(PIRRegisterView*)view didRegisterWithEmail:(BOOL)login
{
//    __weak PIRLoginViewController * weakSelf = self;
//    PIRUser * user = nil;
//    
//    // attempt to get user info from address book
//    NSDictionary * userInfoFromAddressBook = [[PIRUserServices sharedService] lookupOwnUserInfoFromAddressBook];
//    user = [PIRUser createInContext:[NSManagedObjectContext defaultContext]];
//    user.isMe = @(YES);
//    if (userInfoFromAddressBook) {
//        user.phoneNumber = userInfoFromAddressBook[@"phoneNumbers"];
//        user.firstName = userInfoFromAddressBook[@"firstName"];
//        user.lastName = userInfoFromAddressBook[@"lastName"];
//    }
    PIRRegisterViewController *signUpController = [PIRRegisterViewController new];
    [self.navigationController pushViewController:signUpController animated:YES];
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger offset = (NSInteger)scrollView.contentOffset.x;
    switch (offset) {
        case 0:
            self.pageControl.currentPage = 0;
            break;
        case 320:
            self.pageControl.currentPage = 1;
            break;
        case 640:
            self.pageControl.currentPage = 2;
            break;
        default:
            self.pageControl.currentPage = 0;
            break;
    }
}

#pragma mark - Event Handler methods

#pragma mark - PIRVerifyAccountViewDelegate methods

-(void)verifyAccountView:(PIRVerifyAccountView*)view verifyPhone:(NSString*)phoneVerifyCode verifyEmail:(NSString*)emailVerifyCode
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
