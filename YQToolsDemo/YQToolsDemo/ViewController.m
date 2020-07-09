//
//  ViewController.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "ViewController.h"
#import "YQTools.h"
#import "YQSettings.h"
#import "YQNetworking.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation ViewController

#pragma mark - Init
/* init, dealloc */


#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self autoLayout];
    YQSettingsTableView *tableview = [[YQSettingsTableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableview];
    self.view.backgroundColor = [UIColor yq_randomColor];
    
}

#pragma mark - Delegate


#pragma mark - Event response
/* 所有button、gestureRecognizer的响应事件都放在这个区域里面 */


#pragma mark - Private methods
- (void)setup {
    
}

- (void)autoLayout {
    
}

#pragma mark - Getters and setters



@end
