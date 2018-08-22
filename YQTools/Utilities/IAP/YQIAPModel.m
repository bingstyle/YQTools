//
//  YQIAPModel.m
//  YQToolsDemo
//
//  Created by weixb on 2018/8/21.
//  Copyright © 2018年 weixb. All rights reserved.
//

#import "YQIAPModel.h"
@import ObjectiveC.runtime;

static NSString * const YQWalletErrorDomain = @"com.yqhd.wallet.error";
static NSUInteger const YQPaymentTransactionModelVerifyWarningCount = 10; // 最多验证次数，如果超过这个值就报警。

@implementation YQIAPModel

- (instancetype)initWithAccount:(NSString *)account orderCode:(NSString *)orderCode productId:(NSString *)productId
{
    NSParameterAssert(account);
    NSParameterAssert(orderCode);
    NSParameterAssert(productId);
    NSString *errorString = nil;
    if (!account.length || !orderCode.length || !productId.length) {
        errorString = [NSString stringWithFormat:@"致命错误: 初始化商品交易模型时, productIdentifier: %@, transactionIdentifier: %@, transactionDate: %@ 中有数据为空", account, orderCode, productId];
    }
    if (errorString) {
        // 报告错误.
        NSError *error = [NSError errorWithDomain:YQWalletErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : errorString}];
    }
    self = [super init];
    if (self) {
        _account = account;
        _orderCode = orderCode;
        _productIdentifier = productId;
        _modelVerifyCount = 0;
    }
    return self;
}

- (void)setModelVerifyCount:(NSUInteger)modelVerifyCount {
    _modelVerifyCount = modelVerifyCount;
    
    if (modelVerifyCount > YQPaymentTransactionModelVerifyWarningCount) {
        // 报告错误.
        NSString *errorString = [NSString stringWithFormat:@"验证次数超过最大验证次数: %@", self];
        NSError *error = [NSError errorWithDomain:YQWalletErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : errorString}];
        // todo
    }
}

#pragma mark - public methods
//归档成data
- (NSData *)toArchiveData {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}
//解档data
+ (instancetype)unarchiveWithData:(NSData *)data {
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - NSCoding协议
// 利用runtime机制进行属性的归档接档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name]; id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}


@end
