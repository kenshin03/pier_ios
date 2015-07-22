//
//  PIRUserServices.m

//
//  Created by Kenny Tang on 12/19/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRUserServices.h"
#import "PIRUserServices+Private.h"
@import Social;
@import Accounts;
#import <NSData+Base64.h>
#import <ABContactsHelper.h>
#import "NSDictionary+jsonString.h"
#import "PIRHTTPSessionManager.h"
#import "PIRHTTPSessionManager2.h"
#import "PIRAccessTokens.h"
#import "PIRDeviceTokens.h"
#import "PIRSocialAccount.h"
#import "PIRPushNotificationTokens.h"


NSString *const kPIRUserServicesErrorCodesDomain = @"UserServicesErrorCodesDomain";


@interface PIRUserServices()

@property (nonatomic, strong) ACAccountStore * accountStore;
@property (nonatomic, strong) ACAccount * facebookAccount;
@property (nonatomic, strong) ACAccount * sinaWeiboAccount;
@property (nonatomic, strong) ACAccount * tencentWeiboAccount;
@property (nonatomic, strong) NSTimer *refreshLoginTimer;
@end

NSString *const kAddBankURL                 =   @"/services/bankaccount/add";
NSString *const kSubmitBankVerificationURL  =   @"/services/verify/submitBankVerification";

NSString *const kRemoveBankURL      =   @"/services/bankaccount/deactivate";
NSString *const kVerifyBankURL      =   @"/services/verify/bank";

NSString *const kSignInURL          =   @"/user/login";
NSString *const kSignoutURL         =   @"/user/%@/logout";
NSString *const kUpdatePhotoURL     =   @"/user/%@/photo";


NSString *const kUpdatePushTokenURL      = @"/user/%@/push-token";
NSString *const kRetrievePushTokenURL    = @"/user/%@/push-token";

NSString *const kVerifyUserURL     =   @"/user/%@/verify";

NSString *const kUpdateUserURL      = @"/user/%@/update";
NSString *const kRetrieveUserURL    = @"/user/%@/info";
NSString *const kRegisterUserURL    = @"user/register";
NSString *const kPIRFacebookAppID   = @"164631917050081";
NSString *const kPIRTencentWeiboAppID = @"801469466";

@implementation PIRUserServices

#pragma mark - Public

+ (instancetype) sharedService {
    static PIRUserServices * singleton = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
        // by default use the "real" session manager
        singleton.sessionManager = [PIRHTTPSessionManager sharedInstance];
    });
    return singleton;
}

#pragma mark - Initialization

#pragma mark - Public methods

- (PIRUser*)currentUser
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [standardUserDefaults objectForKey:@"userName"];
    NSPredicate *predicate = nil;
    if ([userName length]){
        predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName?userName:@""];
//    }else{
//        predicate = [NSPredicate predicateWithFormat:@"isMe = %@", @(1)];
    }
    PIRUser * currentUser = [PIRUser findFirstWithPredicate:predicate];
    return currentUser;
}


- (void)updateCurrentUser:(PIRUser*)user
{
    // 1. save to server first
    [self updateUserToBackend:user];
    
    // 2. save to local
    [self saveContextSynchronously:nil];
}

- (void)updatePushNotificationTokenToServer:(PIRUser*)user token:(NSString*)token
{
    NSString * updateTokenURLString = [NSString stringWithFormat:kUpdatePushTokenURL, user.pierID];
    NSDictionary *tokensDict = [super requestTokens];
    NSDictionary * updateUserDict = @{
                                      @"userId"         : user.pierID?user.pierID:@"",
                                      @"push_token"     : token?token:@"",
                                      };
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tokensDict];
    [params addEntriesFromDictionary:updateUserDict];
    [self.sessionManager POST:updateTokenURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // to-do: check responseobject
        
        NSLog(@"responseObject: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // to-do: handle failure
        ELog(@"Error: %@", task.response);
    }];
    
}

- (void)updatePushNotificationTokenFromServer
{
    PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
    NSString * retrieveUserURLString = [NSString stringWithFormat:kRetrievePushTokenURL, currentUser.pierID];
    NSDictionary *params = [super requestTokens];
    
    [[PIRHTTPSessionManager sharedInstance] GET:retrieveUserURLString
                                     parameters:params success:^(NSURLSessionDataTask *task, NSDictionary * JSON) {
                                         DLog(@"responseObject: %@", JSON);
                                         /*
                                          body =     {
                                          attrs = "";
                                          countryCode = US;
                                          createdOn = "2014-01-22";
                                          email = "user70@gmail.com";
                                          facebookId = "<null>";
                                          firstName = Kenny;
                                          iBeaconVisibility = 0;
                                          id = U00000000055;
                                          imageUrl = "<null>";
                                          lastLogin = "<null>";
                                          lastName = Tang;
                                          lastUpdated = "<null>";
                                          password = "<null>";
                                          phone = 42342421;
                                          prefix = "Mr.";
                                          socialAttrs = "{\"accounts\":[{\"userID\":\"572733568\",\"type\":0,\"status\":1}]}";
                                          status = ACTIVE;
                                          username = user70;
                                          };
                                          success = 1;
                                          }
                                          */
                                         if (JSON[@"body"]){
                                             NSDictionary * bodyDict = JSON[@"body"];
                                             NSNumber * isSuccess = JSON[@"success"];
                                             if ([isSuccess integerValue] == 1){
                                                 
                                                 NSString * countryCode = bodyDict[@"countryCode"];
                                                 NSString * email = bodyDict[@"email"];
                                                 NSString * firstName = bodyDict[@"firstName"];
                                                 NSString * lastName = bodyDict[@"lastName"];
                                                 NSString * phone = bodyDict[@"phone"];
                                                 NSString * prefix = bodyDict[@"prefix"];
                                                 //                                                 NSString * socialAttrs = bodyDict[@"socialAttrs"];
                                                 NSNumber * visibility = bodyDict[@"iBeaconVisibility"];
                                                 NSString * status = bodyDict[@"status"];
                                                 
                                                 currentUser.country = countryCode;
                                                 currentUser.email = email;
                                                 currentUser.firstName = firstName;
                                                 currentUser.lastName = lastName;
                                                 currentUser.phoneNumber = phone;
                                                 currentUser.prefix = prefix;
                                                 currentUser.visibilityOptions = visibility;
                                                 // to-do: parse social attrs
                                                 if ([status isEqualToString:@"ACTIVE"]){
                                                     currentUser.status = @(PIRUserStatusActive);
                                                 }else if ([status isEqualToString:@"INACTIVE"]){
                                                     currentUser.status = @(PIRUserStatusInactive);
                                                     
                                                 }else if ([status isEqualToString:@"LOCKED"]){
                                                     currentUser.status = @(PIRUserStatusLocked);
                                                     
                                                 }else if ([status isEqualToString:@"UNKNOWN"]){
                                                     currentUser.status = @(PIRUserStatusPendingVerification);
                                                 }
                                                 
                                                 // to-do: update user data, save to core data
                                                 [self saveContextSynchronously:^{
                                                     // client callback
                                                 }];
                                                 
                                             }else{
                                                 // handle error
                                             }
                                         }
                                         
                                         
                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         //                                         errorCallBack(error);
                                         // to-do: handle error
                                     }];
}


- (void)registerUser:(PIRUser*)user success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    
    NSDictionary * registerUserDict = @{
                                      @"username"           : user.userName,
                                      @"prefix"             : user.prefix?user.prefix:@"",
                                      @"first_name"          : user.firstName,
                                      @"last_name"           : user.lastName,
                                      @"password"           : user.passCode,
                                      @"email"              : user.email,
                                      @"phone"              : user.phoneNumber,
                                      @"country_code"        : user.country?user.country:@"",
                                      @"visibility_status"   : user.visibilityOptions?user.visibilityOptions:@(PIRVisibilityOptionsPierUsers),
                                      @"platform"           : @"API",
                                      @"social_attrs"    : [self socialAccountToJSON:user],
                                      };
    
    [[PIRHTTPSessionManager sharedInstance] POST:kRegisterUserURL parameters:registerUserDict success:^(NSURLSessionDataTask *task, id JSON) {
        DLog(@"responseObject: %@", JSON);
        
        // get token, save to coredata
        BOOL status = [JSON[@"success"] boolValue];
        if (status) {
            NSDictionary *bodyDict = JSON[@"body"];
            NSString *userId = bodyDict[@"id"];
            
            NSDictionary *accessTokenDict = bodyDict[@"accessToken"];
            NSString *token = accessTokenDict[@"value"];
            NSNumber *tokenExpiration = accessTokenDict[@"expirationDate"];
            
            NSDictionary *deviceTokenDict = bodyDict[@"deviceToken"];
            NSString *deviceToken = deviceTokenDict[@"value"];
            
            if (![userId length]){
                ELog(@"error :%@", task.response);
                errorCallBack(nil);
                return;
            }
            
            // to-do: replace local thumbnailURL with Pier thumbnail URL
            
            // userID
            user.pierID = userId;
            
            // access Tokens
            PIRAccessTokens *accessTokens = [PIRAccessTokens createEntity];
            accessTokens.accessToken = token;
            accessTokens.accessTokenExpiration = [NSDate dateWithTimeIntervalSince1970:[tokenExpiration doubleValue]];
            accessTokens.user = user;
            user.accessTokens = accessTokens;
            
            // device Tokens
            PIRDeviceTokens *deviceTokens = [PIRDeviceTokens createEntity];
            deviceTokens.deviceToken = deviceToken;
            deviceTokens.user = user;
            user.deviceTokens = deviceTokens;
            
            user.status = @(PIRUserStatusPendingVerification);
            
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setObject:user.userName forKey:@"userName"];
            [standardUserDefaults synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveContextSynchronously:^{
                    
                    if (user.thumbnailImage){
                        [self updateUserPhoto:user success:^{
                            
                            success();
                            
                        } error:^(NSError *error) {
                            errorCallBack(error);
                        }];
                        
                    }


                    DLog(@"saved synchonously done.");
                    success();
                    
                }];
            });
            
        }else{
            
            ELog(@"error :%@", task.response);
            NSError * error = nil;
            
            NSDictionary *bodyDict = JSON[@"body"];
            NSString *sessionResultCode = bodyDict[@"sessionResultCode"];
            if ([sessionResultCode isEqualToString:@"PHONE_OR_EMAIL_EXISTED"]){
                error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodePierEmailPhoneExisted userInfo:nil];
            }else if ([sessionResultCode isEqualToString:@"USER_EXISTED"]){
                error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodePierUserNameExisted userInfo:nil];
            }
            errorCallBack(error);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ELog(@"error :%@", task.response);
        errorCallBack(error);
    }];
    
}


- (void)updateUserPhoto:(PIRUser*)user success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    NSData * profileImageData = nil;
    NSString * profileImageBase64Encoded = @"";
    if ([user.thumbnailURL length]) {
        profileImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.thumbnailURL]];
        profileImageBase64Encoded = [profileImageData base64EncodedString];
    } else if (user.thumbnailImage) {
        profileImageData = UIImagePNGRepresentation(user.thumbnailImage);
        profileImageBase64Encoded = [profileImageData base64EncodedString];
    }
    
    NSMutableDictionary *paramsDict = [[super requestTokens] mutableCopy];
    NSDictionary * updatePhotosDict = @{
                                        @"userId"           : user.pierID,
                                        @"file_type"         : @"png",
                                        };
    [paramsDict addEntriesFromDictionary:updatePhotosDict];
    
    NSString *updatePhotoURL = [NSString stringWithFormat:kUpdatePhotoURL, user.pierID];
    
    [[PIRHTTPSessionManager sharedInstance] POST:updatePhotoURL parameters:paramsDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:profileImageData name:@"image" fileName:user.pierID mimeType:@"image/png"];
        
    }success:^(NSURLSessionDataTask *task, id JSON) {
        DLog(@"responseObject: %@", JSON);
        
        BOOL status = [JSON[@"success"] boolValue];
        if (status) {
            // profileURL
            NSString *imageURL = JSON[@"body"];
            user.thumbnailURL = imageURL;
            user.thumbnailImage = nil;
        }
        [self saveContextSynchronously:^{
            success();
        }];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ELog(@"error :%@", task.response);
        errorCallBack(error);
    }];
    
}


- (void)retriveOwnFacebookProfile:(void(^)(NSDictionary* userDict))success error:(void(^)(NSError* error))errorBlock
{
    [self requestFacebookAccountAccess:^(NSError *error) {
        if (!error) {
            [self fetchOwnFacebookProfile:^(NSDictionary *userInfo, NSError *error) {
                
                DLog(@"fetched facebook profile: %@", userInfo);
                
                success(userInfo);
            }];
        }else{
            NSError * error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodeFacebookSetupError userInfo:nil];
            errorBlock(error);
        }
    }];
}
- (void)retriveOwnSinaProfile:(void(^)(NSDictionary* userDict))success error:(void(^)(NSError* error))errorBlock
{
    [self requestSinaAccountAccess:^(NSError *error) {
        if (!error && self.sinaWeiboAccount) {
            [self fetchOwnSinaProfile:
             ^(NSDictionary *userInfo, NSError *error) {
                
                DLog(@"fetched SinaWeibo profile: %@", userInfo);
                 /*{
                     "allow_all_act_msg" = 0;
                     "allow_all_comment" = 1;
                     "avatar_hd" = "http://tp4.sinaimg.cn/3973782139/180/0/1";
                     "avatar_large" = "http://tp4.sinaimg.cn/3973782139/180/0/1";
                     "bi_followers_count" = 0;
                     "block_word" = 0;
                     city = 9;
                     class = 1;
                     "created_at" = "Sun Jan 12 14:57:28 +0800 2014";
                     description = "";
                     domain = "";
                     "favourites_count" = 0;
                     "follow_me" = 0;
                     "followers_count" = 3;
                     following = 0;
                     "friends_count" = 12;
                     gender = m;
                     "geo_enabled" = 1;
                     id = 3973782139;
                     idstr = 3973782139;
                     lang = "zh-cn";
                     location = "\U6c5f\U897f \U5b9c\U6625";
                     mbrank = 0;
                     mbtype = 0;
                     name = 15668689926sxl;
                     "online_status" = 0;
                     "profile_image_url" = "http://tp4.sinaimg.cn/3973782139/50/0/1";
                     "profile_url" = "u/3973782139";
                     province = 36;
                     ptype = 0;
                     remark = "";
                     "screen_name" = 15668689926sxl;
                     star = 0;
                     "statuses_count" = 0;
                     url = "";
                     verified = 0;
                     "verified_reason" = "";
                     "verified_type" = "-1";
                     weihao = "";
                 }*/
                success(userInfo);
            }];
        }else{
            NSError * error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodeSinaWeiboSetupError userInfo:nil];
            errorBlock(error);
        }
    }];
}
- (void)retriveOwnTencentProfile:(void (^)(NSDictionary *))success error:(void (^)(NSError *))errorBlock
{
    [self requestTencentAccountAccess:^(NSError *error) {
        if (!error) {
            [self fetchOwnTencentProfile:
             ^(NSDictionary *userInfo, NSError *error) {
                 
                 DLog(@"fetched tencent profile: %@", userInfo);
                 success(userInfo);
             }];
        }else{
            NSError * error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodeTencentWeiboSetupError userInfo:nil];
            errorBlock(error);
        }
    }];
}

- (NSArray*)lookupUserInfoFromAddressBookEmail:(NSString*)email
{
    NSMutableArray *matchesArray = [@[] mutableCopy];
    NSDictionary * userDict = nil;
    NSArray * matches = [ABContactsHelper contactsMatchingEmail:email];
    if (matches.count > 0) {
        __block NSString * firstname = @"";
        __block NSString * lastname = @"";
        __block NSString * phone = @"";
        __block NSString * email = @"";
        
        [matches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ABContact *contact = (ABContact*)obj;
            firstname = contact.firstname?contact.firstname:@"";
            lastname = contact.lastname?contact.lastname:@"";
            if ([contact.phonenumbers length]) {
                phone = contact.phonenumbers?contact.phonenumbers:@"";
            }
            email = contact.emailaddresses?contact.emailaddresses:@"";
        }];
        
//        if ([phone length]) {
//            // strip everything but numbers
//            phone = [[phone componentsSeparatedByCharactersInSet:
//                      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
//                     componentsJoinedByString:@""];
//        }
        userDict = @{@"phoneNumbers":phone,
                     @"firstName":firstname,
                     @"lastName":lastname,
                     @"email":email};
        [matchesArray addObject:userDict];
    }
    return matchesArray;
}


- (NSArray*)lookupUserInfoFromAddressBookPhone:(NSString *)phone
{
    NSMutableArray *matchesArray = [@[] mutableCopy];
    NSDictionary * userDict = nil;
    NSArray * matches = [ABContactsHelper contactsMatchingPhone:phone];
    if (matches.count > 0) {
        __block NSString * firstname = @"";
        __block NSString * lastname = @"";
        __block NSString * phone = @"";
        __block NSString * email = @"";
        
        [matches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ABContact *contact = (ABContact*)obj;
            firstname = contact.firstname?contact.firstname:@"";
            lastname = contact.lastname?contact.lastname:@"";
            if ([contact.phonenumbers length]) {
                phone = contact.phonenumbers?contact.phonenumbers:@"";
            }
            email = contact.emailaddresses?contact.emailaddresses:@"";
        }];
        
//        if ([phone length]) {
//            // strip everything but numbers
//            phone = [[phone componentsSeparatedByCharactersInSet:
//                      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
//                     componentsJoinedByString:@""];
//        }
        userDict = @{@"phoneNumbers":phone,
                     @"firstName":firstname,
                     @"lastName":lastname,
                     @"email":email};
        [matchesArray addObject:userDict];
    }
    return matchesArray;
}


- (NSDictionary*)lookupOwnUserInfoFromAddressBook
{
    NSDictionary * userDict = nil;
    
    // get device name
    NSString * deviceName = [[UIDevice currentDevice] name];
    // for testing
    if ([deviceName isEqualToString:@"iPhone Simulator"]) {
        deviceName = @"Kenny Tang's iPhone5";
    }

    
    NSRange t = [deviceName rangeOfString:@" "];
    if (t.location != NSNotFound) {
        deviceName = [deviceName substringToIndex:t.location];
        // do lookup in addressbook
        NSArray * matches = [ABContactsHelper contactsMatchingName:deviceName];
        if (matches.count > 0) {
            __block NSString * firstname = @"";
            __block NSString * lastname = @"";
            __block NSString * phone = @"";
            __block NSString * email = @"";
            
            [matches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ABContact *contact = (ABContact*)obj;
                firstname = contact.firstname?contact.firstname:@"";
                lastname = contact.lastname?contact.lastname:@"";
                if ([contact.phonenumbers length]) {
                    phone = contact.phonenumbers?contact.phonenumbers:@"";
                }
                email = contact.emailaddresses?contact.emailaddresses:@"";
            }];
            
            if ([phone length]) {
                // strip everything but numbers
                phone = [[phone componentsSeparatedByCharactersInSet:
                                        [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                       componentsJoinedByString:@""];
            }
            userDict = @{@"phoneNumbers":phone,
                         @"firstName":firstname,
                         @"lastName":lastname,
                         @"email":email};
        }
    }
    
    return userDict;
}

- (void)signOut
{
    PIRUser *user = [[PIRUserServices sharedService] currentUser];
    if ((!user) || (![user.pierID length])){
        return;
    }
    NSString *signOutURLString = [NSString stringWithFormat:kSignoutURL, user.pierID];
    NSDictionary *tokensDict = [super requestTokens];
    NSDictionary * updateUserDict = @{
                                      @"userId"         : user.pierID?user.pierID:@"",
                                      @"push_token"     : @""
                                      };
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tokensDict];
    [params addEntriesFromDictionary:updateUserDict];
    [[PIRHTTPSessionManager sharedInstance] POST:signOutURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        [self stopRefreshLoginTimer];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ELog(@"Error: %@", task.response);
        [self stopRefreshLoginTimer];
    }];
    
}

- (void)signIn:(NSString*)loginName passcode:(NSString*)passCode success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:loginName forKey:@"userName"];
    [standardUserDefaults synchronize];
    
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    
    __weak typeof(self) weakSelf = self;
    void (^successBlock)(NSURLSessionDataTask *task, id JSON) = ^void(NSURLSessionDataTask *task, id JSON) {
        DLog(@"responseObject: %@", JSON);
        NSDictionary *bodyDict = JSON[@"body"];
        NSNumber * isSuccess = JSON[@"success"];
        if ([isSuccess integerValue] == 1){
            NSString *userId = bodyDict[@"id"];
            
            NSDictionary *accessTokenDict = bodyDict[@"accessToken"];
            NSString *token = accessTokenDict[@"value"];
            NSNumber *tokenExpiration = accessTokenDict[@"expirationDate"];
            
            NSDictionary *deviceTokenDict = bodyDict[@"deviceToken"];
            NSString *deviceToken = deviceTokenDict[@"value"];
            
            if (![userId length]){
                ELog(@"error :%@", task.response);
                errorCallBack(nil);
                return;
            }
            typeof(self) strongSelf = weakSelf;
            [strongSelf removeExpiredAccessTokens];
            
            
            // no current user exists in local storage
            PIRUser *newUser = nil;
            if (!currentUser) {
                newUser = [PIRUser createEntity];
                newUser.userName = loginName;
                newUser.passCode = passCode;
            }else{
                newUser = currentUser;
            }
            
            // access Tokens
            PIRAccessTokens *accessTokens = [PIRAccessTokens createEntity];
            accessTokens.accessToken = token;
            accessTokens.accessTokenExpiration = [NSDate dateWithTimeIntervalSince1970:[tokenExpiration doubleValue]];
            accessTokens.user = newUser;
            newUser.accessTokens = accessTokens;
            
            // device Tokens
            PIRDeviceTokens *deviceTokens = [PIRDeviceTokens createEntity];
            deviceTokens.deviceToken = deviceToken;
            deviceTokens.user = newUser;
            newUser.deviceTokens = deviceTokens;
            
            [strongSelf startRefreshLoginTimer];
            
            [strongSelf saveContextSynchronously:^{
                // client callback
                
                success();
            }];
        }else{
            NSString *errorString = bodyDict[@"sessionResultCode"];
            NSError *error = nil;
            if ([errorString isEqualToString:@"INVALID_CREDENTIALS"]){
                error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodeInvalidUsernameOrPasscode userInfo:@{@"serverMessage":errorString}];
            }else if ([errorString isEqualToString:@"USER_NOT_EXIST"]){
                error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodePierAccountNotFound userInfo:@{@"serverMessage":errorString}];
            }
            error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodeOtherError userInfo:@{@"serverMessage":errorString}];
            errorCallBack(error);
        }
    };
    
    
    
    NSString *signInURLString = [NSString stringWithFormat:kSignInURL];
    
    // to-do: device token is empty? new install?
    NSString *deviceToken = currentUser.deviceTokens.deviceToken;
    
    NSDictionary *params = @{
                             @"username" : loginName,
                             @"password" : passCode,
                             @"platform" : @"API",
                             @"device_token" : deviceToken?deviceToken:@"",
                             };
    
    
    [self.sessionManager POST:signInURLString
                                      parameters:params
                                         success:^(NSURLSessionDataTask *task, id JSON) {
                                                successBlock(task, JSON);
                                         } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                             DLog(@"responseObject: %@", task.response);
                                             errorCallBack(error)
                                             ;
                                         }];
}


- (void)updateCurrentUserFromServer:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
    NSString * retrieveUserURLString = [NSString stringWithFormat:kRetrieveUserURL, currentUser.pierID];
    NSDictionary *params = [super requestTokens];
    
    [[PIRHTTPSessionManager sharedInstance] GET:retrieveUserURLString
                                     parameters:params success:^(NSURLSessionDataTask *task, NSDictionary * JSON) {
                                         DLog(@"responseObject: %@", JSON);
                                         /*
                                          body =     {
                                          attrs = "";
                                          countryCode = US;
                                          createdOn = "2014-01-22";
                                          email = "user70@gmail.com";
                                          facebookId = "<null>";
                                          firstName = Kenny;
                                          iBeaconVisibility = 0;
                                          id = U00000000055;
                                          imageUrl = "<null>";
                                          lastLogin = "<null>";
                                          lastName = Tang;
                                          lastUpdated = "<null>";
                                          password = "<null>";
                                          phone = 42342421;
                                          prefix = "Mr.";
                                          socialAttrs = "{\"accounts\":[{\"userID\":\"572733568\",\"type\":0,\"status\":1}]}";
                                          status = ACTIVE;
                                          username = user70;
                                          };
                                          success = 1;
                                          }
                                          */
                                         if (JSON[@"body"]){
                                             NSDictionary * bodyDict = JSON[@"body"];
                                             NSNumber * isSuccess = JSON[@"success"];
                                             if ([isSuccess integerValue] == 1){
                                                 
                                                 NSString * countryCode = bodyDict[@"countryCode"];
                                                 NSString * email = bodyDict[@"email"];
                                                 NSString * firstName = bodyDict[@"firstName"];
                                                 NSString * lastName = bodyDict[@"lastName"];
                                                 NSString * phone = bodyDict[@"phone"];
                                                 NSString * prefix = bodyDict[@"prefix"];
//                                                 NSString * socialAttrs = bodyDict[@"socialAttrs"];
                                                 NSNumber * visibility = bodyDict[@"iBeaconVisibility"];
                                                 NSString * status = bodyDict[@"status"];
                                                 
                                                 currentUser.country = countryCode;
                                                 currentUser.email = email;
                                                 currentUser.firstName = firstName;
                                                 currentUser.lastName = lastName;
                                                 currentUser.phoneNumber = phone;
                                                 currentUser.prefix = prefix;
                                                 currentUser.visibilityOptions = visibility;
                                                 // to-do: parse social attrs
                                                 if ([status isEqualToString:@"ACTIVE"]){
                                                     currentUser.status = @(PIRUserStatusActive);
                                                 }else if ([status isEqualToString:@"INACTIVE"]){
                                                     currentUser.status = @(PIRUserStatusInactive);
                                                     
                                                 }else if ([status isEqualToString:@"LOCKED"]){
                                                     currentUser.status = @(PIRUserStatusLocked);
                                                     
                                                 }else if ([status isEqualToString:@"UNKNOWN"]){
                                                     currentUser.status = @(PIRUserStatusPendingVerification);
                                                 }
                                                 
                                                 // to-do: update user data, save to core data
                                                 [self saveContextSynchronously:^{
                                                     // client callback
                                                     success();
                                                 }];
                                                 
                                             }else{
                                                 // handle error
                                             }
                                         }
                                         
                                         
                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         //                                         errorCallBack(error);
                                         // to-do: handle error
                                         success();
                                     }];
}



#pragma mark - Private

#pragma mark - Private properties

#pragma mark - refresh login timer methods


- (void)startRefreshLoginTimer
{
    [self.refreshLoginTimer invalidate];
    
    DLog(@"refreshLoginTimer started");
    // re-login to refresh the tokens every 5 mins
    self.refreshLoginTimer = [NSTimer scheduledTimerWithTimeInterval:5*60
                                                              target:self
                                                            selector:@selector(refreshLogin)
                                                            userInfo:nil
                                                             repeats:YES];
    
    
}

- (void)stopRefreshLoginTimer
{
    [self.refreshLoginTimer invalidate];
}

- (void)refreshLogin
{
    PIRUser *currentUser = self.currentUser;
    [self signIn:currentUser.userName passcode:currentUser.passCode success:^{
        DLog(@"session renewal succeeded.");
    } error:^(NSError *error) {
        DLog(@"session renewal failed.");
    }];
}


#pragma mark - magical record helper methods

- (void)saveContextSynchronously:(void(^)())completion
{
    [[NSManagedObjectContext MR_defaultContext] saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
        //
        if (completion) {
            completion();
        }
    }];
    
}



#pragma mark - signIn method helper

- (void)removeExpiredAccessTokens
{
    [PIRAccessTokens MR_truncateAllInContext:[NSManagedObjectContext defaultContext]];
}

#pragma mark - facebook integration helper methods

- (void) requestFacebookAccountAccess:(void(^)(NSError * error))completion
{
    if (self.accountStore == nil){
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    // request to read user info
    ACAccountType * facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary * readOptions = @{ACFacebookAppIdKey:kPIRFacebookAppID, ACFacebookPermissionsKey: @[@"email", @"user_photos", @"user_birthday", @"email"], ACFacebookAudienceKey:ACFacebookAudienceEveryone};
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:readOptions
                                            completion: ^(BOOL granted, NSError *e) {
                                                
                                                DLog(@"granted: %i", granted);
                                                
                                                if (granted) {
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:facebookAccountType];
                                                    //it will always be the last object with SSO
                                                    self.facebookAccount = [accounts lastObject];
                                                    completion(e);
                                                    
                                                } else {
                                                    //Fail gracefully...
                                                    completion(e);
                                                } }];
}

- (void) fetchOwnFacebookProfile:(void(^)(NSDictionary *userInfo, NSError * error))completion
{
    
    NSURL * feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    NSDictionary * params = @{@"fields":@"id,picture,birthday,first_name,last_name,location,email"};
    SLRequest * request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:feedURL parameters:params];
    DLog(@"request.URL: %@", request.URL);
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString * responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        DLog(@"responseString: %@", responseString);
        NSError* responseError;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&responseError];
        completion(jsonDict, error);
    }];
}
#pragma mark - sinaWeibo integration helper methods

- (void) requestSinaAccountAccess:(void(^)(NSError * error))completion
{
    if (self.accountStore == nil){
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    // request to read user info
    ACAccountType * sinaWeiboAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierSinaWeibo];
    [self.accountStore requestAccessToAccountsWithType:sinaWeiboAccountType options:nil
                                            completion: ^(BOOL granted, NSError *e) {
                                                
                                                DLog(@"granted: %i", granted);
                                                
                                                if (granted) {
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:sinaWeiboAccountType];
                                                    if([accounts count])
                                                    {
                                                        self.sinaWeiboAccount = [accounts lastObject];
                                                    }
                                                    completion(e);
                                                    
                                                } else {
                                                    //Fail gracefully...
                                                    completion(e);
                                                } }];
}

- (void) fetchOwnSinaProfile:(void(^)(NSDictionary *userInfo, NSError * error))completion
{
    NSURL * feedURL = [NSURL URLWithString:@"https://api.weibo.com/2/users/show.json"];
     NSDictionary * params = @{@"screen_name":[self.sinaWeiboAccount accountDescription]};
    SLRequest * request = [SLRequest requestForServiceType:SLServiceTypeSinaWeibo requestMethod:SLRequestMethodGET URL:feedURL parameters:params];
    DLog(@"request.URL: %@", request.URL);
    request.account = self.sinaWeiboAccount;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString * responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        DLog(@"responseString: %@", responseString);
        NSError* responseError;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&responseError];
        completion(jsonDict, error);
    }];
}
#pragma mark - Tencent Weibo integration helper methods

- (void) requestTencentAccountAccess:(void(^)(NSError * error))completion
{
    if (self.accountStore == nil){
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    // request to read user info
    ACAccountType * tencentWeiboAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTencentWeibo];
    [self.accountStore requestAccessToAccountsWithType:tencentWeiboAccountType options:@{ACTencentWeiboAppIdKey:kPIRTencentWeiboAppID}
                                            completion: ^(BOOL granted, NSError *e) {
                                                
                                                DLog(@"granted: %i", granted);
                                                
                                                if (granted) {
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:tencentWeiboAccountType];
                                                    self.tencentWeiboAccount = [accounts lastObject];
                                                    completion(e);
                                                    
                                                } else {
                                                    //Fail gracefully...
                                                    completion(e);
                                                } }];
}

- (void) fetchOwnTencentProfile:(void(^)(NSDictionary *userInfo, NSError * error))completion
{
    
    NSURL * feedURL = [NSURL URLWithString:@"https://open.t.qq.com/api/user/info"];
    NSDictionary * params = @{@"format":@"json"};
    SLRequest * request = [SLRequest requestForServiceType:SLServiceTypeTencentWeibo requestMethod:SLRequestMethodGET URL:feedURL parameters:params];
    DLog(@"request.URL: %@", request.URL);
    request.account = self.tencentWeiboAccount;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString * responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        DLog(@"responseString: %@", responseString);
        NSError* responseError;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&responseError];
        completion(jsonDict, error);
    }];
}
#pragma mark - user web services helper methods

- (void)updateUserToBackend:(PIRUser*)user
{
    
    // to-do: talk to backend team to support all parameters
    NSString * updateUserURLString = [NSString stringWithFormat:kUpdateUserURL, user.pierID];
    NSDictionary *tokensDict = [super requestTokens];
    NSDictionary * updateUserDict = @{
                                      @"userId"         : user.pierID?user.pierID:@"",
                                      @"first_name"     : user.firstName,
                                      @"last_name"      : user.lastName,
                                      @"password"       : user.passCode,
                                      @"email"          : user.email,
                                      @"phone"          : user.phoneNumber,
                                      @"social_attrs"    : [self socialAccountToJSON:user],
                                      @"visibility_status"   : user.visibilityOptions?user.visibilityOptions:@(PIRVisibilityOptionsPierUsers),
                                      };
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tokensDict];
    [params addEntriesFromDictionary:updateUserDict];
    
    [[PIRHTTPSessionManager sharedInstance] POST:updateUserURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // to-do: check responseobject
        
        NSLog(@"responseObject: %@", responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // to-do: handle failure
        ELog(@"Error: %@", task.response);
    }];
}


- (void)submitBankAccountForVerification:(PIRBankAccount*)bankAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    PIRUser * user = [[PIRUserServices sharedService] currentUser];
    NSString * submitBankString = [NSString stringWithFormat:kSubmitBankVerificationURL];
    NSDictionary * addBankDict = @{
                                   @"user_id"           :user.pierID?user.pierID:@"",
                                   @"bank_id"           :bankAccount.accountID,
                                   @"amount1"           :@"1",
                                   @"amount2"           :@"1",
                                   @"format"            :@"json",
                                   };
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:addBankDict];
    [paramsDict addEntriesFromDictionary:[super requestTokens]];
    
    [[PIRHTTPSessionManager2 sharedInstance] POST:submitBankString parameters:paramsDict success:^(NSURLSessionDataTask *task, id responseObject) {
        // to-do: check responseobject
        
        NSLog(@"responseObject: %@", responseObject);
        if (responseObject[@"verification_id"]){
            bankAccount.pendingVerificationID = responseObject[@"verification_id"];
            success();
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        // errors: InvalidBankAccountId
        
        errorCallBack(error);
    }];
    
}


- (void)addBankAccount:(PIRBankAccount*)bankAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    NSString * isPrimaryString = @"";
    if ([bankAccount.isDefault integerValue]) {
        isPrimaryString = @"true";
    }else{
        isPrimaryString = @"false";
    }
    
    PIRUser * user = [[PIRUserServices sharedService] currentUser];
    NSString * addBankURLString = [NSString stringWithFormat:kAddBankURL];
    NSDictionary * addBankDict = @{
                                   @"user_id"           :user.pierID?user.pierID:@"",
                                   @"abn_number"        :bankAccount.routingNumber,
                                   @"account_number"    :bankAccount.accountNumber,
                                   @"type"              :bankAccount.accountType,
                                   @"bank_name"         :bankAccount.bankName,
                                   @"country"           :bankAccount.country,
                                   @"_is_primary"       :isPrimaryString,
                                   @"format"            :@"json",
                                      };
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:addBankDict];
    [paramsDict addEntriesFromDictionary:[super requestTokens]];
    
    [[PIRHTTPSessionManager2 sharedInstance] POST:addBankURLString parameters:paramsDict success:^(NSURLSessionDataTask *task, id responseObject) {
        // to-do: check responseobject
        
        NSLog(@"responseObject: %@", responseObject);
        bankAccount.accountID = responseObject[@"bank_account_id"];
        bankAccount.user = user;
        [user addAccountsObject:bankAccount];
        
        [self submitBankAccountForVerification:bankAccount success:^{
            [self saveContextSynchronously:^{
                success();
            }];
        } error:^(NSError *error) {
            errorCallBack(error);
        }];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        // errors: InvalidBankAccountId
        
        errorCallBack(error);
    }];

}

- (void)removeBankAccount:(PIRBankAccount*)bankAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    PIRUser * user = [[PIRUserServices sharedService] currentUser];
    NSString * removeBankURLString = [NSString stringWithFormat:kRemoveBankURL];
    NSDictionary * removeBankDict = @{
                                   @"bank_id"  : bankAccount.accountID,
                                   @"user_id"          :user.pierID?user.pierID:@"",
                                   @"format"            :@"json",
                                   };
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:removeBankDict];
    [paramsDict addEntriesFromDictionary:[super requestTokens]];
    
    [[PIRHTTPSessionManager2 sharedInstance] POST:removeBankURLString parameters:paramsDict success:^(NSURLSessionDataTask *task, id responseObject) {
        // to-do: check responseobject
        
        NSLog(@"responseObject: %@", responseObject);
        
        [bankAccount deleteEntity];
        [self saveContextSynchronously:^{
            success();
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // to-do: handle failure
        errorCallBack(error);
    }];
}

- (void)verifyBankAccount:(PIRBankAccount*)bankAccount amount1:(NSUInteger)amount1 amount2:(NSUInteger)amount2 success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    PIRUser * user = [[PIRUserServices sharedService] currentUser];
    NSString * verifyBankURLString = [NSString stringWithFormat:kVerifyBankURL];
    NSDictionary * verifyBankDict = @{
                                      @"verification_id" : bankAccount.pendingVerificationID,
                                      @"bank_id"  :         bankAccount.accountID,
                                      @"user_id"          :user.pierID?user.pierID:@"",
                                      @"amount1"            :@(amount1),
                                      @"amount2"            :@(amount2),
                                      @"format"            :@"json",
                                      };
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:verifyBankDict];
    [paramsDict addEntriesFromDictionary:[super requestTokens]];
    
    [[PIRHTTPSessionManager2 sharedInstance] POST:verifyBankURLString parameters:paramsDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        if ([responseObject[@"statusCode"] isEqualToString:@"200"]){
            bankAccount.isVerified = @(YES);
        }
        [self saveContextSynchronously:^{
            success();
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorCallBack(error);
    }];
    
}


- (void)addSocialAccount:(PIRSocialAccount*)socialAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    // to-do:awaiting api definition
    [self saveContextSynchronously:^{
        success();
    }];
}


- (void)removeSocialAccount:(PIRSocialAccount*)socialAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    // to-do:awaiting api definition
    [socialAccount deleteEntity];
    [self saveContextSynchronously:^{
        success();
    }];
}

- (void)retriveUserInfo:(NSString*)pierID success:(void(^)(PIRUser* user))success error:(void(^)(NSError* error))errorCallBack
{
    // to-do: call web service to retrieve user
    NSString * retrieveUserURLString = [NSString stringWithFormat:kRetrieveUserURL, pierID];
    [[PIRHTTPSessionManager2 sharedInstance] GET:retrieveUserURLString
                                     parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
                                         DLog(@"responseObject: %@", JSON);
                                         
                                         PIRUser * returnedUser = [PIRUser createEntity];
                                         returnedUser.pierID = pierID;
                                         returnedUser.isMe = @(NO);
                                         returnedUser.firstName = @"John";
                                         returnedUser.lastName = @"Appleseed";
                                         returnedUser.phoneNumber = @"1112223333";
                                         returnedUser.visibilityOptions = @(PIRVisibilityOptionsPierUsers);
                                         success(returnedUser);
                                         
                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         //                                         errorCallBack(error);
                                         // to-do: handle error
                                         PIRUser * returnedUser = [PIRUser createEntity];
                                         returnedUser.pierID = pierID;
                                         returnedUser.isMe = @(NO);
                                         returnedUser.firstName = @"John";
                                         returnedUser.lastName = @"Appleseed";
                                         returnedUser.phoneNumber = @"1112223333";
                                         returnedUser.visibilityOptions = @(PIRVisibilityOptionsPierUsers);
                                         success(returnedUser);
                                     }];
}

-(NSString*)socialAccountToJSON:(PIRUser*)user
{
    NSMutableArray *socialAccountsArray = [@[] mutableCopy];
    [[user.socialAccounts allObjects] enumerateObjectsUsingBlock:^(PIRSocialAccount* socialAccount, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *socialAccountDict = [@{} mutableCopy];
        socialAccountDict[@"type"] = socialAccount.type,
        socialAccountDict[@"userID"] = socialAccount.userID;
        socialAccountDict[@"status"] = socialAccount.status;
        [socialAccountsArray addObject:socialAccountDict];
    }];
    NSDictionary * socialAccountsDict = @{@"accounts":socialAccountsArray};
    return [socialAccountsDict jsonString];
    
}

-(NSString*)pushNotificationTokensToJSON:(PIRUser*)user
{
    NSMutableArray * tokensArray = [@[] mutableCopy];
    [user.pushNotificationTokens enumerateObjectsUsingBlock:^(PIRPushNotificationTokens * token, BOOL *stop) {
        if ([token.token length]) {
            [tokensArray addObject:token.token];
        }
    }];
    NSDictionary * tokensDict = @{@"tokens":tokensArray};
    NSString * tokensString = [tokensDict jsonString];
    return tokensString;
}

- (void)verifyPhoneCode:(NSString*)phoneCode email:(NSString*)emailCode success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    
    NSDictionary *verifyDict = @{
                                 @"phone_verify_code": phoneCode,
                                 @"email_verify_code": emailCode,
                                 @"user_id": currentUser.pierID
                                 };
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:verifyDict];
    [paramsDict addEntriesFromDictionary:[super requestTokens]];
    
    NSString *urlString = [NSString stringWithFormat:kVerifyUserURL, currentUser.pierID];
    [[PIRHTTPSessionManager sharedInstance] POST:urlString parameters:paramsDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        
        NSDictionary *bodyDict = responseObject[@"body"];
        BOOL isSuccess = [responseObject[@"success"] boolValue];
        if (!isSuccess){
            
            NSString *errorString = bodyDict[@"sessionResultCode"];
            NSError *error = nil;
            error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodeOtherError userInfo:@{@"serverMessage":errorString}];
            
            ELog(@"error :%@", task.response);
            errorCallBack(error);
            return;
        }else{
            currentUser.status = @(PIRUserStatusActive);
            [self saveContextSynchronously:^{
                success();
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorCallBack(error);
    }];
}


@end
