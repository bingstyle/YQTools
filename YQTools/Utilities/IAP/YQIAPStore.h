//
//  YQIAPStore.h
//  MiLove
//
//  Created by weixb on 2017/12/6.
//  Copyright © 2017年 YQHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void(^YQIAPSuccessBlock)(NSString *receipt, SKPaymentTransaction *transaction);
typedef void(^YQIAPFailBlock)(NSError *error);

@interface YQIAPStore : NSObject

/** 单例 */
+ (instancetype)defaultStore;
/** 获取商品 */
- (void)getProducts:(NSArray *)identifiers;
/** 恢复购买（非消耗性商品） */
- (BOOL)restorePurchase;
/** 发起购买 */
- (void)buyProduct:(NSString *)productIdentifier
           success:(YQIAPSuccessBlock)success
              fail:(YQIAPFailBlock)fail;

- (void)buyProduct:(NSString *)productIdentifier
           account:(NSString*)account
           success:(YQIAPSuccessBlock)success
              fail:(YQIAPFailBlock)fail;


@end
