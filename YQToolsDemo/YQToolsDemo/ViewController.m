//
//  ViewController.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "ViewController.h"
#import "YQTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication yq_registerAPNs];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
