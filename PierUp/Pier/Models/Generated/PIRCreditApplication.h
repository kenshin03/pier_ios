//
//  PIRCreditApplication.h

//
//  Created by Kenny Tang on 3/1/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIRUser;

@interface PIRCreditApplication : NSManagedObject

@property (nonatomic, retain) NSNumber * result;
@property (nonatomic, retain) NSNumber * qualifiedAmount;
@property (nonatomic, retain) NSNumber * requestedAmount;
@property (nonatomic, retain) PIRUser *user;

@end
