//
//  UIButton+Util_wxb.m
//  Tools
//
//  Created by weixb on 16/10/28.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "UIButton+Util_wxb.h"
#import <objc/runtime.h>

typedef void(^UIButtonClickedBlock)(UIButton *btn);
@implementation UIButton (Util_wxb)

- (void)handleEvent:(UIControlEvents)event USingBlock:(void(^)(UIButton *btn))block {
    // 将属性进行关联
    /**
     *  1. 代表被关联到的对象
     *  2. 代表关联对象所存入value的标示符
     *  3. 代表存入到关联对象的value
     *  4. 代表存入时候的属性修饰符
     */
    objc_setAssociatedObject(self, "btnBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(respondsToBtn:) forControlEvents:event];
}
- (void)respondsToBtn:(UIButton *)sender {
    UIButtonClickedBlock block =
    objc_getAssociatedObject(self, "btnBlock");
    if (block != nil) {
        block(sender);
    }
    
}


@end
