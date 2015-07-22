//
//  PIRBeaconServices.m

//
//  Created by Kenny Tang on 1/8/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRBeaconServices.h"
@import CoreLocation;
@import CoreBluetooth;

static  NSString  * const kUUIDString = @"3526C938-C734-4F89-8FF1-BA56AD90A7C1";
static  NSString  * const kIdentifierString = @"com.User";

@interface PIRBeaconServices()<CBPeripheralManagerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) NSUUID *beaconUUID;
@property (nonatomic, strong) CLBeaconRegion *broadcastRegion;
@property (nonatomic, strong) CLBeaconRegion *rangedRegion;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *foundPeers;

@property (nonatomic, strong) RangingBeaconsCallback callBack;

@end

@implementation PIRBeaconServices

#pragma mark - Public

#pragma mark - Public Methods

+ (instancetype) sharedInstance {
    static PIRBeaconServices * singleton = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        self.foundPeers = [@[] mutableCopy];
    }
    return self;
}

- (void)startBroadcastBeacon
{
    // initialize new peripheral manager and begin monitoring for updates
    if (!self.peripheralManager) {
        
        NSUInteger minorVersion = (NSUInteger)arc4random()%100;
        
        self.beaconUUID = [[NSUUID alloc] initWithUUIDString:kUUIDString];
        self.broadcastRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.beaconUUID
                                                major:1
                                                minor:minorVersion
                                           identifier:kIdentifierString];
        
        DLog(@"startBroadcastBeacon: broadcastRegion: %@", self.broadcastRegion);
        
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
        
        if(self.peripheralManager.state < CBPeripheralManagerStatePoweredOn) {
            ELog(@"Bluetooth must be enabled in order to act as an iBeacon");
            return;
        }
        
    }
}

- (void)stopBroadcastBeacon
{
    [self.peripheralManager stopAdvertising];
}

- (void)startRangingBeacon:(RangingBeaconsCallback)callback
{
    [self.foundPeers removeAllObjects];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.beaconUUID = [[NSUUID alloc] initWithUUIDString:kUUIDString];
    self.rangedRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.beaconUUID
                                                              identifier:kIdentifierString];
    self.callBack = callback;
    [self.locationManager startRangingBeaconsInRegion:self.rangedRegion];
}

- (void)stopRangingBeacon
{
    [self.locationManager stopRangingBeaconsInRegion:self.rangedRegion];
    [self.foundPeers removeAllObjects];
}

#pragma mark - Private 

#pragma mark - Private Methods

#pragma mark - CBPeripheralManagerDelegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    NSString *status;
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnsupported:
            // ensure you are using a device supporting Bluetooth 4.0 or above.
            // not supported on iOS 7 simulator
            status = @"Device platform does not support BTLE peripheral role.";
            break;
            
        case CBPeripheralManagerStateUnauthorized:
            // verify app is permitted to use Bluetooth
            status = @"App is not authorized to use BTLE peripheral role.";
            break;
            
        case CBPeripheralManagerStatePoweredOff:
        {
            // Bluetooth service is powered off
            status = @"Bluetooth service is currently powered off on this device.";
            [self.peripheralManager stopAdvertising];
        }
            
            break;
            
        case CBPeripheralManagerStatePoweredOn:
        {
            // start advertising CLBeaconRegion
            NSDictionary *broadcastDict = [self.broadcastRegion peripheralDataWithMeasuredPower:nil];
            [self.peripheralManager startAdvertising:broadcastDict];
            status = @"Now advertising iBeacon signal.  Monitor other device for location updates.";
        }
            break;
        case CBPeripheralManagerStateResetting:
            // Temporarily lost connection
            status = @"Bluetooth connection was lost.  Waiting for update...";
            break;
            
        case CBPeripheralManagerStateUnknown:
        default:
            // Connection status unknown
            status = @"Current peripheral state unknown.  Waiting for update...";
            break;
    }
    DLog(@"status: %@", status);
}



#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if([region isEqual:self.rangedRegion]) {
        // Let's just take the first beacon
        
        
        NSMutableArray * updatePeers = [@[] mutableCopy];
        [beacons enumerateObjectsUsingBlock:^(CLBeacon * beacon, NSUInteger idx, BOOL *stop) {
            [updatePeers addObject:beacon.minor];
        }];
        
        [updatePeers enumerateObjectsUsingBlock:^(NSNumber * peerNumber, NSUInteger idx, BOOL *stop) {
            if (![self.foundPeers containsObject:peerNumber]) {
                [self.foundPeers addObject:peerNumber];
                // notify delegate of new peer being added
                if (self.callBack) {
                    self.callBack(self.foundPeers, nil);
                }
            }
        }];
        [self.foundPeers enumerateObjectsUsingBlock:^(NSNumber * peerNumber, NSUInteger idx, BOOL *stop) {
            if (![updatePeers containsObject:peerNumber]) {
                [self.foundPeers removeObjectAtIndex:idx];
                // notify delegate of peer being removed
                if (self.callBack) {
                    self.callBack(self.foundPeers, nil);
                }
            }
        }];
        
        DLog(@"foundPeers %@", self.foundPeers);
        
//        CLBeacon *beacon = [beacons firstObject];
//        DLog(@"didRangeBeacon: %ddB", beacon.rssi);
//        DLog(@"didRangeBeacon major: %i", [beacon.major integerValue]);
//        DLog(@"didRangeBeacon minor: %i", [beacon.minor integerValue]);
//        if (![self.foundPeers containsObject:beacon.minor]){
//            [self.foundPeers addObject:beacon.minor];
//        }
    }
}



@end
