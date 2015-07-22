//
//  PIRSeparator.m

//
//  Created by Kenny Tang on 12/13/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRSeparator.h"

@implementation PIRSeparator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0.0f, 0.0f, 320.0, 1.0)];
    self.backgroundColor = [PIRColor separatorColor];
    return self;
}



@end
