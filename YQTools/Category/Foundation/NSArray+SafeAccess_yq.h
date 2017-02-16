//
//  NSArray+SafeAccess_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (SafeAccess_yq)

-(id)yq_objectWithIndex:(NSUInteger)index;

- (NSString*)yq_stringWithIndex:(NSUInteger)index;

- (NSNumber*)yq_numberWithIndex:(NSUInteger)index;

- (NSDecimalNumber *)yq_decimalNumberWithIndex:(NSUInteger)index;

- (NSArray*)yq_arrayWithIndex:(NSUInteger)index;

- (NSDictionary*)yq_dictionaryWithIndex:(NSUInteger)index;

- (NSInteger)yq_integerWithIndex:(NSUInteger)index;

- (NSUInteger)yq_unsignedIntegerWithIndex:(NSUInteger)index;

- (BOOL)yq_boolWithIndex:(NSUInteger)index;

- (int16_t)yq_int16WithIndex:(NSUInteger)index;

- (int32_t)yq_int32WithIndex:(NSUInteger)index;

- (int64_t)yq_int64WithIndex:(NSUInteger)index;

- (char)yq_charWithIndex:(NSUInteger)index;

- (short)yq_shortWithIndex:(NSUInteger)index;

- (float)yq_floatWithIndex:(NSUInteger)index;

- (double)yq_doubleWithIndex:(NSUInteger)index;

- (NSDate *)yq_dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat;
//CG
- (CGFloat)yq_CGFloatWithIndex:(NSUInteger)index;

- (CGPoint)yq_pointWithIndex:(NSUInteger)index;

- (CGSize)yq_sizeWithIndex:(NSUInteger)index;

- (CGRect)yq_rectWithIndex:(NSUInteger)index;

@end

#pragma --mark NSMutableArray
@interface NSMutableArray (SafeAccess_yq)

-(void)yq_addObj:(id)i;

-(void)yq_addString:(NSString*)i;

-(void)yq_addBool:(BOOL)i;

-(void)yq_addInt:(int)i;

-(void)yq_addInteger:(NSInteger)i;

-(void)yq_addUnsignedInteger:(NSUInteger)i;

-(void)yq_addCGFloat:(CGFloat)f;

-(void)yq_addChar:(char)c;

-(void)yq_addFloat:(float)i;

-(void)yq_addPoint:(CGPoint)o;

-(void)yq_addSize:(CGSize)o;

-(void)yq_addRect:(CGRect)o;

@end
