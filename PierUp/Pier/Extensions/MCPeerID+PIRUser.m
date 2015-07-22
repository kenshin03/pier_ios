//
//  MCPeerID+PIRUser.m

//
//  Created by Kenny Tang on 12/15/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "MCPeerID+PIRUser.h"
#import "PIRUser+Extensions.h"
#import "PIRSocialAccount+Extensions.h"

@implementation MCPeerID (PIRUser)

- (PIRUser*)pirUserFromPeerID:(MCPeerID*)peerID discoveryInfo:(NSDictionary*)discoverInfo
{
    PIRUser * user = [PIRUser createEntity];
    user.isMe = @(NO);
    
    NSString * dataString = discoverInfo[@"data"];
    
    NSDictionary * info = [NSJSONSerialization
                                 JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    user.firstName = info[kPIRConstantsDiscoveryInfoFirstName];
    user.lastName = info[kPIRConstantsDiscoveryInfoLastName];
    user.thumbnailURL = info[kPIRConstantsDiscoveryInfoProfileURL];
    user.pierID = info[kPIRConstantsDiscoveryInfoPierID];
    
    if (info[kPIRConstantsDiscoveryInfoSocialAccounts]) {
        NSArray * socialAccounts = info[kPIRConstantsDiscoveryInfoSocialAccounts];
        [socialAccounts enumerateObjectsUsingBlock:^(NSDictionary * accountsDict, NSUInteger idx, BOOL *stop) {
            PIRSocialAccount * socialAccount = [PIRSocialAccount createEntity];
            socialAccount.user = user;
            socialAccount.type = accountsDict[kPIRConstantsDiscoveryInfoSocialAccountType]?@([accountsDict[kPIRConstantsDiscoveryInfoSocialAccountType] integerValue]):@(PIRSocialAccountTypeFacebook);
            socialAccount.status = @(PIRSocialAccountStatusActive);
            socialAccount.userID = accountsDict[kPIRConstantsDiscoveryInfoSocialAccountID];
            [user addSocialAccountsObject:socialAccount];
        }];
    }
    user.phoneNumber = info[kPIRConstantsDiscoveryInfoContactNumber];
    user.peerID = peerID;
    return user;
}

@end
