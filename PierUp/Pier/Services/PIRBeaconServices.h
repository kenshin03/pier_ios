//
//  PIRBeaconServices.h

//
//  Created by Kenny Tang on 1/8/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RangingBeaconsCallback)(NSArray * updatedBeacons, NSError * error);


@interface PIRBeaconServices : NSObject

+ (instancetype) sharedInstance;

- (void)startBroadcastBeacon;
- (void)stopBroadcastBeacon;

- (void)startRangingBeacon:(RangingBeaconsCallback)callback;
- (void)stopRangingBeacon;

@end
