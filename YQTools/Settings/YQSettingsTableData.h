//
//  YQSettingsTableData.h
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/15.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//section key
#define HeaderTitle  @"headerTitle"
#define FooterTitle  @"footerTitle"
#define HeaderHeight @"headerHeight"
#define FooterHeight @"footerHeight"
#define RowContent   @"row"

//row key
#define Title         @"title"
#define DetailTitle   @"detailTitle"
#define DetailFont    @"detailFont"
#define Image         @"image"
#define CellClass     @"cellClass"
#define CellAction    @"action"
#define ExtraInfo     @"extraInfo"
#define RowHeight     @"rowHeight"

//common key
#define Disable       @"disable"      //cell不可见
#define ShowAccessory @"accessory"    //cell显示>箭头
#define ForbidSelect  @"forbidSelect" //cell不响应select事件


/************************* Section **************************/
@interface YQSettingsTableSection : NSObject

@property (nonatomic,copy  ) NSArray  *rows;
@property (nonatomic,copy  ) NSString *headerTitle;
@property (nonatomic,copy  ) NSString *footerTitle;
@property (nonatomic,assign) CGFloat  uiHeaderHeight;
@property (nonatomic,assign) CGFloat  uiFooterHeight;

- (instancetype) initWithDict:(NSDictionary *)dict;
+ (NSArray *)sectionsWithData:(NSArray *)data;

@end

/************************* Row **************************/
@interface YQSettingsTableRow : NSObject

@property (nonatomic,strong ) NSString *title;
@property (nonatomic,copy   ) NSString *detailTitle;
@property (nonatomic, assign) CGFloat  detailFont;
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic,copy   ) NSString *cellClassName;
@property (nonatomic,copy   ) NSString *cellActionName;
@property (nonatomic,assign ) CGFloat  uiRowHeight;
@property (nonatomic,assign ) BOOL     showAccessory;
@property (nonatomic,assign ) BOOL     forbidSelect;
@property (nonatomic,strong ) id       extraInfo;

- (instancetype) initWithDict:(NSDictionary *)dict;
+ (NSArray *)rowsWithData:(NSArray *)data;

@end
