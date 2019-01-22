//
//  YQSettingsTimeRangView.m
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/18.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "YQSettingsTimeRangView.h"
#import "YQSettings.h"
#import "UIView+Alert_YQSettings.h"

@interface YQSettingsTimeRangePickerView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) NSInteger selectRow;//选中行
@property (nonatomic, copy, readonly) NSArray *data;//数据
- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data;

@end

@implementation YQSettingsTimeRangePickerView
{
    NSInteger pickerWidth;//选择器宽度
}
- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data {
    if (self = [super initWithFrame:frame]) {
        pickerWidth     = frame.size.width;
        _data = [NSArray array];
        _data = data;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
- (void)layoutSubviews {
    pickerWidth = self.frame.size.width;
    [super layoutSubviews];
}

#pragma mark - <UIPickerViewDataSource>
//确定多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//确定每一列返回的数量
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _data.count;
}
#pragma mark - <UIPickerViewDelegate>
//每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}
//每一列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerWidth;
}
//自定义数据展示视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel*)view;
    if (!label) {
        label               = [[UILabel alloc] init];
        label.font          = [UIFont systemFontOfSize:17];
        label.textColor     = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.frame = view.frame;
    label.text = _data[row];
    return label;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _data[row];
}
//监听picker的滚动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectRow = row;
}

#pragma mark - setter

- (void)setSelectRow:(NSInteger)selectRow {
    _selectRow = selectRow;
    [self selectRow:selectRow inComponent:0 animated:YES];
}

@end



@interface YQSettingsTimeRangView ()
{
    NSString *_selectDateStr;
    NSMutableArray *data;
    NSInteger pickerWidth;
    NSInteger leftSelectRow;
    NSInteger rightSelectRow;
}
@property (nonatomic, strong) UILabel            *titleLabel;//标题
@property (nonatomic, strong) YQSettingsTimeRangePickerView *leftPicker;//左选择器
@property (nonatomic, strong) UILabel            *centerLabel;//中心点文本
@property (nonatomic, strong) YQSettingsTimeRangePickerView *rightPicker;//右选择器
@property (nonatomic, strong) UIButton           *cancelBtn;//取消
@property (nonatomic, strong) UIButton           *sureBtn;//确定

- (void)initializeData;//初始化数据

@end

@implementation YQSettingsTimeRangView

#pragma mark - init
- (instancetype)initStartRow:(NSInteger)startRow endRow:(NSInteger)endRow
{
    self = [super init];
    if (self) {
        leftSelectRow = startRow;
        rightSelectRow = endRow;
        self = [self initWithFrame:CGRectZero];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.85f, 300);
    if (self = [super initWithFrame:frame]) {
        [self initializeData];
        [self addSubview:self.titleLabel];
        [self addSubview:self.leftPicker];
        [self addSubview:self.centerLabel];
        [self addSubview:self.rightPicker];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.sureBtn];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        _leftPicker.selectRow = leftSelectRow;
        _rightPicker.selectRow = rightSelectRow;
    }
    return self;
}

#pragma mark - Action
- (void)cancelBtnAction:(UIButton *)sender {
    if (_cancelBtnBlock) {
        _cancelBtnBlock();
    }
    [self hideInWindow];
}

- (void)sureBtnAction:(UIButton *)sender {
    if (_sureBtnBlock) {
        NSString *leftStr = data[_leftPicker.selectRow];
        NSString *rightStr = data[_rightPicker.selectRow];
        NSString *str = [NSString stringWithFormat:@"%@%@%@", leftStr, _centerLabel.text, rightStr];
        _sureBtnBlock(str, _leftPicker.selectRow, _rightPicker.selectRow);
        [YQViewController(self) dismissViewControllerAnimated:YES completion:nil];
    }
    [self hideInWindow];
}

#pragma mark - private
- (void)initializeData {
    data = [NSMutableArray arrayWithCapacity:24];
    for (int i =  0; i < 24; ++i) {
        NSString *str = [NSString stringWithFormat:@"%d：00",i];
        [data addObject:str];
    }
    pickerWidth = (self.bounds.size.width - 40)/3;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat margin = 20;
    CGFloat textHeight = 35;
    
    _titleLabel.frame = CGRectMake(margin, margin, width - margin, textHeight);
    _leftPicker.frame = CGRectMake(margin, CGRectGetMidY(self.bounds) - CGRectGetHeight(_leftPicker.bounds)/2, pickerWidth, height * 0.7f);
    _rightPicker.frame = CGRectMake(width - margin - pickerWidth, CGRectGetMidY(self.bounds) - CGRectGetHeight(_leftPicker.bounds)/2, pickerWidth, CGRectGetHeight(_leftPicker.bounds));
    
    _centerLabel.bounds = CGRectMake(0, 0, textHeight, textHeight);
    _centerLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    _sureBtn.bounds = CGRectMake(0, 0, textHeight * 2, CGRectGetHeight(_titleLabel.bounds));
    _sureBtn.center = CGPointMake(width - margin - textHeight, height - textHeight);
    _cancelBtn.bounds = _sureBtn.bounds;
    _cancelBtn.center = CGPointMake(width - margin - textHeight * 3, height - textHeight);

}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"选择时段";
    }
    return _titleLabel;
}
- (YQSettingsTimeRangePickerView *)leftPicker {
    if (!_leftPicker) {
        _leftPicker = [[YQSettingsTimeRangePickerView alloc] initWithFrame:CGRectZero data:data];
    }
    return _leftPicker;
}
- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.text = @"至";
        _centerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLabel;
}
- (YQSettingsTimeRangePickerView *)rightPicker {
    if (!_rightPicker) {
        _rightPicker = [[YQSettingsTimeRangePickerView alloc] initWithFrame:CGRectZero data:data];
    }
    return _rightPicker;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
