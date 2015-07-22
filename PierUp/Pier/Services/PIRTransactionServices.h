//
//  PIRTransactionServices.h

//
//  Created by Kenny Tang on 1/5/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIRWebServices.h"
#import "PIRTransaction+Extensions.h"
#import "PIRCreditApplication.h"

typedef NS_ENUM(NSInteger, PIRTransactionServicesErrorCodes)
{
    PIRTransactionServicesErrorCodeLowBalanceFrom = 9001,
    PIRTransactionServicesErrorCodeLowBalanceTo,
    PIRTransactionServicesErrorCodeInvalidFromAccount,
    PIRTransactionServicesErrorCodeInvalidToAccount,
    PIRTransactionServicesErrorCodeInvalidAmount,
    PIRTransactionServicesErrorCodePhoneEmailNotVerified,
    PIRTransactionServicesErrorUnspecified,
};
extern NSString *const kPIRTransactionServicesErrorCodesDomain;



/*!
 *  Wrapper class for performing all user info load and save requests
 */
@interface PIRTransactionServices : PIRWebServices

/**
 *  Get instance of this service
 *
 *  @return instance
 */
+ (PIRTransactionServices*)sharedService;

@property (nonatomic, strong) NSNumber *cnyToUSDRate;


/**
 *  Send payment request to another user
 */
- (void)sendPayment:(PIRTransaction *)payment toUser:(PIRUser*)user success:(void(^)())success error:(void(^)(NSError* error))errorCallBack;

/**
 *  save received ment
 */
- (void)addReceivedPayment:(PIRTransaction *)trans;

-(NSString*)lookUpBankNameWithRoutingNumber:(NSString*)routingNumber;

-(NSArray*)retrieveTransactionsReceivedBy:(PIRUser*)user;

-(NSArray*)retrieveTransactionsSentBy:(PIRUser*)user;


-(void)applyForCredit:(PIRCreditApplication*)application success:(void(^)(NSNumber* amount))success error:(void(^)(NSError* error))errorCallBack;

- (void)refreshCNYtoUSDExchangeRate:(void(^)(NSNumber* exchange))success error:(void(^)(NSError* error))errorCallBack;

@end
