//
//  YQBaseArchiveModel.h
//  YQToolsDemo
//
//  Created by weixb on 2017/7/27.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQBaseArchiveModel : NSObject

+ (instancetype)sharedModel;
- (void)archive;
- (void)deleteDate;

@end
