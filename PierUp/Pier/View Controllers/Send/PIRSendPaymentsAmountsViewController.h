//
//  PIRSendPaymentsAmountsViewController.h

//
//  Created by Kenny Tang on 12/13/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIRUser.h"

@interface PIRSendPaymentsAmountsViewController : UIViewController

@property (nonatomic, strong) PIRUser * toUser;

@end


@interface PIRPayeeInfoView : UIView

@property (nonatomic, strong) PIRUser * user;

-(void)updateViewWithUser:(PIRUser*)user;

@end

