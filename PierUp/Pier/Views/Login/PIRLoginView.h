//
//  PIRLoginView.h

//
//  Created by Kenny Tang on 2/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIRUser.h"

@protocol PIRLoginViewDelegate;

@interface PIRLoginView : UIView

@property (nonatomic, weak) id<PIRLoginViewDelegate> delegate;
@property (nonatomic, strong) PIRUser *currentUser;

@end

@protocol PIRLoginViewDelegate <NSObject>

-(void)loginView:(PIRLoginView*)view didSignIn:(NSString*)userName passcode:(NSString*)passcode;

@end