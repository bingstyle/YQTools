//
//  NSDecimalNumber+Extension_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
// Rounding policies :
// Original
//    value 1.2  1.21  1.25  1.35  1.27

// Plain    1.2  1.2   1.3   1.4   1.3
// Down     1.2  1.2   1.2   1.3   1.2
// Up       1.2  1.3   1.3   1.4   1.3
// Bankers  1.2  1.2   1.2   1.4   1.3


@interface NSDecimalNumber (Extension_yq)

/**
 *  @brief  四舍五入 NSRoundPlain
 *
 *  @param scale 限制位数
 *
 *  @return 返回结果
 */
- (NSDecimalNumber*)yq_roundToScale:(NSUInteger)scale;
/**
 *  @brief  四舍五入
 *
 *  @param scale        限制位数
 *  @param roundingMode NSRoundingMode
 *
 *  @return 返回结果
 */
- (NSDecimalNumber*)yq_roundToScale:(NSUInteger)scale mode:(NSRoundingMode)roundingMode;

- (NSDecimalNumber*)yq_decimalNumberWithPercentage:(float)percent;

- (NSDecimalNumber*)yq_decimalNumberWithDiscountPercentage:(NSDecimalNumber *)discountPercentage;

- (NSDecimalNumber*)yq_decimalNumberWithDiscountPercentage:(NSDecimalNumber *)discountPercentage
                                               roundToScale:(NSUInteger)scale;

- (NSDecimalNumber*)yq_discountPercentageWithBaseValue:(NSDecimalNumber *)baseValue;

- (NSDecimalNumber*)yq_discountPercentageWithBaseValue:(NSDecimalNumber *)baseValue
                                           roundToScale:(NSUInteger)scale;

@end
