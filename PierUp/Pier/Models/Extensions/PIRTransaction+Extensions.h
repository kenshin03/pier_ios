//
//  PIRSentTransaction+Extensions.h

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRTransaction.h"

// https://github.com/Pierup/sql/blob/master/tables
// `STATUS_CODE` tinyint(4) NOT NULL DEFAULT '1' COMMENT
// '0 - inactive\n1- active\n2 - locked\n3 - processed\n4 - denied by payee\n'

typedef NS_ENUM(NSUInteger, PIRTransactionStatus)
{
    PIRTransactionStatusInactive =0,
    PIRTransactionStatusActive =1,
    PIRTransactionStatusLocked =2,
    PIRTransactionStatusProcessed =3,
    PIRTransactionStatusDeniedByPayee =4,
    
};

typedef NS_ENUM(NSUInteger, PIRTransactionRequestType)
{
    PIRTransactionRequestTypePay,
    PIRTransactionRequestTypeCharge
};

@interface PIRTransaction (Extensions)

@end
