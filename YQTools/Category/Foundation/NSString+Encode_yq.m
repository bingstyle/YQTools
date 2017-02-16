//
//  NSString+Encode_yq.m
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "NSString+Encode_yq.h"
#import <CommonCrypto/CommonDigest.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>

#import "NSData+Encrypt_yq.h"
#import "NSData+Base64_yq.h"

@implementation NSString (Encode_yq)

/**
 *  MD5加密字符串
 */
- (NSString *)yq_md5String {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    
    return ret;
}

- (NSString*)base64EncodedString {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


#pragma mark - 指纹识别
+ (void)fingerprintIdentificationWithSuccess:(void(^)(void))successful fail:(void(^)(NSError *))fail {
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    // 判断当前系统版本
    if (version < 8.0 )  {
        NSLog(@"系统版本太低,请升级至最新系统");
        return;
    }
    // 1> 实例化指纹识别对象
    LAContext *laCtx = [[LAContext alloc] init];
    
    // 2> 判断当前设备是否支持指纹识别功能.
    if (![laCtx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
        
        // 如果设备不支持指纹识别功能
        NSLog(@"该设备不支持指纹识别功能");
        
        return;
    };
    [laCtx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹登陆" reply:^(BOOL success, NSError *error) {
        // 如果成功,表示指纹输入正确.
        if (success) {
            NSLog(@"指纹识别成功!");
            successful();
        } else {
            NSLog(@"指纹识别错误,请再次尝试");
            fail(error);
        }
    }];
}

-(NSString*)yq_encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] yq_encryptedWithAESUsingKey:key andIV:iv];
    NSString *encryptedString = [encrypted yq_base64EncodedString];
    
    return encryptedString;
}

- (NSString*)yq_decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *decrypted = [[NSData yq_dataWithBase64EncodedString:self] yq_decryptedWithAESUsingKey:key andIV:iv];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

- (NSString*)yq_encryptedWithDESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] yq_encryptedWithDESUsingKey:key andIV:iv];
    NSString *encryptedString = [encrypted yq_base64EncodedString];
    
    return encryptedString;
}

- (NSString*)yq_decryptedWithDESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *decrypted = [[NSData yq_dataWithBase64EncodedString:self] yq_decryptedWithDESUsingKey:key andIV:iv];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

- (NSString*)yq_encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] yq_encryptedWith3DESUsingKey:key andIV:iv];
    NSString *encryptedString = [encrypted yq_base64EncodedString];
    
    return encryptedString;
}

- (NSString*)yq_decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *decrypted = [[NSData yq_dataWithBase64EncodedString:self] yq_decryptedWith3DESUsingKey:key andIV:iv];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

@end
