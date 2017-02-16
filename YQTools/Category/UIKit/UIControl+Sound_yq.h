//
//  UIControl+Sound_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//
//  https://github.com/scopegate/octave
//  Octave: A free library of UI sounds, handmade for iOS http://raisedbeaches.com/octave

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIControl (Sound_yq)

/// Set the sound for a particular control event (or events).
/// @param name The name of the file. The method looks for an image with the specified name in the application’s main bundle.
/// @param controlEvent A bitmask specifying the control events for which the action message is sent. See “Control Events” for bitmask constants.
//不同事件增加不同声音
- (void)yq_setSoundNamed:(NSString *)name forControlEvent:(UIControlEvents)controlEvent;

@end
