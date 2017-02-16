//
//  UIButton+Block_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIButton+Block_yq.h"
#import <objc/runtime.h>
static const void *yq_UIButtonBlockKey = &yq_UIButtonBlockKey;

@implementation UIButton (Block_yq)

-(void)yq_addActionHandler:(WXBTouchedButtonBlock)touchHandler{
    objc_setAssociatedObject(self, yq_UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(yq_blockActionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)yq_blockActionTouched:(UIButton *)btn{
    WXBTouchedButtonBlock block = objc_getAssociatedObject(self, yq_UIButtonBlockKey);
    if (block) {
        block(btn.tag);
    }
}

@end
