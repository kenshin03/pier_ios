//
//  PIRTransactionServices.m

//
//  Created by Kenny Tang on 1/5/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRTransactionServices.h"
#import "FMDatabase.h"
#import "PIRHTTPSessionManager.h"
#import "PIRHTTPSessionManager2.h"
#import "PIRUserServices.h"



static NSString *const kSendPaymentByPierIDURL         =   @"/services/transaction/transfer";
static NSString *const kSendPaymentByEmailURL          =   @"/services/transaction/transferByEmailFromBankAcct";
static NSString *const kSendPaymentByPhoneURL          =   @"/services/transaction/transferByPhoneFromBankAcct";

static NSString *const kApplyCreditURL                  =   @"/user/%@/credit";
static NSString *const kGetExchangeRateURL              =   @"/exchange/getrate";


NSString *const kPIRTransactionServicesErrorCodesDomain = @"TransactionServicesErrorCodesDomain";


@interface PIRTransactionServices()


@end


@implementation PIRTransactionServices

#pragma mark - Public

#pragma mark - Initialization

+ (instancetype) sharedService {
    static PIRTransactionServices * singleton = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
        singleton.cnyToUSDRate = @(0.16);
    });
    return singleton;
}


#pragma mark - Public methods

- (void)addReceivedPayment:(PIRTransaction *)trans
{
    [self saveContextSynchronously:nil];
}

- (void)sendPayment:(PIRTransaction *)payment toUser:(PIRUser*)toUser success:(void(^)())success error:(void(^)(NSError* error))errorCallBack
{
    if (!payment.fromUser.primaryBankAccount){
        ELog(@"no primary bank account found");
        
        NSError * error = [NSError errorWithDomain:kPIRUserServicesErrorCodesDomain code:PIRUserServicesErrorCodePrimaryBankAccountNotSetupError userInfo:nil];
        
        errorCallBack(error);
        
        return;
    }
    
    if ([toUser.pierID length]){
        [self sendPayment:payment pierID:toUser.pierID success:success error:errorCallBack];
        
    }else if ([toUser.email length]){
        [self sendPayment:payment email:toUser.email success:success error:errorCallBack];
        
    }else if ([toUser.phoneNumber length]){
        [self sendPayment:payment phoneNumber:toUser.phoneNumber success:success error:errorCallBack];
    }
    
}

-(NSString*)lookUpBankNameWithRoutingNumber:(NSString*)routingNumber
{
    NSString * bankName = nil;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"us_banks_routing_numbers"
                                                     ofType:@"sqlite"];
    FMDatabase * db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSString * queryString = [NSString stringWithFormat:@"select * from routing_numbers where newRoutingNumber=%@", routingNumber];
        FMResultSet * resultSet = [db executeQuery:queryString];
        if ([resultSet next]) {
            bankName = [[resultSet stringForColumn:@"bankName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    [db close];
    
    return bankName;
}

-(NSArray*)retrieveTransactionsReceivedBy:(PIRUser*)user
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toUser.pierID = %@", user.pierID];
    NSArray *receivedTransactions = [PIRTransaction findAllWithPredicate:predicate];
    return receivedTransactions;
}

-(NSArray*)retrieveTransactionsSentBy:(PIRUser*)user
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fromUser.pierID = %@", user.pierID];
    NSArray *sentTransactions = [PIRTransaction findAllWithPredicate:predicate];
    return sentTransactions;
}

#pragma mark - Private

#pragma mark - Private properties

#pragma mark - sendPayment method helpers

- (void)sendPayment:(PIRTransaction *)payment email:(NSString*)toEmailAddress success:(void(^)())success error:(void(^)(NSError* error))errorCallBack{
    
    NSString *fromAccountNumber = payment.fromUser.primaryBankAccount.accountID;
    
    NSString * sendPaymentURLString = kSendPaymentByEmailURL;
    NSDictionary * transDict = @{
                                 @"email"         : toEmailAddress,
                                 @"Total"         : @([payment.amount floatValue]),
                                 @"currency"      : payment.currency?payment.currency:@"USD",
                                 @"FromBankAcct"  : fromAccountNumber,
                                 @"FromUserId"    : payment.fromUser.pierID,
                                 @"notes"         : payment.notes,
                                 @"scheduled_date": @([payment.scheduledDate timeIntervalSince1970]),
                                 @"format"        : @"json",
                                 };
    
    [self sendPaymentRequest:payment url:sendPaymentURLString params:transDict success:success error:errorCallBack];
}


- (void)sendPayment:(PIRTransaction *)payment pierID:(NSString*)toPierID success:(void(^)())success error:(void(^)(NSError* error))errorCallBack{
    
    NSString *fromAccountNumber = payment.fromUser.primaryBankAccount.accountID;
    
    NSString * sendPaymentURLString = kSendPaymentByPierIDURL;
    NSDictionary * transDict = @{
                                 @"ToUserId"      : toPierID,
                                 @"Total"         : @([payment.amount floatValue]),
                                 @"FromAcct"      : fromAccountNumber,
                                 @"currency"      : payment.currency?payment.currency:@"USD",
                                 @"FromUserId"    : payment.fromUser.pierID,
                                 @"notes"         : payment.notes,
                                 @"format"        : @"json",
                                 };
    
    [self sendPaymentRequest:payment url:sendPaymentURLString params:transDict success:success error:errorCallBack];
    
}

- (void)sendPayment:(PIRTransaction *)payment phoneNumber:(NSString*)toPhoneNumber success:(void(^)())success error:(void(^)(NSError* error))errorCallBack{
    NSString *fromAccountNumber = payment.fromUser.primaryBankAccount.accountID;
    
    NSString * sendPaymentURLString = kSendPaymentByPhoneURL;
    NSDictionary * transDict = @{
                                 @"phone"         : toPhoneNumber,
                                 @"Total"         : @([payment.amount floatValue]),
                                 @"FromBankAcct"  : fromAccountNumber,
                                 @"FromUserId"    : payment.fromUser.pierID,
                                 @"currency"      : payment.currency?payment.currency:@"USD",
                                 @"notes"         : payment.notes,
                                 @"format"        : @"json",
                                 };
    
    [self sendPaymentRequest:payment url:sendPaymentURLString params:transDict success:success error:errorCallBack];
}

-(void)sendPaymentRequest:(PIRTransaction *)payment url:(NSString*)urlString params:(NSDictionary*)params success:(void(^)())success error:(void(^)(NSError* error))errorCallBack{
    
    NSMutableDictionary *fullParams = [@{} mutableCopy];
    [fullParams addEntriesFromDictionary:[super requestTokens]];
    [fullParams addEntriesFromDictionary:params];
    
    [[PIRHTTPSessionManager2 sharedInstance] GET:urlString parameters:fullParams success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *statusCode = responseObject[@"api_response_status"];
        NSString *transactionID = responseObject[@"transactionID"];
        if (![transactionID length])
        {
            if ([statusCode isEqualToString:@"200"]){
                statusCode = responseObject[@"statusCode"];
            }
        }
        
        if ([statusCode isEqualToString:@"200"]){
            
            payment.transactionID = responseObject[@"transactionID"];
            payment.status = @(PIRTransactionStatusActive);
            [self saveContextSynchronously:^{
                success();
            }];
        }else{
            
            NSString *errorMessage = responseObject[@"message"];
            NSDictionary *errorDict = @{@"message": errorMessage?errorMessage:@""};
            
            NSError *error = nil;
            if ([statusCode isEqualToString:@"501"]){
                error = [NSError errorWithDomain:kPIRTransactionServicesErrorCodesDomain code:PIRTransactionServicesErrorCodeLowBalanceFrom userInfo:errorDict];
            }else if ([statusCode isEqualToString:@"502"]){
                error = [NSError errorWithDomain:kPIRTransactionServicesErrorCodesDomain code:PIRTransactionServicesErrorCodeLowBalanceTo userInfo:errorDict];
            }else if ([statusCode isEqualToString:@"503"]){
                error = [NSError errorWithDomain:kPIRTransactionServicesErrorCodesDomain code:PIRTransactionServicesErrorCodeInvalidFromAccount userInfo:errorDict];
            }else if ([statusCode isEqualToString:@"504"]){
                error = [NSError errorWithDomain:kPIRTransactionServicesErrorCodesDomain code:PIRTransactionServicesErrorCodeInvalidToAccount userInfo:errorDict];
            }else if ([statusCode isEqualToString:@"510"]){
                error = [NSError errorWithDomain:kPIRTransactionServicesErrorCodesDomain code:PIRTransactionServicesErrorCodeInvalidAmount userInfo:errorDict];
            }else if ([statusCode isEqualToString:@"403"]){
                error = [NSError errorWithDomain:kPIRTransactionServicesErrorCodesDomain code:PIRTransactionServicesErrorCodePhoneEmailNotVerified userInfo:errorDict];
            }else if ([statusCode isEqualToString:@"303"]){
                error = [NSError errorWithDomain:kPIRTransactionServicesErrorCodesDomain code:PIRTransactionServicesErrorCodeInvalidToAccount userInfo:errorDict];
            }else{
                error = [NSError errorWithDomain:kPIRTransactionServicesErrorCodesDomain code:PIRTransactionServicesErrorUnspecified userInfo:errorDict];
            }
            [self saveContextSynchronously:^{
                errorCallBack(error);
            }];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        payment.status = @(PIRTransactionStatusInactive);
        [self saveContextSynchronously:^{
            errorCallBack(error);
        }];
    }];
}


- (void)refreshCNYtoUSDExchangeRate:(void(^)(NSNumber* exchange))success error:(void(^)(NSError* error))errorCallBack
{
    NSDictionary *params = @{
                             @"from": @"CNY",
                             @"to": @"USD",
                             @"fromAmount": @"1",
                             };
    
    NSMutableDictionary *fullParams = [@{} mutableCopy];
    [fullParams addEntriesFromDictionary:[super requestTokens]];
    [fullParams addEntriesFromDictionary:params];
    
    [[PIRHTTPSessionManager sharedInstance] GET:kGetExchangeRateURL parameters:fullParams success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *JSON = responseObject[@"body"];
        BOOL isSuccessful = [responseObject[@"success"] boolValue];
        
        if (isSuccessful){
            self.cnyToUSDRate = JSON[@"rate"];
            
        }else{
            // ignore error
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // ignore error
    }];
    
}

-(void)applyForCredit:(PIRCreditApplication*)application success:(void(^)(NSNumber* amount))success error:(void(^)(NSError* error))errorCallBack
{
    NSString *urlString = [NSString stringWithFormat:kApplyCreditURL, application.user.pierID];
    
    
    NSDictionary *params = @{
                             @"userId":application.user.pierID,
                             @"ssn":application.user.ssn,
                             @"zip_code":application.user.zipCode,
                             };
    
    NSMutableDictionary *fullParams = [@{} mutableCopy];
    [fullParams addEntriesFromDictionary:[super requestTokens]];
    [fullParams addEntriesFromDictionary:params];
    
    
    [[PIRHTTPSessionManager sharedInstance] POST:urlString parameters:fullParams success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject: %@", responseObject);
        
        NSNumber * isSuccess = responseObject[@"success"];
        if ([isSuccess integerValue] == 1){
            NSNumber *amount = responseObject[@"body"];
            success(amount);
        }else{
            success(nil);
        }

        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        ELog(@"error: %@", error);
        errorCallBack(error);
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


#pragma mark - Event handlers


@end
