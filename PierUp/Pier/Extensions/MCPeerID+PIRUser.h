//
//  MCPeerID+PIRUser.h

//
//  Created by Kenny Tang on 12/15/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PIRUser.h"

@interface MCPeerID (PIRUser)

- (PIRUser*)pirUserFromPeerID:(MCPeerID*)peerID discoveryInfo:(NSDictionary*)info;

@end
