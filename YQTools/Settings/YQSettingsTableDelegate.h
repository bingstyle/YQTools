//
//  YQSettingsTableDelegate.h
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/15.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YQSettingsTableDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

- (instancetype) initWithTableData:(NSArray *(^)(void))data;

@end
