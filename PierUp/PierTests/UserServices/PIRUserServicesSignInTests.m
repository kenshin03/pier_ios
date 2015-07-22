//
//  PIRUserServicesSignInTests.m

//
//  Created by Kenny Tang on 2/17/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PIRTests.h"
#import "PIRAccessTokens.h"
#import "PIRDeviceTokens.h"
#import "PIRUserServices.h"
#import "PIRUserServices+Private.h"

@interface PIRUserServicesSignInTests : PIRTests

@property (nonatomic, strong) PIRUserServices *sharedService;

@end

@implementation PIRUserServicesSignInTests

- (void)setUp
{
    [super setUp];
    [self setUpCurrentUser];
    [self setUpUserService];
    [self setUpUserServiceTestData];
}

- (void)setUpCurrentUser
{
    NSString *userName = @"user22";
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:userName forKey:@"userName"];
    [standardUserDefaults synchronize];
    
    [PIRUser truncateAll];
}

- (void)setUpUserService
{
    self.sharedService = [PIRUserServices sharedService];
    self.sharedService.sessionManager = nil; // use mock session manager
}

- (void)setUpUserServiceTestData
{
    NSDictionary *mockInputSuccess = @{@"device_token": @"",
                                       @"username": @"testUser",
                                       @"password": @"testPassword",
                                       @"platform": @"API",
                                       };
    NSDictionary *mockInputFailed = @{@"device_token": @"",
                                      @"username": @"testUser",
                                      @"password": @"wrongPassword",
                                      @"platform": @"API",
                                      };
    
    // sucess login
    id mockSessionManager = [OCMockObject mockForClass:[PIRHTTPSessionManager class]];
    [[mockSessionManager expect] POST:@"/user/login"
                           parameters:mockInputSuccess
                              success:[OCMArg checkWithBlock:^BOOL(void (^successBlock)(NSURLSessionDataTask *, NSDictionary *))
                                       {
                                           NSDictionary *successDict = @{@"success": @"1",
                                                                         @"body"   : @{@"id"           : @"testUserID",
                                                                                       @"accessToken"  : @{@"value": @"successAccessToken",
                                                                                                           @"expirationDate": @""},
                                                                                       @"deviceToken"  : @{@"value": @"successDeviceToken"}
                                                                                       }
                                                                         };
                                           
                                           successBlock(nil, successDict);
                                           return YES;
                                           
                                       }] failure:OCMOCK_ANY];
    
    // failed login
    [[mockSessionManager expect] POST:@"/user/login"
                           parameters:mockInputFailed
                              success:[OCMArg checkWithBlock:^BOOL(void (^successBlock)(NSURLSessionDataTask *, NSDictionary *))
                                       {
                                           NSDictionary *failedDict = @{@"success": @(false),
                                                                        @"body"   : @{@"sessionResultCode" : @"USER_NOT_EXIST",
                                                                                      @"result"            : @""
                                                                                      }
                                                                        };
                                           
                                           successBlock(nil, failedDict);
                                           return YES;
                                           
                                       }] failure:OCMOCK_ANY];
    
    
    self.sharedService.sessionManager = mockSessionManager;
}



- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void)testSignInSuccess
{
    NSString *userName = @"testUser";
    NSString *passCode = @"testPassword";
    
    __block BOOL waitingForBlock = YES;
    
    [self.sharedService signIn:userName passcode:passCode success:^{
        
        PIRUser *currentUser = [self.sharedService currentUser];
        PIRAccessTokens *accessTokens = currentUser.accessTokens;
        PIRDeviceTokens *deviceTokens = currentUser.deviceTokens;
        
        // hack to give enough time for Test Suite to finish
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            waitingForBlock = NO;
        });
        
        XCTAssertEqual(accessTokens.accessToken, @"successAccessToken");
        XCTAssertEqual(deviceTokens.deviceToken, @"successDeviceToken");
        
    } error:^(NSError *error) {
        XCTFail(@"testSignInSuccess should succeed with user %@ and passcode %@", userName, passCode);
    }];
    
    
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
}


-(void)testSignInFailed
{
    NSString *userName = @"testUser";
    NSString *passCode = @"wrongPassword";
    __block BOOL waitingForBlock = YES;
    
    [self.sharedService signIn:userName passcode:passCode success:^{
        
        XCTFail(@"testSignInFailed should fail with user %@ and passcode %@", userName, passCode);
        
    } error:^(NSError *error) {
        
        // hack to give enough time for Test Suite to finish
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            waitingForBlock = NO;
        });
        
        XCTAssertNotNil(error, @"Error object should not be nil");
    }];
    
    
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
}


@end
