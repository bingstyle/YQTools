//
//  YQSettingsTableDelegate.m
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/15.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "YQSettingsTableDelegate.h"
#import "YQSettings.h"

#define SepViewTag 10001

@interface YQSettingsTableDelegate ()
@property (nonatomic, copy) NSArray *(^YQSettingsDataReceiver)(void);
@end


@implementation YQSettingsTableDelegate

- (instancetype) initWithTableData:(NSArray *(^)(void))data {
    self = [super init];
    if (self) {
        _YQSettingsDataReceiver = data;
    }
    return self;
}

- (NSArray *)data {
    return self.YQSettingsDataReceiver();
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YQSettingsTableSection *tableSection = self.data[section];
    return tableSection.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YQSettingsTableSection *tableSection = self.data[indexPath.section];
    YQSettingsTableRow     *tableRow     = tableSection.rows[indexPath.row];
    NSString *defaultTableCell = NSStringFromClass([UITableViewCell class]);
    NSString *identity = tableRow.cellClassName.length ? tableRow.cellClassName : defaultTableCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        Class clazz = NSClassFromString(identity);
        cell = [[clazz alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    if (![cell respondsToSelector:@selector(refreshData:tableView:indexPath:)]) {
        UITableViewCell *defaultCell = (UITableViewCell *)cell;
        [self refreshData:tableRow cell:defaultCell];
    }else{
        [(id<YQSettingsCellDelegate>)cell refreshData:tableRow tableView:tableView indexPath:indexPath];
    }
    cell.accessoryType = tableRow.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins      = UIEdgeInsetsZero;
    cell.separatorInset     = UIEdgeInsetsZero;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITableViewDelegate

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQSettingsTableSection *tableSection = self.data[indexPath.section];
    YQSettingsTableRow     *tableRow     = tableSection.rows[indexPath.row];
    return tableRow.uiRowHeight;
}
// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    return UITableViewAutomaticDimension;
    YQSettingsTableSection *tableSection = self.data[indexPath.section];
    YQSettingsTableRow     *tableRow     = tableSection.rows[indexPath.row];
    return tableRow.uiRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YQSettingsTableSection *tableSection = self.data[indexPath.section];
    YQSettingsTableRow     *tableRow     = tableSection.rows[indexPath.row];
    if (!tableRow.forbidSelect) {
        UIViewController *vc = YQViewController(tableView);
        NSString *actionName = tableRow.cellActionName;
        if (actionName.length) {
            SEL sel = NSSelectorFromString(actionName);
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([vc respondsToSelector:sel]) {
                YQKit_SuppressPerformSelectorLeakWarning([vc performSelector:sel withObject:cell]);
            }
            else if ([tableView respondsToSelector:sel]) {
                YQKit_SuppressPerformSelectorLeakWarning([tableView performSelector:sel withObject:cell]);
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    YQSettingsTableSection *tableSection = self.data[section];
    return tableSection.headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    YQSettingsTableSection *tableSection = self.data[section];
    return tableSection.uiHeaderHeight ?: 0.01f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    YQSettingsTableSection *tableSection = self.data[section];
    return tableSection.footerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    YQSettingsTableSection *tableSection = self.data[section];
    return tableSection.uiFooterHeight ?: 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YQSettingsTableSection *tableSection = self.data[section];
    if (tableSection.headerTitle.length) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YQSettingsTableSection *tableSection = self.data[section];
    if (tableSection.footerTitle.length) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = [UIColor clearColor];
    YQSettingsTableSection *tableSection = self.data[section];
    if (tableSection.headerTitle.length) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:YQSettingsColorWithHex(0x888888)];
        header.textLabel.font = [UIFont systemFontOfSize:13];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    YQSettingsTableSection *tableSection = self.data[section];
    if (tableSection.footerTitle.length) {
        UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
        [footer.textLabel setTextColor:YQSettingsColorWithHex(0xaaaaaa)];
        footer.textLabel.font = [UIFont systemFontOfSize:13];
    }
}
#pragma mark - Private
- (void)refreshData:(YQSettingsTableRow *)rowData cell:(UITableViewCell *)cell{
    cell.textLabel.text = rowData.title;
    cell.detailTextLabel.text = rowData.detailTitle;
    if (rowData.detailFont) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:rowData.detailFont];
    }
    cell.imageView.image = rowData.image;
}

@end
