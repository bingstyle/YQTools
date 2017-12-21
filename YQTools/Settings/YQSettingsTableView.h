//
//  YQSettingsTableView.h
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/15.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YQSettingsTableView;

@protocol YQSettingsTableViewDelegate <NSObject>

@required
/** 配置列表数据 */
- (NSArray *)dataWithTableView:(YQSettingsTableView *)tableView;
@optional
/** 刷新列表 */
- (void)refreshTableView:(YQSettingsTableView *)tableView;

@end

@interface YQSettingsTableView : UITableView

@property (nonatomic, weak) id<YQSettingsTableViewDelegate> delegater;

/* 默认列表数据 */
- (NSArray *)defaultListData;

@end
