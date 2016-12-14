//
//  UIImage+Util_wxb.m
//  Tools
//
//  Created by weixb on 16/10/26.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "UIImage+Util_wxb.h"

@implementation UIImage (Util_wxb)

/**
 *  修改Image 大小
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
