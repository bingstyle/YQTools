//
//  YQSettings.h
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/15.
//  Copyright © 2017年 weixb. All rights reserved.
//

#ifndef YQSettings_h
#define YQSettings_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YQSettingsTableData.h"
#import "YQSettingsTableDelegate.h"
#import "YQSettingsCellDelegate.h"
#import "YQSettingsSwitchCell.h"
#import "YQSettingsModel.h"
#import "YQSettingsTableView.h"



#define YQKit_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/** 默认开关类名 */
static NSString *const DefaultSwitchClass = @"YQSettingsSwitchCell";
/** 十六进制颜色 */
static inline UIColor *YQSettingsColorWithHex(UInt32 hex) {
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:1];
}
/** 获取view的VC */
static inline UIViewController *YQViewController(UIView *view) {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#endif /* YQSettings_h */
