//
//  PIRSwitchFieldElementView.h

//
//  Created by Kenny Tang on 2/7/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRSwitchFieldElementViewDelegate;

@interface PIRSwitchFieldElementView : UIView

@property (nonatomic, readonly) UISwitch *switchControl;


/**
 *  Default init method
 *
 *  @param titleValue title of the label that appears next to the text field
 *  @param typeValue  specify the type of keyboard to open up
 *  @param tagValue   a tag to identify textfield for delegates
 *  @param delegate   delegate to the textfield subview
 *
 *  @return instance of class
 */
- (instancetype) initSwitchFieldElementViewWith:(NSString *)titleValue
                                     delagate:(id<PIRSwitchFieldElementViewDelegate>)delegate;

@end


@protocol PIRSwitchFieldElementViewDelegate <NSObject>

-(void)switchFieldElementView:(PIRSwitchFieldElementView*)view switchValueChanged:(BOOL)isOn;

@end