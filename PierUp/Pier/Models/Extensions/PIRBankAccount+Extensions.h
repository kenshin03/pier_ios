//
//  PIRBankAccount+Extensions.h

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRBankAccount.h"

// `BANK_ACCOUNTS`
// `STATUS` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=active, 2=inactive, 3=locked'
// https://github.com/Pierup/sql/blob/master/tables
typedef NS_ENUM(NSUInteger, PIRBankAccountStatus)
{
    PIRBankAccountStatusActive =1 ,
    PIRBankAccountStatusInActive =2,
    PIRBankAccountStatusLocked =3,
};

// `BANK_ACCOUNTS`
// `TYPE` tinyint(4) NOT NULL COMMENT '1- savings, 2-checking, 3 moneymarket',
// https://github.com/Pierup/sql/blob/master/tables

typedef NS_ENUM(NSUInteger, PIRBankAccountType)
{
    PIRBankAccountTypeSavings =1 ,
    PIRBankAccountTypeChecking =2,
    PIRBankAccountTypeMoneyMarket =3,
};

@interface PIRBankAccount (Extensions)

@end
