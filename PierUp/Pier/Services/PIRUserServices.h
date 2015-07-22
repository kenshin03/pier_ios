//
//  PIRUserServices.h

//
//  Created by Kenny Tang on 12/19/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIRBankAccount+Extensions.h"
#import "PIRHTTPSessionManager.h"
#import "PIRUser+Extensions.h"
#import "PIRSocialAccount+Extensions.h"
#import "PIRWebServices.h"

typedef NS_ENUM(NSInteger, PIRUserServicesErrorCodes)
{
    PIRUserServicesErrorCodeFacebookSetupError = 1001,
    PIRUserServicesErrorCodePierEmailPhoneExisted,
    PIRUserServicesErrorCodeInvalidUsernameOrPasscode,
    PIRUserServicesErrorCodePierUserNameExisted,
    PIRUserServicesErrorCodePierAccountNotFound,
    PIRUserServicesErrorCodePierWebServiceError,
    PIRUserServicesErrorCodeSinaWeiboSetupError,
    PIRUserServicesErrorCodeTencentWeiboSetupError,
    PIRUserServicesErrorCodePrimaryBankAccountNotSetupError,
    PIRUserServicesErrorCodeOtherError,
};
extern NSString *const kPIRUserServicesErrorCodesDomain;



/*!
 *  Wrapper class for performing all user info load and save requests
 */
@interface PIRUserServices : PIRWebServices


@property (nonatomic, readonly) PIRHTTPSessionManager *sessionManager;


/**
 *  Get instance of this service
 *
 *  @return instance
 */
+ (PIRUserServices*)sharedService;



/**
 *  Returns current user object, nil if none has been created
 *
 *  @return currentUser
 */
- (PIRUser*)currentUser;


/**
 *  Overwrites changes made to the user object to both local storage and remote web service
 */
- (void)updateCurrentUser:(PIRUser*)user;


- (void)updatePushNotificationTokenToServer:(PIRUser*)user token:(NSString*)token;

- (void)updatePushNotificationTokenFromServer;


/**
 *  Register user to web service
 */
- (void)registerUser:(PIRUser*)user success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;

/**
 *  Update user photo
 */
- (void)updateUserPhoto:(PIRUser*)user success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;


/**
 *  Retreieve user profile with facebook, does not fail if Pier is not set up
 */
- (void)retriveOwnFacebookProfile:(void(^)(NSDictionary* userDict))success error:(void(^)(NSError* error))errorBlock;

/**
 *  Retreieve user profile with sinaWeibo, does not fail if Pier is not set up
 */
- (void)retriveOwnSinaProfile:(void(^)(NSDictionary* userDict))success error:(void(^)(NSError* error))errorBlock;

/**
 *  Retreieve user profile with Tencent Weibo, does not fail if Pier is not set up
 */
- (void)retriveOwnTencentProfile:(void(^)(NSDictionary* userDict))success error:(void(^)(NSError* error))errorBlock;

/**
 *  Look up a user's details from the address book
 *
 *  @return dictionary of user info.
 */
- (NSDictionary*)lookupOwnUserInfoFromAddressBook;


- (NSArray*)lookupUserInfoFromAddressBookEmail:(NSString*)email;

- (NSArray*)lookupUserInfoFromAddressBookPhone:(NSString*)phone;


/**
 *  Makes web service call to retrieve user's updated states
 *
 *  @param success       success block
 *  @param errorCallBack error block with error object
 */
- (void)updateCurrentUserFromServer:(void(^)())success error:(void(^)(NSError* error))errorCallBack;

/**
 *  Add bank account to user
 *
 *  @param bankAccount   bank account object
 *  @param success       success block
 *  @param errorCallBack error block with error object
 */
- (void)addBankAccount:(PIRBankAccount*)bankAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;

/**
 *  Remove bank account from user
 *
 *  @param bankAccount   bank account object
 *  @param success       success block
 *  @param errorCallBack error block with error object
 */
- (void)removeBankAccount:(PIRBankAccount*)bankAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;


/**
 *  Verify bank account 
 *
 *  @param bankAccount   bank account object
 *  @param success       success block
 *  @param errorCallBack error block with error object
 */
- (void)verifyBankAccount:(PIRBankAccount*)bankAccount amount1:(NSUInteger)amount1 amount2:(NSUInteger)amount2 success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;



/**
 *  Add social account to user
 *
 *  @param socialAccount social account object
 *  @param success       success block
 *  @param errorCallBack error block with error object
 */
- (void)addSocialAccount:(PIRSocialAccount*)socialAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;


/**
 *  Remove social account from user
 *
 *  @param socialAccount social account object
 *  @param success       success block
 *  @param errorCallBack error block with error object
 */
- (void)removeSocialAccount:(PIRSocialAccount*)socialAccount success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;

/**
 *  Look up user from web service
 */
- (void)retriveUserInfo:(NSString*)pierID success:(void(^)(PIRUser* user))success error:(void(^)(NSError* error))errorCallBack;



- (void)signIn:(NSString*)loginName passcode:(NSString*)passCode success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;


- (void)verifyPhoneCode:(NSString*)phoneCode email:(NSString*)emailCode success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;

- (void)signOut;





@end
