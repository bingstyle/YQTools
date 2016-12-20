//
//  UIImage+Util_yq.h
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util_yq)

/**
 *  合成加半透明水印
 *
 *  @param maskImage 水印图
 *  @param rect      水印图位置
 *
 *  @return
 */
- (UIImage *)yq_addMsakImage:(UIImage *)maskImage msakRect:(CGRect)rect;

/**
 *  压缩图片
 *
 *  @return 压缩后的图片
 */
- (UIImage *)yq_compressImage;

/**
 *  改变图片大小
 *
 *  @param size 改变后的尺寸
 *
 *  @return 改变后的图片
 */
- (UIImage *)yq_changeImageSize:(CGSize)size;

/**
 *  截取部分图像
 *
 *  @param rect 截取位置
 *
 *  @return 截取后的图片
 */
- (UIImage*)yq_clipSubImage:(CGRect)rect;

/**
 *  等比例缩放
 *
 *  @param size 缩放尺寸
 *
 *  @return 缩放后的图片
 */
- (UIImage*)yq_scaleToSize:(CGSize)size;

@end
