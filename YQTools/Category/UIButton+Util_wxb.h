//
//  UIButton+Util_wxb.h
//  Tools
//
//  Created by weixb on 16/10/28.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Util_wxb)

- (void)handleEvent:(UIControlEvents)event USingBlock:(void(^)(UIButton *btn))block;

@end
