//
//  PIRUser.m

//
//  Created by Kenny Tang on 3/2/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRUser.h"
#import "PIRAccessTokens.h"
#import "PIRBankAccount.h"
#import "PIRCreditApplication.h"
#import "PIRDeviceTokens.h"
#import "PIRPushNotificationTokens.h"
#import "PIRSocialAccount.h"
#import "PIRTransaction.h"


@implementation PIRUser

@dynamic address;
@dynamic birthDate;
@dynamic country;
@dynamic email;
@dynamic firstName;
@dynamic isMe;
@dynamic lastName;
@dynamic passCode;
@dynamic phoneNumber;
@dynamic pierID;
@dynamic prefix;
@dynamic ssn;
@dynamic status;
@dynamic thumbnailURL;
@dynamic userName;
@dynamic visibilityOptions;
@dynamic zipCode;
@dynamic accessTokens;
@dynamic accounts;
@dynamic creditApplication;
@dynamic deviceTokens;
@dynamic pushNotificationTokens;
@dynamic receivedTransactions;
@dynamic sentTransactions;
@dynamic socialAccounts;

@end
