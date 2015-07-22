//
//  PIRProfileTransactionCell.h

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIRProfileTransactionCell : UITableViewCell

@property (nonatomic, readonly) UILabel *amountLabel;
@property (nonatomic, readonly) UILabel *actionLabel;

@property (nonatomic, readonly) UILabel *fromUserLabel;
@property (nonatomic, readonly) UILabel *toUserLabel;

@property (nonatomic, readonly) UILabel *timestampLabel;
@property (nonatomic, readonly) UILabel *statusLabel;


@end
