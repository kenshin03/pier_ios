//
//  PIRProfileInfoViewController.h

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIRUser.h"

@protocol PIRProfileInfoViewControllerDelegate;

@interface PIRProfileInfoViewController : UIViewController

@property (nonatomic, weak) id<PIRProfileInfoViewControllerDelegate> delegate;
-(void)refreshData;

@end

@protocol PIRProfileInfoViewControllerDelegate <NSObject>

- (void)profileInfoViewController:(PIRProfileInfoViewController*)vc didEnterEditingMode:(BOOL)didEnter;

@optional

- (void)profileInfoViewController:(PIRProfileInfoViewController*)vc didExitEditingMode:(BOOL)didExit;

@end



@protocol PIRProfileHeaderViewDelegate;

@interface PIRProfileHeaderView : UIView

@property (nonatomic, strong) PIRUser * user;
@property (nonatomic, weak) id<PIRProfileHeaderViewDelegate> delegate;
@end

@protocol PIRProfileHeaderViewDelegate <NSObject>

-(void)profileHeaderView:(PIRProfileHeaderView*)view didRequestPresentImagePicker:(BOOL)request;

@end
