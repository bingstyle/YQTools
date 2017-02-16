//
//  UIButton+Indicator_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Indicator_yq)

/**
 This method will show the activity indicator in place of the button text.
 */
- (void)yq_showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void)yq_hideIndicator;

@end
