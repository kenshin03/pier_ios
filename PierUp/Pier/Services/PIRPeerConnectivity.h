//
//  PIRPeerConnectivity.h

//
//  Wrapper class for Pier user app to connect to each other for pier payments and service discovery.
//  Clients of this class should be agnostic about which underlying network APIs are being used.
//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIRUser+Extensions.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

typedef void (^ErrorCallback)(NSError * error);
typedef void (^ScanPeersCallback)(NSArray * connectedPeersArray, NSError * error);

@interface PIRPeerConnectivity : NSObject

+ (id) sharedInstance;

- (void)stopScanningForNearbyPeers;
- (void)startsReceivingPayments:(PIRVisibilityOptions)mode error:(ErrorCallback)error;
- (void)scansForPeers:(ScanPeersCallback)callback;
//- (void)sendPaymentRequest:(PIRPaymentRequest*) req success:(id)success;
//- (void)acceptPaymentRequestFromPeer:(NSString*)displayName;
//
//- (void)sendAcceptPaymentRequestToPeer:(NSString*)displayName;
//- (void)sendRejectPaymentRequestToPeer:(NSString*)displayName;



@end
