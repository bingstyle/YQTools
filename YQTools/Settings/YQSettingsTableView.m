//
//  YQSettingsTableView.m
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/15.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "YQSettingsTableView.h"
#import "YQSettings.h"
#import "YQSettingsModel.h"
#import "YQSettingsTimeRangView.h"
#import "UIView+Alert_YQSettings.h"

@interface YQSettingsTableView ()

@property (nonatomic, strong) YQSettingsTableDelegate *delegator;
@property (nonatomic, strong) YQSettingsModel *model;

@end


@implementation YQSettingsTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStyleGrouped];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        self.rowHeight = UITableViewAutomaticDimension;
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01f)];
        self.tableFooterView = [UIView new];
        self.layoutMargins = UIEdgeInsetsZero;
        [self config];
    }
    return self;
}

- (void)config {
    //设置列表的代理
    __weak __typeof(self)weakSelf = self;
    _delegator = [[YQSettingsTableDelegate alloc] initWithTableData:^NSArray *{
        
        return [YQSettingsTableSection sectionsWithData:weakSelf.data];
    }];
    self.delegate = _delegator;
    self.dataSource = _delegator;
    [self reloadData];
}

/* 默认列表数据 */
- (NSArray *)defaultListData {
    NSNumber *headerHeight    = @0.01f;
    NSNumber *detailFont      = @13;
    NSString *switchCellClass = YQSettingsSwitchCellClass;
    YQSettingsModel *model = self.model;
    return @[
             @{
                 HeaderHeight:@1,
                 RowContent :@[
                         @{
                             Title      :@"通知提醒设置",
                             CellAction :@"showNotiRemindVCAction",
                             ShowAccessory:@(YES),
                             },
                         ],
                 FooterTitle:@""
                 },
             @{
                 HeaderHeight:headerHeight,
                 RowContent :@[
                         @{
                             CellClass     :switchCellClass,
                             CellAction    :@"msgDetailAction:",
                             Title         :@"通知显示消息详情",
                             ForbidSelect  : @(YES),
                             ExtraInfo     : @(model.displayInform),
                             },
                         @{
                             CellClass     :switchCellClass,
                             CellAction    :@"DNDAction:",
                             Title         :@"免打扰模式",
                             ForbidSelect  : @(YES),
                             ExtraInfo     : @(model.distrub),
                             },
                         @{
                             Title         :@"选择时段",
                             CellAction    :@"DNDTimeAction",
                             DetailTitle   :model.DNDTime,
                             DetailFont    :detailFont,
                             Disable       : @(!model.distrub),
                             ShowAccessory : @(YES),
                             ExtraInfo     : @(YES),
                             },
                         ],
                 FooterTitle:@"",
                 },
             @{
                 HeaderHeight:headerHeight,
                 RowContent :@[
                         @{
                             CellClass     :switchCellClass,
                             CellAction    :@"voiceAction:",
                             Title         :@"声音",
                             ForbidSelect  : @(YES),
                             ExtraInfo     : @(model.voice),
                             },
                         ],
                 FooterTitle:@"正在使用或后台运行时, 声音提示新消息; 关闭后将收不到声音新消息提示",
                 FooterHeight:@44,
                 },
             @{
                 HeaderHeight:headerHeight,
                 RowContent :@[
                         @{
                             CellClass     :switchCellClass,
                             CellAction    :@"shakeAction:",
                             Title         :@"震动",
                             ForbidSelect  : @(YES),
                             ExtraInfo     : @(model.shake),
                             },
                         ],
                 FooterTitle:@"正在使用或后台运行时, 震动提示新消息; 关闭后将收不到震动新消息提示",
                 FooterHeight:@44,
                 },
             ];
}
#pragma mark - Action
- (void)showNotiRemindVCAction {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    [YQViewController(self).navigationController pushViewController:vc animated:YES];
}
- (void)msgDetailAction:(UISwitch *)sender {
    _model.displayInform = sender.isOn;
    [self refresh];
}
- (void)DNDAction:(UISwitch *)sender {
    _model.distrub = sender.isOn;
    [self refresh];
}
//选择时段
- (void)DNDTimeAction {
    YQSettingsTimeRangView *view = [[YQSettingsTimeRangView alloc] initStartRow:_model.distrubTimeStart endRow:_model.distrubTimeEnd];
    view.sureBtnBlock = ^(NSString *value, NSInteger startH, NSInteger endH) {
        _model.DNDTime = value;
        _model.distrubTimeStart = startH;
        _model.distrubTimeEnd = endH;
        [self refresh];
    };
    [view showInWindowWithBackgoundTapDismissEnable:YES];
}
- (void)voiceAction:(UISwitch *)sender {
    _model.voice = sender.isOn;
    [self refresh];
}
- (void)shakeAction:(UISwitch *)sender {
    _model.shake = sender.isOn;
    [self refresh];
}

#pragma mark - Private
- (NSArray *)data {
    if ([self.delegater respondsToSelector:@selector(dataWithTableView:)]) {
        return [self.delegater dataWithTableView:self];
    }
    return [self defaultListData];
}
- (void)refresh {
    [self reloadData];
    if ([self.delegater respondsToSelector:@selector(refreshTableView:)]) {
        [self.delegater refreshTableView:self];
    }
}

#pragma mark - getter
- (YQSettingsModel *)model {
    if (!_model) {
        _model = [YQSettingsModel sharedSettings];
    }
    return _model;
}

@end
