//
//  PIRSocialAccount.h

//
//  Created by Kenny Tang on 3/1/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIRUser;

@interface PIRSocialAccount : NSManagedObject

@property (nonatomic, retain) NSString * accountData;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) PIRUser *user;

@end
