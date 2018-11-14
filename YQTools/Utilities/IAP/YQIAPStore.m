//
//  YQIAPStore.m
//  MiLove
//
//  Created by weixb on 2017/12/6.
//  Copyright © 2017年 YQHD. All rights reserved.
//

#import "YQIAPStore.h"

@interface YQIAPStore () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSMutableDictionary *_products;
}
/** 支付成功回调 */
@property (nonatomic, copy) YQIAPSuccessBlock successBlock;
/** 支付失败回调 */
@property (nonatomic, copy) YQIAPFailBlock failBlock;

@end

@implementation YQIAPStore
- (instancetype)init
{
    self = [super init];
    if (self) {
        _products = [NSMutableDictionary dictionary];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
#pragma mark - ================ Singleton =================

static id instance; // 单例（全局变量）

/** 单例方法 */
+ (instancetype)defaultStore {
    // 使用GCD确保只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - ================ Public Methods =================

/** 获取商品 */
- (void)getProducts:(NSArray *)identifiers {
    if (![self canMakePayments]) {
        return ;
    }
    if (identifiers.count > 0) {
        NSLog(@"请求商品: %@", identifiers);
        SKProductsRequest *productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithArray:identifiers]];
        productRequest.delegate = self;
        [productRequest start];
    } else {
        NSLog(@"商品ID为空");
    }
}

/** 完成交易 */
- (void)finishTransactionWith:(NSString *)transactionIdentifier {
    // 未完成的列表.
    NSArray<SKPaymentTransaction *> *transactionsWaitingForVerifing = [[SKPaymentQueue defaultQueue] transactions];
    SKPaymentTransaction *transaction = nil;
    for (SKPaymentTransaction *item in transactionsWaitingForVerifing) {
        if ([transactionIdentifier isEqualToString:item.transactionIdentifier]) {
            transaction = item;
            break;
        }
    }
    if (!transaction) {
        NSLog(@"交易不存在");
    } else {
        // 不能完成一个正在交易的订单.
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            return;
        }
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}


#pragma mark ==== 购买商品
- (void)buyProduct:(NSString *)productIdentifier success:(YQIAPSuccessBlock)success fail:(YQIAPFailBlock)fail {
    [self buyProduct:productIdentifier account:nil success:success fail:fail];
}

- (void)buyProduct:(NSString *)productIdentifier account:(NSString *)account success:(YQIAPSuccessBlock)success fail:(YQIAPFailBlock)fail {
    SKProduct *product = [self productForIdentifier:productIdentifier];
    if (product == nil)
    {
        NSLog(@"unknown product id %@", productIdentifier);
        if (fail != nil)
        {
            NSError *error = [NSError errorWithDomain:@"yq.store" code:100 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedStringFromTable(@"Unknown product identifier", @"RMStore", @"Error description")}];
            fail(error);
        }
        return;
    }
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    if ([payment respondsToSelector:@selector(setApplicationUsername:)])
    {
        payment.applicationUsername = account;
    }
    self.successBlock = success;
    self.failBlock = fail;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark ==== 商品恢复（非消耗性商品）
- (BOOL)restorePurchase {
    
    if ([self canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        return YES;
    }
    return NO;
}

#pragma mark - ================ SKProductsRequest Delegate =================
/** 获取商品成功的回调 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *products = response.products;
    if (products.count > 0) {
        NSLog(@"products:%@", products);
        //购买商品
        for (SKProduct *product in products) {
            _products[product.productIdentifier] = product;
        }
    } else {
        NSLog(@"获取IAP商品信息失败");
    }
}

#pragma mark - ================ SKPaymentTransactionObserver Delegate =================

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    // 这里的事务包含之前没有完成的.
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStatePurchased://交易成功
                NSLog(@"购买完成,向自己的服务器验证 ---- %@", transaction.payment.applicationUsername);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                NSLog(@"交易失败");
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已购买过该商品(对于非消耗产品的操作)
                NSLog(@"已经购买过该商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred://交易延迟
                NSLog(@"交易延迟");
                break;
            default:
                NSLog(@"支付发生未知情况");
                break;
        }
    }
}

#pragma mark - ================ Private Methods =================
/** 能否支付 */
- (BOOL)canMakePayments {
    if ([SKPaymentQueue canMakePayments]) {
        return YES;
    }
    NSLog(@"失败，用户禁止应用内付费购买.");
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"In App Purchasing Disabled", @"")
                                                                        message:NSLocalizedString(@"Check your parental control settings and try again later", @"")
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController
     presentViewController:controller animated:YES completion:nil];
    return NO;
}
//购买成功
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    /*[[SKPaymentQueue defaultQueue] finishTransaction: transaction];:完成交易方法，如果不注销会出现报错和苹果服务器不停的通知监听方法等等情况。总之，记住要注销交易。
     当购买在苹果后台支付成功时，如果你的App没有调用这个方法，那么苹果就不会认为这次交易彻底成功，当你的App再次启动，并且设置了内购的监听时，监听方法- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions就会被调用，直到你调用了上面的方法，注销了这次交易，苹果才会认为这次交易彻底完成。
     利用这个特性，我们可以将购买后完成交易方法放到我们向自家后台发送交易成功后调用。
     */
    //获取收据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    if (!receiptData) {
        NSLog(@"交易凭证不存在");//越狱设备和Mac OS会有，非越狱iOS设备不存在此种情况
    }
    if (self.successBlock) {
        NSString * base64EncodeReceipt = [receiptData base64EncodedStringWithOptions:0];
        self.successBlock(base64EncodeReceipt, transaction);
    }
}
//购买失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSLog(@"%@", transaction.error.localizedDescription);
    if (self.failBlock && transaction.error) {
        self.failBlock(transaction.error);
    }
}

#pragma mark Product management

- (SKProduct*)productForIdentifier:(NSString*)productIdentifier
{
    return _products[productIdentifier];
}

+ (NSString*)localizedPriceOfProduct:(SKProduct*)product
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.locale = product.priceLocale;
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    return formattedString;
}

@end
