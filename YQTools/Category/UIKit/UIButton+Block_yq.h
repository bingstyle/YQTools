//
//  UIButton+Block_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WXBTouchedButtonBlock)(NSInteger tag);

@interface UIButton (Block_yq)

- (void)yq_addActionHandler:(WXBTouchedButtonBlock)touchHandler;

@end
