//
//  PIRBankAccount.h

//
//  Created by Kenny Tang on 3/4/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIRUser;

@interface PIRBankAccount : NSManagedObject

@property (nonatomic, retain) NSString * accountID;
@property (nonatomic, retain) NSString * accountNumber;
@property (nonatomic, retain) NSNumber * accountType;
@property (nonatomic, retain) NSString * bankName;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * isDefault;
@property (nonatomic, retain) NSString * routingNumber;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * pendingVerificationID;
@property (nonatomic, retain) NSNumber * isVerified;
@property (nonatomic, retain) PIRUser *user;

@end
