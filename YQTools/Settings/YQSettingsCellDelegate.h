//
//  YQSettingsCellDelegate.h
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/15.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YQSettingsTableRow;

@protocol YQSettingsCellDelegate <NSObject>

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@optional
- (void)refreshData:(YQSettingsTableRow *)rowData tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
