//
//  UIImage+GIF_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface UIImage (GIF_yq)

+ (UIImage *)yq_animatedGIFNamed:(NSString *)name;

+ (UIImage *)yq_animatedGIFWithData:(NSData *)data;

- (UIImage *)yq_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
