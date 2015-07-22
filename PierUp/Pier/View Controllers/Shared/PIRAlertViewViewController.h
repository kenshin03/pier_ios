//
//  PIRAlertViewViewController.h

//
//  Created by Kenny Tang on 12/18/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertViewCallback)(NSUInteger selectedButtonIndex, BOOL canceledButtonTapped);


@interface PIRAlertViewViewController : UIViewController

- (instancetype)initWithTitle:(NSString*)title desc:(NSString*)desc buttonsLabels:(NSArray*)buttonLabels completion:(AlertViewCallback)completion;

@end


