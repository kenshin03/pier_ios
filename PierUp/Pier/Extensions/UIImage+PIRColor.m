//
//  UIImage+PIRColor.m

//
//  Created by Kenny Tang on 12/12/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "UIImage+PIRColor.h"

@implementation UIImage (PIRColor)

+ (UIImage *)imageFromColor:(UIColor *)color
{
    return [[self imageFromColor:color size:CGSizeMake(1, 1)]
            resizableImageWithCapInsets:UIEdgeInsetsZero];
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size
{
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, bounds);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
