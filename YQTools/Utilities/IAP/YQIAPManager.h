//
//  MLIAPManager.h
//  MiLove
//
//  Created by weixb on 2017/12/4.
//  Copyright © 2017年 YQHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YQIAPModel.h"

@interface YQIAPManager : NSObject

/** 获取IAP商品 */
+ (void)requestProducts;
/** 发起IAP支付 */
+ (void)goIAPWithModel:(YQIAPModel *)model view:(UIView *)view success:(void (^)(NSString *receipt))success;
/** 重新验证用户订单 */
+ (void)restoreOderVerifyWithAccount:(NSString *)account;

@end
