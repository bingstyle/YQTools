//
//  YQSettingsTimeRangView.h
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/18.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQSettingsTimeRangView : UIView

@property (nonatomic, copy) void(^sureBtnBlock)(NSString *value, NSInteger startH, NSInteger endH);
@property (nonatomic, copy) void(^cancelBtnBlock)(void);

- (instancetype)initStartRow:(NSInteger)startRow endRow:(NSInteger)endRow;

@end
