//
//  PIRConstants.h

//
//  Created by Kenny Tang on 12/15/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIRConstants : NSObject

extern NSString *const kPIRConstantsDiscoveryInfoFirstName;
extern NSString *const kPIRConstantsDiscoveryInfoLastName;
extern NSString *const kPIRConstantsDiscoveryInfoProfileURL;

extern NSString *const kPIRConstantsDiscoveryInfoSocialAccounts;
extern NSString *const kPIRConstantsDiscoveryInfoSocialAccountType;
extern NSString *const kPIRConstantsDiscoveryInfoSocialAccountID;

extern NSString *const kPIRConstantsDiscoveryInfoPierID;
extern NSString *const kPIRConstantsDiscoveryInfoContactNumber;

extern NSString *const kPIRConstantsReceivedPaymentRequestNotification;

extern NSString *const kPIRConstantsDiscoveryInfoReceiveMode;
extern NSString *const kPIRConstantsDiscoveryInfoReceiveModePier;
extern NSString *const kPIRConstantsDiscoveryInfoReceiveModeFacebook;
extern NSString *const kPIRConstantsDiscoveryInfoReceiveModeContacts;

// post notification
extern NSString *const kPIRConstantsProfileUpdatedNotification;
extern NSString *const kPIRConstantsTransactionsUpdatedNotification;
extern NSString *const kPIRConstantsTransactionsReceivedNotification;


@end
