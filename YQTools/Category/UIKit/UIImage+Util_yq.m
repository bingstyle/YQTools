//
//  UIImage+Util_yq.m
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "UIImage+Util_yq.h"

@implementation UIImage (Util_yq)

//合成加半透明水印
- (UIImage *)yq_addMsakImage:(UIImage *)maskImage msakRect:(CGRect)rect
{
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size,NO,0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    [maskImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//压缩图片
- (UIImage *)yq_compressImage
{
    // UIImageJPEGRepresentation第二个参数为压缩比率
    NSData *data=UIImageJPEGRepresentation(self, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(self, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(self, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(self, 0.9);
        }
    }
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

//改变图片大小
- (UIImage *)yq_changeImageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//等比例缩放
- (UIImage*)yq_scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
//图片切成圆形
- (instancetype)yq_circleImage
{
    // 1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size,NO,0);
    
    // 2.描述圆形路径
    UIBezierPath*path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,self.size.width,self.size.height)];
    
    // 3.设置裁剪区域
    [path addClip];
    
    // 4.画图
    [self drawAtPoint:CGPointZero];
    
    // 5.取出图片
    UIImage*image =UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
+ (instancetype)yq_circleImage:(NSString *)image
{
    return [[self imageNamed:image] yq_circleImage];
}


@end
