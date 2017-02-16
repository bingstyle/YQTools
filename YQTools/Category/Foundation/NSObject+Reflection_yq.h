//
//  NSObject+Reflection_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Reflection_yq)

//类名
- (NSString *)yq_className;
+ (NSString *)yq_className;
//父类名称
- (NSString *)yq_superClassName;
+ (NSString *)yq_superClassName;

//实例属性字典
- (NSDictionary *)yq_propertyDictionary;

//属性名称列表
- (NSArray*)yq_propertyKeys;
+ (NSArray *)yq_propertyKeys;

//属性详细信息列表
- (NSArray *)yq_propertiesInfo;
+ (NSArray *)yq_propertiesInfo;

//格式化后的属性列表
+ (NSArray *)yq_propertiesWithCodeFormat;

//方法列表
- (NSArray*)yq_methodList;
+ (NSArray*)yq_methodList;

- (NSArray*)yq_methodListInfo;

//创建并返回一个指向所有已注册类的指针列表
+ (NSArray *)yq_registedClassList;
//实例变量
+ (NSArray *)yq_instanceVariable;

//协议列表
-(NSDictionary *)yq_protocolList;
+ (NSDictionary *)yq_protocolList;


- (BOOL)yq_hasPropertyForKey:(NSString*)key;
- (BOOL)yq_hasIvarForKey:(NSString*)key;

@end
