//
//  PIRUser+Extensions.h

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRUser.h"

typedef NS_ENUM (NSUInteger, PIRVisibilityOptions)
{
    PIRVisibilityOptionsPierUsers = 0,
    PIRVisibilityOptionsContactsOnly,
    PIRVisibilityOptionsSocialFriends,
    PIRVisibilityOptionsUndefined,
};

// https://github.com/Pierup/sql/blob/master/tables
// `ACCOUNT_STATUS` tinyint(4) DEFAULT '1' COMMENT '1-active, 2-inactive, 3-locked, etc.',
typedef NS_ENUM(NSInteger, PIRUserStatus)
{
    PIRUserStatusPendingVerification = 0,
    PIRUserStatusActive = 1,
    PIRUserStatusInactive = 2, // created locally, awaiting server side confirmation and tokens
    PIRUserStatusLocked = 3
};

/*!
 *  Category on PIRUser model class to include:
 *  - peerID from MultiPeer API
 *  - image user uploaded from camera roll
 */
@interface PIRUser (Extensions)

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) MCPeerID *peerID;

/**
 *  Method to return the primary bank account for the user
 *
 *  @return PIRBankAccount for primary bank account
 */
-(PIRBankAccount*)primaryBankAccount;

@end
