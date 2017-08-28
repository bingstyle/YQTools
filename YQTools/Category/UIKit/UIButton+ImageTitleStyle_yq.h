//
//  UIButton+ImageTitleStyle_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/7/24.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 针对同时设置了Image和Title的场景时UIButton中的图片和文字的关系
 */
typedef NS_ENUM(NSInteger, YQButtonImageTitleStyle ) {
    YQButtonImageTitleStyleDefault = 0,       //图片在左，文字在右，整体居中。
    YQButtonImageTitleStyleLeft  = 0,         //图片在左，文字在右，整体居中。
    YQButtonImageTitleStyleRight     = 2,     //图片在右，文字在左，整体居中。
    YQButtonImageTitleStyleTop  = 3,          //图片在上，文字在下，整体居中。
    YQButtonImageTitleStyleBottom    = 4,     //图片在下，文字在上，整体居中。
    YQButtonImageTitleStyleCenterTop = 5,     //图片居中，文字在上距离按钮顶部。
    YQButtonImageTitleStyleCenterBottom = 6,  //图片居中，文字在下距离按钮底部。
    YQButtonImageTitleStyleCenterUp = 7,      //图片居中，文字在图片上面。
    YQButtonImageTitleStyleCenterDown = 8,    //图片居中，文字在图片下面。
    YQButtonImageTitleStyleRightLeft = 9,     //图片在右，文字在左，距离按钮两边边距
    YQButtonImageTitleStyleLeftRight = 10,    //图片在左，文字在右，距离按钮两边边距
};

@interface UIButton (ImageTitleStyle_yq)
/*
 调整按钮的文本和image的布局，前提是title和image同时存在才会调整。
 padding是调整布局时整个按钮和图文的间隔。
 
 */
-(void)yq_buttonImageTitleStyle:(YQButtonImageTitleStyle)style padding:(CGFloat)padding;

@end
