//
//  PIRTests.m

//
//  Created by Kenny Tang on 2/17/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRTests.h"
#define MR_SHORTHAND

@implementation PIRTests

- (void)setUp
{
    [super setUp];
    [self setUpCoreDataStack];
}

#pragma mark - setUpTestCoreDataStack

- (void)setUpCoreDataStack
{
    [self tearDownCoreDataStack];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Pier-test.sqlite"];
}


- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [self tearDownCoreDataStack];
}

- (void)tearDownCoreDataStack
{
    NSString *storeName = @"Pier-test.sqlite";
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:storeName];
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:storeName];
    
    // doesnt seem to work cleanly
    NSArray *stores = coordinator.persistentStores;
    [stores enumerateObjectsUsingBlock:^(NSPersistentStore *store, NSUInteger idx, BOOL *stop) {
        if ([store.URL.absoluteString isEqualToString:storeURL.absoluteString]) {
            [coordinator removePersistentStore:store error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
        }
    }];
}

@end
