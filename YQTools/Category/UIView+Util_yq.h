//
//  UIView+Util_yq.h
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util_yq)

@property (nonatomic,assign)CGFloat x;
@property (nonatomic,assign)CGFloat y;

@property CGPoint origin;
@property CGSize size;

@property (readonly)CGPoint bottomLeft;
@property (readonly)CGPoint bottomRight;
@property (readonly)CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;


@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

//找到自己的vc
- (UIViewController *)viewController;

@end
