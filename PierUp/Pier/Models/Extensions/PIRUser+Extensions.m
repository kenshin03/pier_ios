//
//  PIRUser+Extensions.m

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRUser+Extensions.h"
#import "PIRBankAccount.h"

@implementation PIRUser (Extensions)

@dynamic peerID;

UIImage * _thumbnailImage;
MCPeerID * _peerID;


#pragma mark - Public

#pragma mark - Public properties

- (void)setThumbnailImage:(UIImage *)thumbnailImage
{
    _thumbnailImage = thumbnailImage;
}

- (UIImage*)thumbnailImage
{
    return _thumbnailImage;
}

- (void)setPeerID:(MCPeerID *)peerID
{
    _peerID = peerID;
}

- (MCPeerID*)peerID
{
    return _peerID;
}

-(PIRBankAccount*)primaryBankAccount
{
    __block PIRBankAccount *primaryAccount = nil;
    [self.accounts enumerateObjectsUsingBlock:^(PIRBankAccount *account, BOOL *stop) {
        if ([account.isDefault boolValue]){
            primaryAccount = account;
            *stop = YES;
        }
    }];
    return primaryAccount;
}

#pragma mark - Private

@end
