//
//  PIRUser.h

//
//  Created by Kenny Tang on 3/2/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIRAccessTokens, PIRBankAccount, PIRCreditApplication, PIRDeviceTokens, PIRPushNotificationTokens, PIRSocialAccount, PIRTransaction;

@interface PIRUser : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * isMe;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * passCode;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * pierID;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * ssn;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * visibilityOptions;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) PIRAccessTokens *accessTokens;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) PIRCreditApplication *creditApplication;
@property (nonatomic, retain) PIRDeviceTokens *deviceTokens;
@property (nonatomic, retain) NSSet *pushNotificationTokens;
@property (nonatomic, retain) NSSet *receivedTransactions;
@property (nonatomic, retain) NSSet *sentTransactions;
@property (nonatomic, retain) NSSet *socialAccounts;
@end

@interface PIRUser (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(PIRBankAccount *)value;
- (void)removeAccountsObject:(PIRBankAccount *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (void)addPushNotificationTokensObject:(PIRPushNotificationTokens *)value;
- (void)removePushNotificationTokensObject:(PIRPushNotificationTokens *)value;
- (void)addPushNotificationTokens:(NSSet *)values;
- (void)removePushNotificationTokens:(NSSet *)values;

- (void)addReceivedTransactionsObject:(PIRTransaction *)value;
- (void)removeReceivedTransactionsObject:(PIRTransaction *)value;
- (void)addReceivedTransactions:(NSSet *)values;
- (void)removeReceivedTransactions:(NSSet *)values;

- (void)addSentTransactionsObject:(PIRTransaction *)value;
- (void)removeSentTransactionsObject:(PIRTransaction *)value;
- (void)addSentTransactions:(NSSet *)values;
- (void)removeSentTransactions:(NSSet *)values;

- (void)addSocialAccountsObject:(PIRSocialAccount *)value;
- (void)removeSocialAccountsObject:(PIRSocialAccount *)value;
- (void)addSocialAccounts:(NSSet *)values;
- (void)removeSocialAccounts:(NSSet *)values;

@end
