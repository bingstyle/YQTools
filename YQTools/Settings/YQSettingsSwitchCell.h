//
//  YQSettingsSwitchCell.h
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/15.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQSettingsCellDelegate.h"

@interface YQSettingsSwitchCell : UITableViewCell<YQSettingsCellDelegate>

@property (nonatomic, strong, readonly) UISwitch *switcher;//开关
@property (nonatomic, strong) UIColor *tintColor;//关状态下的背景颜色
@property (nonatomic, strong) UIColor *onTintColor;//开状态下的背景颜色
@property (nonatomic, strong) UIColor *thumbTintColor;//滑块的背景颜色

@end
