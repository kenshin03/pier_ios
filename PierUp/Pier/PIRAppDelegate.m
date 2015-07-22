//
//  PIRAppDelegate.m

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRAppDelegate.h"

#import "MRProgressOverlayView.h"

// urban airship
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "PIRLoginViewController.h"
#import "PIRMenuTabBarController.h"
#import "PIRPeerConnectivity.h"
#import "PIRPushNotificationTokens.h"
#import "PIRUser+Extensions.h"
#import "PIRUserServices.h"
#import "PIRValidatorUtil.h"
#import "PIRTransactionServices.h"
#import "PIRBeaconServices.h"

@interface PIRAppDelegate()<
UITabBarControllerDelegate
>

@property (strong, nonatomic) UINavigationController * loginNavController;
@property (strong, nonatomic) PIRMenuTabBarController * tabBarController;

// this is needed as user might not have registered for an account yet
@property (strong, nonatomic) NSString * pushNotificationToken;

@end


@implementation PIRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [PIRColor defaultTintColor];
    [self customizeAppearance];
    [self setUpCoreDataStack];
    [self setUpUrbanAirship];
    [self setUpAFNetworking];
    
    // if no current user saved, proceed to login
    UIViewController * rootViewController = nil;
//    if ([[PIRUserServices sharedService] currentUser]) {
//        rootViewController = self.tabBarController;
//    } else {
        rootViewController = self.loginNavController;
//    }
    self.window.rootViewController  = rootViewController;
    [self.window makeKeyAndVisible];
    
    [self refreshCNYUSDExchangeRates];
    [self startBroadcastBeacon];
    [self setUpBackgroundFetch];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[PIRBeaconServices sharedInstance] stopRangingBeacon];
    [[PIRUserServices sharedService] signOut];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PIRUserServices sharedService] signOut];
    
}
#pragma mark - Private 

#pragma mark - Private properties

- (UITabBarController *)tabBarController
{
    if (!_tabBarController) {
        
        // Create tab bar controller.
        _tabBarController = [PIRMenuTabBarController new];
        _tabBarController.delegate = self;
    }
    return _tabBarController;
}

- (UINavigationController *)loginNavController
{
    if (!_loginNavController) {
        _loginNavController = [[UINavigationController alloc] initWithRootViewController:[PIRLoginViewController new]];
    }
    return _loginNavController;
}



#pragma mark - Appearance customize

- (void)customizeAppearance
{
    [self customizeNavBarAppearance];
    [self customizeStatusBarAppearance];
    [self customizeTabBarAppearance];
}

- (void)customizeStatusBarAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)customizeNavBarAppearance
{
    id navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [PIRColor navigationBarTitleColor],
       NSFontAttributeName: [PIRFont navigationBarTitleFont]
       }];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    [navigationBarAppearance setBarTintColor:[PIRColor navigationBarBackgroundColor]];
}

- (void)customizeTabBarAppearance
{
    [[UITabBar appearance] setTintColor:[PIRColor defaultTintColor]];
}

#pragma mark - process notifications

- (void)processReceivedPaymentRequest:(NSNotification *)paramNotification
{
    NSDictionary * requestDict = (NSDictionary*)[paramNotification userInfo];
    CGFloat amount = [requestDict[@"amount"] floatValue];
    NSString * fromName = requestDict[@"from"][@"name"];
    NSString * message = [NSString stringWithFormat:@"%@ wants to send you $%.2f. Accept?",
                          fromName, amount];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{

        UIViewController * topMostVC = [[[self.tabBarController.viewControllers lastObject] viewControllers] lastObject];
        AlertViewCallback callBack = ^(NSUInteger buttonSelectedIndex, BOOL isCanceledButtonTapped) {
            [topMostVC dismissViewControllerAnimated:NO completion:^{
                //
            }];
        };
        PIRAlertViewViewController * alertVC = [[PIRAlertViewViewController alloc] initWithTitle:@"Payment Request" desc:message buttonsLabels:nil completion:callBack];
        [topMostVC presentViewController:alertVC animated:NO completion:nil];
        
    });
    
/*
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Payment Request"
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"Ignore"
                                               otherButtonTitles:@"Yes, accept.", nil];
        [alertView show];
        
        [[PIRPeerConnectivity sharedInstance] sendAcceptPaymentRequestToPeer:fromName];
        
    });
*/
}
#pragma mark - coredata stack

- (void)setUpCoreDataStack
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"sqlite"];
    
}

#pragma mark - urban airship set up methods

- (void)setUpUrbanAirship
{
//    double delayInSeconds = 4.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UAConfig *config = [UAConfig defaultConfig];
        [UAirship takeOff:config];
        [[UAPush shared] resetBadge];
        
        // Request a custom set of notification types
        [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert);
//    });
    
}

- (void)setUpAFNetworking
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

- (void)refreshCNYUSDExchangeRates
{
}

#pragma mark - remote notifications handling

// this gets invoked when app is running in foreground
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    DLog(@"WOW: didReceiveRemoteNotification! %@", userInfo);
    // process notification
    [self processRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)tokenData
{
    NSString * tokenString = [self parseDeviceToken:[tokenData description]];
    [self processNewRemoteNotificationDeviceToken:tokenString];
}

#pragma mark - remote notifications handling helpers

- (void)processRemoteNotification:(NSDictionary*)info
{
    // to-do: define push notification types
    NSDictionary * apsInfo = info[@"aps"];
    NSString * requestType = apsInfo[@"requestType"];
    if ([requestType isEqualToString:@"update_profile"]) {
        [self processUpdateUserNotification:apsInfo];
        
    }else if ([requestType isEqualToString:@"pay_request"]) {
        [self processPayRequestNotification:apsInfo];
    }
}

- (void)processUpdateUserNotification:(NSDictionary*)info
{
    // parse expected params
    NSString * userID = info[@"data"][@"userID"];
    NSString * status = [info[@"data"][@"status"] stringValue];
    if ([userID length] && [status length]) {
        if ([PIRValidatorUtil validateUserStatus:status]){
            PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
// to-do: uncomment when webservice is ready
//            if ([currentUser.pierID isEqualToString:userID]){
                currentUser.status = @([status integerValue]);
                [[PIRUserServices sharedService] updateCurrentUser:currentUser];
                [[NSNotificationCenter defaultCenter] postNotificationName:kPIRConstantsProfileUpdatedNotification object:self];
//            }
        }
    }
}

- (void)processPayRequestNotification:(NSDictionary*)info
{
    // parse expected params
    NSDictionary *data = info[@"data"];
    
    NSNumber *amont = data[@"amount"];
    NSString *fromUserID = data[@"fromUserID"];
    NSString *fromUserName = data[@"fromUserName"];
    NSString *notes = data[@"notes"];
    NSString *transactionID = data[@"transactionID"];
    
    //to-do: validation
    
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    
    PIRTransaction *transaction = [PIRTransaction createEntity];
    transaction.amount = [[NSDecimalNumber alloc] initWithFloat:[amont floatValue]];
    
    PIRUser *fromUser = [PIRUser createEntity];
    fromUser.pierID = fromUserID;
    fromUser.userName = fromUserName;
    transaction.fromUser = fromUser;
    
    transaction.notes = notes;
    
    transaction.toUser = currentUser;
    
    transaction.transactionID = transactionID;
    transaction.created = nil;
    transaction.timestamp = nil;
    [currentUser addReceivedTransactionsObject:transaction];
    
    [[PIRTransactionServices sharedService] addReceivedPayment:transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPIRConstantsTransactionsReceivedNotification object:self];
    
    NSString *amountString = [NSString stringWithFormat:@"$%.2f", [transaction.amount floatValue]];
    NSString *receivedPaymemtMessage = [NSString stringWithFormat:@"%@ has sent you %@.", fromUserName, amountString];
    MRProgressOverlayView * progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = receivedPaymemtMessage;
    progressView.mode = MRProgressOverlayViewModeCheckmark;
    [self.window addSubview:progressView];
    [progressView show:YES];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [progressView dismiss:YES];
    });
    
}

- (void)processNewRemoteNotificationDeviceToken:(NSString*)tokenString
{
    self.pushNotificationToken = tokenString;
    if ([[PIRUserServices sharedService] currentUser]) {
        // user is registered, update push token
        PIRUser * user = [[PIRUserServices sharedService] currentUser];
        
        PIRPushNotificationTokens * token = [PIRPushNotificationTokens createEntity];
        token.token = tokenString;
        [user addPushNotificationTokensObject:token];
        [[PIRUserServices sharedService] updateCurrentUser:user];
    }
    
}

- (NSString*)parseDeviceToken:(NSString*)tokenStr
{
    return [[[tokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""]
             stringByReplacingOccurrencesOfString:@">" withString:@""]
            stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - multipeer api advertiser service

- (void)startBroadcastBeacon
{
    PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
    if (currentUser) {
        [[PIRBeaconServices sharedInstance] startBroadcastBeacon];
    }
    
}

#pragma mark - background fetch related methods

- (void)setUpBackgroundFetch
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    __block UIBackgroundFetchResult fetchResult = UIBackgroundFetchResultFailed;
    
    // do data fetch here
    [[PIRUserServices sharedService] updateCurrentUserFromServer:^{
        DLog(@"updateCurrentUserFromServer");
        fetchResult = UIBackgroundFetchResultNewData;
        completionHandler(fetchResult);
        
    } error:^(NSError *error) {
        ELog(@"Error in updateCurrentUserFromServer in background:%@", error);
        fetchResult = UIBackgroundFetchResultFailed;
        completionHandler(fetchResult);
        
    }];
    
}

@end
