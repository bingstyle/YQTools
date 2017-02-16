//
//  NSString+Encode_yq.h
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encode_yq)

/**
 *  MD5加密字符串(不可逆)
 */
- (NSString *)yq_md5String;


/*钥匙串访问
 苹果在 iOS 7.0.3版本以后公布钥匙串访问的SDK.钥匙串访问接口是纯C语言的
 钥匙串使用 AES 256加密算法,能够保证用户密码的安全
 钥匙串访问的第三方框架SSKeychain,是对C语言框架的封装.注意:不需要看源码
 钥匙串访问的密码保存在哪里?只有苹果才知道.这样进一步保障了用户的密码安全.
 */


//Base64是一种数据编码方式，目的是让数据符合传输协议的要求。标准Base64编码解码无需额外信息即完全可逆，即使你自己自定义字符集设计一种类Base64的编码方式用于数据加密，在多数场景下也较容易破解。
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;

/**
 *  指纹识别
 *
 *  @param successful 成功回调
 *  @param fail       失败回调
 */
+ (void)fingerprintIdentificationWithSuccess:(void(^)(void))successful fail:(void(^)(NSError *))fail;

@end
