//
//  UIControl+Block_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIControl+Block_yq.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

// UIControlEventTouchDown           = 1 <<  0,      // on all touch downs
// UIControlEventTouchDownRepeat     = 1 <<  1,      // on multiple touchdowns
// (tap count > 1)
// UIControlEventTouchDragInside     = 1 <<  2,
// UIControlEventTouchDragOutside    = 1 <<  3,
// UIControlEventTouchDragEnter      = 1 <<  4,
// UIControlEventTouchDragExit       = 1 <<  5,
// UIControlEventTouchUpInside       = 1 <<  6,
// UIControlEventTouchUpOutside      = 1 <<  7,
// UIControlEventTouchCancel         = 1 <<  8,
//
// UIControlEventValueChanged        = 1 << 12,     // sliders, etc.
//
// UIControlEventEditingDidBegin     = 1 << 16,     // UITextField
// UIControlEventEditingChanged      = 1 << 17,
// UIControlEventEditingDidEnd       = 1 << 18,
// UIControlEventEditingDidEndOnExit = 1 << 19,     // 'return key' ending
// editing
//
// UIControlEventAllTouchEvents      = 0x00000FFF,  // for touch events
// UIControlEventAllEditingEvents    = 0x000F0000,  // for UITextField
// UIControlEventApplicationReserved = 0x0F000000,  // range available for
// application use
// UIControlEventSystemReserved      = 0xF0000000,  // range reserved for
// internal framework use
// UIControlEventAllEvents           = 0xFFFFFFFF

#define yq_UICONTROL_EVENT(methodName, eventName)                                \
-(void)methodName : (void (^)(void))eventBlock {                              \
objc_setAssociatedObject(self, @selector(methodName:), eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);\
[self addTarget:self                                                        \
action:@selector(methodName##Action:)                                       \
forControlEvents:UIControlEvent##eventName];                                \
}                                                                               \
-(void)methodName##Action:(id)sender {                                        \
void (^block)() = objc_getAssociatedObject(self, @selector(methodName:));  \
if (block) {                                                                \
block();                                                                \
}                                                                           \
}
@implementation UIControl (Block_yq)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
yq_UICONTROL_EVENT(yq_touchDown, TouchDown)
yq_UICONTROL_EVENT(yq_touchDownRepeat, TouchDownRepeat)
yq_UICONTROL_EVENT(yq_touchDragInside, TouchDragInside)
yq_UICONTROL_EVENT(yq_touchDragOutside, TouchDragOutside)
yq_UICONTROL_EVENT(yq_touchDragEnter, TouchDragEnter)
yq_UICONTROL_EVENT(yq_touchDragExit, TouchDragExit)
yq_UICONTROL_EVENT(yq_touchUpInside, TouchUpInside)
yq_UICONTROL_EVENT(yq_touchUpOutside, TouchUpOutside)
yq_UICONTROL_EVENT(yq_touchCancel, TouchCancel)
yq_UICONTROL_EVENT(yq_valueChanged, ValueChanged)
yq_UICONTROL_EVENT(yq_editingDidBegin, EditingDidBegin)
yq_UICONTROL_EVENT(yq_editingChanged, EditingChanged)
yq_UICONTROL_EVENT(yq_editingDidEnd, EditingDidEnd)
yq_UICONTROL_EVENT(yq_editingDidEndOnExit, EditingDidEndOnExit)
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
