//
//  NSDictionary+jsonString.m

//
//  Created by Kenny Tang on 1/16/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "NSDictionary+jsonString.h"

@implementation NSDictionary (jsonString)

-(NSString*)jsonString
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        NSLog(@"+encodeJSON failed. Error: %@", error);
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
