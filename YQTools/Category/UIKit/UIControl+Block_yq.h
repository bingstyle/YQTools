//
//  UIControl+Block_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//
//  https://github.com/foxsofter/FXCategories
//  http://stackoverflow.com/questions/2437875/target-action-uicontrolevents

#import <UIKit/UIKit.h>

@interface UIControl (Block_yq)

- (void)yq_touchDown:(void (^)(void))eventBlock;
- (void)yq_touchDownRepeat:(void (^)(void))eventBlock;
- (void)yq_touchDragInside:(void (^)(void))eventBlock;
- (void)yq_touchDragOutside:(void (^)(void))eventBlock;
- (void)yq_touchDragEnter:(void (^)(void))eventBlock;
- (void)yq_touchDragExit:(void (^)(void))eventBlock;
- (void)yq_touchUpInside:(void (^)(void))eventBlock;
- (void)yq_touchUpOutside:(void (^)(void))eventBlock;
- (void)yq_touchCancel:(void (^)(void))eventBlock;
- (void)yq_valueChanged:(void (^)(void))eventBlock;
- (void)yq_editingDidBegin:(void (^)(void))eventBlock;
- (void)yq_editingChanged:(void (^)(void))eventBlock;
- (void)yq_editingDidEnd:(void (^)(void))eventBlock;
- (void)yq_editingDidEndOnExit:(void (^)(void))eventBlock;

@end
