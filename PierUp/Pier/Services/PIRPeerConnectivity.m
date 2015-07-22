//
//  PIRPeerConnectivity.m

//
//  Created by Kenny Tang on 12/9/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRPeerConnectivity.h"
#import "MCPeerID+PIRUser.h"
#import "PIRUserServices.h"
#import "PIRUser+Extensions.h"
#import "PIRSocialAccount+Extensions.h"

@interface PIRPeerConnectivity()<
MCNearbyServiceBrowserDelegate,
MCNearbyServiceAdvertiserDelegate,
MCSessionDelegate
>


@property (nonatomic, strong) MCNearbyServiceAdvertiser * advertiser;
@property (nonatomic, strong) NSDictionary * advertiseDiscoveryInfo;
@property (nonatomic) PIRVisibilityOptions receiveMode;

@property (nonatomic, strong) MCNearbyServiceBrowser * browser;
@property (nonatomic, strong) ScanPeersCallback scanPeersCallback;
@property (nonatomic, strong) NSMutableDictionary * foundPeers;
@property (nonatomic, strong) NSMutableDictionary * connectedPeers;


@property (nonatomic, strong) MCPeerID * peerID;
@property (nonatomic, strong) MCSession * session;


@end


@implementation PIRPeerConnectivity

static NSString * const kMCSessionServiceType = @"piersession";


#pragma mark - Public

#pragma mark - Public Methods


+ (id) sharedInstance {
    static PIRPeerConnectivity * singleton = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
        [singleton initSession];
    });
    return singleton;
}

- (void)initSession
{
    DLog(@"initSession...");
    // use device name for now
    NSString * userName = [[UIDevice currentDevice] name];
    self.peerID = [[MCPeerID alloc] initWithDisplayName:userName];
    MCSession *session = [[MCSession alloc] initWithPeer:self.peerID
                                        securityIdentity:nil
                                    encryptionPreference:MCEncryptionRequired];
    session.delegate = self;
    self.session = session;
}


- (void)startsReceivingPayments:(PIRVisibilityOptions)mode error:(ErrorCallback)error
{
    self.receiveMode = mode;
    [self.advertiser startAdvertisingPeer];
    DLog(@"startAdvertisingPeer...");
}

- (void)stopScanningForNearbyPeers
{
    DLog(@"stopScanningForNearbyPeers...");
    [self.browser stopBrowsingForPeers];
}

- (void)scansForPeers:(ScanPeersCallback)callback
{
    self.scanPeersCallback = callback;
    [self.browser startBrowsingForPeers];
    DLog(@"startBrowsingForPeers...");
}



#pragma mark - Private


#pragma mark - Private Properties

- (NSDictionary*) advertiseDiscoveryInfo
{
    PIRUser * user = [[PIRUserServices sharedService] currentUser];
    NSMutableArray * socialAccounts = [@[] mutableCopy];
    if ([[user socialAccounts] count]) {
        __block NSString * socialAccountType;
        __block NSString * socialAccountID;
        [[user socialAccounts] enumerateObjectsUsingBlock:^(PIRSocialAccount * account, BOOL *stop) {
            socialAccountType = [NSString stringWithFormat:@"%i", [account.type integerValue]];
            socialAccountID = [NSString stringWithFormat:@"%i", [account.userID integerValue]];
            NSDictionary * accountDict = @{kPIRConstantsDiscoveryInfoSocialAccountType:socialAccountType,
                                           kPIRConstantsDiscoveryInfoSocialAccountID:socialAccountID};
            [socialAccounts addObject:accountDict];
        }];
    }
    
    
    if (!_advertiseDiscoveryInfo) {
        _advertiseDiscoveryInfo = @{
                                         kPIRConstantsDiscoveryInfoFirstName:user.firstName,
                                         kPIRConstantsDiscoveryInfoLastName:user.lastName,
                                         kPIRConstantsDiscoveryInfoProfileURL:
                                             @"https://0.gravatar.com/avatar/9ed15c09a9fb0b690ed2cd81a799abdd",
                                         kPIRConstantsDiscoveryInfoSocialAccounts:
                                             socialAccounts,
                                         kPIRConstantsDiscoveryInfoPierID:
                                             user.pierID?user.pierID:@"",
                                         kPIRConstantsDiscoveryInfoReceiveMode:
                                             user.visibilityOptions,
                                         kPIRConstantsDiscoveryInfoContactNumber:
                                             user.phoneNumber,
                                         };
    }
    return _advertiseDiscoveryInfo;
}

- (MCNearbyServiceAdvertiser*) advertiser
{
    if (!_advertiser) {
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID
                                                        discoveryInfo:self.advertiseDiscoveryInfo
                                                          serviceType:kMCSessionServiceType];
        _advertiser.delegate = self;
    }
    return _advertiser;
}

- (MCNearbyServiceBrowser*) browser
{
    if (!_browser) {
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID
                                                    serviceType:kMCSessionServiceType];
        _browser.delegate = self;
    }
    return _browser;
}

- (NSMutableDictionary*) foundPeers
{
    if (!_foundPeers) {
        _foundPeers = [@{} mutableCopy];
    }
    return _foundPeers;
}

- (NSMutableDictionary*) connectedPeers
{
    if (!_connectedPeers) {
        _connectedPeers = [@{} mutableCopy];
    }
    return _connectedPeers;
}



#pragma mark - Private Methods



#pragma mark - MCNearbyServiceBrowserDelegate Methods

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    DLog(@"Found peer: %@ info:%@", peerID.displayName, info);
    self.foundPeers[peerID] = info;
    
    [self.browser invitePeer:peerID toSession:self.session withContext:[@"Making contact" dataUsingEncoding:NSUTF8StringEncoding] timeout:30.0];

    
}

// A nearby peer has stopped advertisin
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    [self.foundPeers removeObjectForKey:peerID.displayName];
    [self.connectedPeers removeObjectForKey:peerID.displayName];
    self.scanPeersCallback([self.connectedPeers allValues], nil);
}

// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    
}


#pragma mark - MCNearbyServiceAdvertiserDelegate methods 

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{
    
    DLog(@"didReceiveInvitationFromPeer: accept to session: %@", self.session);
    // accept invite
    invitationHandler(YES, self.session);
    
}

#pragma mark - MCSessionDelegate methods

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    DLog(@"didChangeState!!! %i", state);
    switch (state) {
        case MCSessionStateConnected:
        {
            DLog(@"MCSessionStateConnected");
            PIRUser * connectedUser = [peerID pirUserFromPeerID:peerID discoveryInfo:self.foundPeers[peerID]];
            
            // peerID.displayName is the Pier user id
            self.connectedPeers[peerID.displayName] = connectedUser;
            
//            if (_advertiser) {
//                // do nothing?
//                
//            }else if (_browser){
            
                if (self.scanPeersCallback) {
                    self.scanPeersCallback([self.connectedPeers allValues], nil);
                }
                
//            }
        } break;
        case MCSessionStateConnecting:
        {
            DLog(@"MCSessionStateConnecting");
            
        } break;
        case MCSessionStateNotConnected:
        {
            DLog(@"MCSessionStateNotConnected");
            [self.connectedPeers removeObjectForKey:peerID.displayName];
            
        }   break;
        default:
            break;
    }
}

// advertiser receives browser payment data
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DLog(@"didReceiveData: %@", message);
    NSDictionary * jsonObject = [NSJSONSerialization
                     JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    // TODO: save to database
    
    if (jsonObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPIRConstantsReceivedPaymentRequestNotification
                                                            object:peerID
                                                          userInfo:jsonObject];
    }
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{

}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}


@end
