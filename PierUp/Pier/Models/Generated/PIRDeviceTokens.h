//
//  PIRDeviceTokens.h

//
//  Created by Kenny Tang on 3/1/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIRUser;

@interface PIRDeviceTokens : NSManagedObject

@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) PIRUser *user;

@end
