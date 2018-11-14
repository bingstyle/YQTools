//
//  MLIAPManager.m
//  MiLove
//
//  Created by weixb on 2017/12/4.
//  Copyright © 2017年 YQHD. All rights reserved.
//

#import "YQIAPManager.h"
#import "YQIAPStore.h"
//#import <SVProgressHUD.h>
#import "SAMKeychain.h"
#import "SAMKeychainQuery.h"


@implementation YQIAPManager

#pragma mark - public
/** 获取IAP商品 */
+ (void)requestProducts {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IAP" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    [[YQIAPStore defaultStore] getProducts:array];
}

/** 发起IAP支付 */
+ (void)goIAPWithModel:(YQIAPModel *)model view:(UIView *)view success:(void (^)(NSString *))success {
    view.userInteractionEnabled = NO;
//    [SVProgressHUD showWithStatus:@"正在连接服务器..."];
    [[YQIAPStore defaultStore] buyProduct:model.productIdentifier account:model.account success:^(NSString *receipt, SKPaymentTransaction *transaction) {
        view.userInteractionEnabled = YES;
        if (success) { success(receipt); }
        //服务器二次验证
        model.transactionIdentifier = transaction.transactionIdentifier;
        model.transactionDate = transaction.transactionDate;
        model.receipt = receipt;
        [[self class] fetchVerifyWithModel:model];
    } fail:^(NSError *error) {
        view.userInteractionEnabled = YES;
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}

/** 重新验证用户订单 */
+ (void)restoreOderVerifyWithAccount:(NSString *)account {
    SAMKeychainQuery *query = [SAMKeychainQuery new];
    query.account = account;
    NSError *error = nil;
    NSArray *array = [query fetchAll:&error];
    for (NSDictionary *dic in array) {
        YQIAPModel *model = [YQIAPModel unarchiveWithData:[SAMKeychain passwordDataForService:dic[@"svce"] account:account]];
        //再次验证
        [[self class] fetchVerifyWithModel:model];
    }
}


#pragma mark - private
/** 服务器验证IAP支付收据 */
+ (void)fetchVerifyWithModel:(YQIAPModel *)model {
    
    NSDictionary *params = @{@"receipt": model.receipt ?: @"",
                             @"transactionId": model.productIdentifier ?: @"",
                             @"orderCode": model.orderCode ?: @"",
                             };
    NSLog(@"%@", params);
//    [SVProgressHUD showInfoWithStatus:@"正在验证订单..."];
    //验证接口（成功后调用deletePaymentTransactionWithModel，失败则调用updatePaymentTransactionWithModel）
    
}


#pragma mark - keychain管理交易
//存储交易model到keychain
+ (void)savePaymentTransactionWithModel:(YQIAPModel *)model {
    [SAMKeychain setPasswordData:[model toArchiveData] forService:model.orderCode account:model.account];
}
//更新对应订单号的keychain数据
+ (void)updatePaymentTransactionWithModel:(YQIAPModel *)model {
    model.modelVerifyCount += 1;
    if (model.modelVerifyCount < 10) {
        [[self class] savePaymentTransactionWithModel:model];
    } else {
        [[self class] deletePaymentTransactionWithModel:model];
    }
}
//删除对应订单号的keychain数据
+ (void)deletePaymentTransactionWithModel:(YQIAPModel *)model {
    [SAMKeychain deletePasswordForService:model.orderCode account:model.account];
}



@end







