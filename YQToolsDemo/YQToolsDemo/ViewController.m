//
//  ViewController.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation ViewController

#pragma mark - life cycle
/* 1.viewDidAppear里面做Notification的监听之类的事情
 2.属性的初始化，则交给getter去做
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutPageSubviews];
}

/* add constraints */
- (void)layoutPageSubviews {
    
}
#pragma mark - Delegate
/* 每一个delegate都把对应的protocol名字带上,
 比如: UITableViewDelegate的方法集就老老实实写上#pragma mark - UITableViewDelegate
 */

#pragma mark - event response
/* 所有button、gestureRecognizer的响应事件都放在这个区域里面 */

#pragma mark - private methods
/* 关于private methods，正常情况下ViewController里面不应该写,
 要么把它写成一个category，要么把他做成一个模块，哪怕这个模块只有一个函数也行。
 */

#pragma mark - getters and setters


@end
