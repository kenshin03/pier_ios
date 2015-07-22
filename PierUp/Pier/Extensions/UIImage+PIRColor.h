//
//  UIImage+PIRColor.h

//
//  Created by Kenny Tang on 12/12/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PIRColor)

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

@end
