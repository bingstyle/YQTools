//
//  NSDictionary+DeleteNull_wxb.h
//  Tools
//
//  Created by weixb on 16/10/26.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DeleteNull_wxb)
/**
 *  将对象中的Null类型转化成@""
 *
 *  @param myObj 被转化对象
 *
 *  @return 返回对象
 */
+(id)changeType:(id)myObj;
@end
