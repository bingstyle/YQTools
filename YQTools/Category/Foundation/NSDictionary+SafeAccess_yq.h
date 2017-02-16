//
//  NSDictionary+SafeAccess_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (SafeAccess_yq)

- (BOOL)yq_hasKey:(NSString *)key;

- (NSString*)yq_stringForKey:(id)key;

- (NSNumber*)yq_numberForKey:(id)key;

- (NSDecimalNumber *)yq_decimalNumberForKey:(id)key;

- (NSArray*)yq_arrayForKey:(id)key;

- (NSDictionary*)yq_dictionaryForKey:(id)key;

- (NSInteger)yq_integerForKey:(id)key;

- (NSUInteger)yq_unsignedIntegerForKey:(id)key;

- (BOOL)yq_boolForKey:(id)key;

- (int16_t)yq_int16ForKey:(id)key;

- (int32_t)yq_int32ForKey:(id)key;

- (int64_t)yq_int64ForKey:(id)key;

- (char)yq_charForKey:(id)key;

- (short)yq_shortForKey:(id)key;

- (float)yq_floatForKey:(id)key;

- (double)yq_doubleForKey:(id)key;

- (long long)yq_longLongForKey:(id)key;

- (unsigned long long)yq_unsignedLongLongForKey:(id)key;

- (NSDate *)yq_dateForKey:(id)key dateFormat:(NSString *)dateFormat;

//CG
- (CGFloat)yq_CGFloatForKey:(id)key;

- (CGPoint)yq_pointForKey:(id)key;

- (CGSize)yq_sizeForKey:(id)key;

- (CGRect)yq_rectForKey:(id)key;

@end


#pragma --mark NSMutableDictionary
@interface NSMutableDictionary (SafeAccess_yq)

-(void)yq_setObj:(id)i forKey:(NSString*)key;

-(void)yq_setString:(NSString*)i forKey:(NSString*)key;

-(void)yq_setBool:(BOOL)i forKey:(NSString*)key;

-(void)yq_setInt:(int)i forKey:(NSString*)key;

-(void)yq_setInteger:(NSInteger)i forKey:(NSString*)key;

-(void)yq_setUnsignedInteger:(NSUInteger)i forKey:(NSString*)key;

-(void)yq_setCGFloat:(CGFloat)f forKey:(NSString*)key;

-(void)yq_setChar:(char)c forKey:(NSString*)key;

-(void)yq_setFloat:(float)i forKey:(NSString*)key;

-(void)yq_setDouble:(double)i forKey:(NSString*)key;

-(void)yq_setLongLong:(long long)i forKey:(NSString*)key;

-(void)yq_setPoint:(CGPoint)o forKey:(NSString*)key;

-(void)yq_setSize:(CGSize)o forKey:(NSString*)key;

-(void)yq_setRect:(CGRect)o forKey:(NSString*)key;

@end

