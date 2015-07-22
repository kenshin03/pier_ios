//
//  PIRProfileViewController.h

//
//  Created by Kenny Tang on 1/2/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIRUser.h"
typedef void (^OptionButtonTappedSuccessBlock)();


@interface PIRProfileViewController : UIViewController

-(void)highlightStatementsScreen;
@end


typedef NS_ENUM(NSUInteger, PIRProfileMenuViewType)
{
    PIRProfileMenuViewTypeInfo=1,
    PIRProfileMenuViewTypeBanks,
    PIRProfileMenuViewTypeCredit,
    PIRProfileMenuViewTypeDiscover,
    PIRProfileMenuViewTypeStatements,
};


@protocol PIRProfileMenuViewDelegate;

@interface PIRProfileMenuView : UIView

- (void)setSelectedViewType:(PIRProfileMenuViewType)type;
@property (nonatomic, weak) id<PIRProfileMenuViewDelegate>delegate;

@end

@protocol PIRProfileMenuViewDelegate <NSObject>

-(void)profileMenuView:(PIRProfileMenuView*)view infoButtonTapped:(BOOL)tapped;
-(void)profileMenuView:(PIRProfileMenuView*)view banksButtonTapped:(BOOL)tapped;
-(void)profileMenuView:(PIRProfileMenuView*)view creditButtonTapped:(BOOL)tapped;
-(void)profileMenuView:(PIRProfileMenuView*)view visibilityButtonTapped:(BOOL)tapped;
-(void)profileMenuView:(PIRProfileMenuView*)view statementsButtonTapped:(BOOL)tapped;

@end




@interface PIRProfileOptionsButtonView : UIView

@property (nonatomic, readonly) UILabel * optionTitleLabel;
@property (nonatomic, strong) OptionButtonTappedSuccessBlock actionBlock;

@end