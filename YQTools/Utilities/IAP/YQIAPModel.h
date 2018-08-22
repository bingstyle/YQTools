//
//  YQIAPModel.h
//  YQToolsDemo
//
//  Created by weixb on 2018/8/21.
//  Copyright © 2018年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface YQIAPModel : NSObject<NSCoding>

/**
 * 订单用户.
 */
@property(nonatomic, copy) NSString *account;

/**
 * 后台配置的订单号.
 */
@property(nonatomic, copy) NSString *orderCode;

/**
 * 商品 id.
 */
@property(nonatomic, copy) NSString *productIdentifier;

/**
 * 事务 id.
 */
@property(nonatomic, copy) NSString *transactionIdentifier;

/**
 * 交易时间(添加到交易队列时的时间).
 */
@property(nonatomic, strong) NSDate *transactionDate;

/**
 * 交易收据.
 */
@property(nonatomic, copy) NSString *receipt;

/*
 * 任务被验证的次数.
 * 初始状态为 0,从未和后台验证过.
 * 当次数大于 1 时, 至少和后台验证过一次，并且未能验证当前交易的状态.
 */
@property(nonatomic, assign) NSUInteger modelVerifyCount;

/**
 * 初始化方法.
 */
- (instancetype)initWithAccount:(NSString *)account orderCode:(NSString *)orderCode productId:(NSString *)productId;
//归档成data
- (NSData *)toArchiveData;
//解档data
+ (instancetype)unarchiveWithData:(NSData *)data;

@end
NS_ASSUME_NONNULL_END
