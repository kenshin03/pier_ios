//
//  PIRTransaction.h

//
//  Created by Kenny Tang on 3/13/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIRUser;

@interface PIRTransaction : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * requestType;
@property (nonatomic, retain) NSDate * scheduledDate;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * transactionID;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) PIRUser *fromUser;
@property (nonatomic, retain) PIRUser *toUser;

@end
