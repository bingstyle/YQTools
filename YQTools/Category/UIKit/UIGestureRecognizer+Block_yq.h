//
//  UIGestureRecognizer+Block_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/3/23.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef __has_attribute
#define __has_attribute(x) 0
#endif

#if !defined(yq_INITIALIZER)
# if __has_attribute(objc_method_family)
#  define yq_INITIALIZER __attribute__((objc_method_family(init)))
# else
#  define yq_INITIALIZER
# endif
#endif

@interface UIGestureRecognizer (Block_yq)

/** An autoreleased gesture recognizer that will, on firing, call
 the given block asynchronously after a number of seconds.
 
 @return An autoreleased instance of a concrete UIGestureRecognizer subclass, or `nil`.
 @param block The block which handles an executed gesture.
 @param delay A number of seconds after which the block will fire.
 */
+ (instancetype)yq_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay;

/** Initializes an allocated gesture recognizer that will call the given block
 after a given delay.
 
 An alternative to the designated initializer.
 
 @return An initialized instance of a concrete UIGestureRecognizer subclass or `nil`.
 @param block The block which handles an executed gesture.
 @param delay A number of seconds after which the block will fire.
 */
- (instancetype)yq_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay yq_INITIALIZER;

/** An autoreleased gesture recognizer that will call the given block.
 
 For convenience and compatibility reasons, this method is indentical
 to using recognizerWithHandler:delay: with a delay of 0.0.
 
 @return An initialized and autoreleased instance of a concrete UIGestureRecognizer
 subclass, or `nil`.
 @param block The block which handles an executed gesture.
 */
+ (instancetype)yq_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block;

/** Initializes an allocated gesture recognizer that will call the given block.
 
 This method is indentical to calling initWithHandler:delay: with a delay of 0.0.
 
 @return An initialized instance of a concrete UIGestureRecognizer subclass or `nil`.
 @param block The block which handles an executed gesture.
 */
- (instancetype)yq_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block yq_INITIALIZER;

/** Allows the block that will be fired by the gesture recognizer
 to be modified after the fact.
 */
@property (nonatomic, copy, setter = yq_setHandler:, nullable) void (^yq_handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location);

/** Allows the length of the delay after which the gesture
 recognizer will be fired to modify. */
@property (nonatomic, setter = yq_setHandlerDelay:) NSTimeInterval yq_handlerDelay;

/** If the recognizer happens to be fired, calling this method
 will stop it from firing, but only if a delay is set.
 
 @warning This method is not for arbitrarily canceling the
 firing of a recognizer, but will only function for a block
 handler *after the recognizer has already been fired*.  Be
 sure to make your delay times accomodate this likelihood.
 */
- (void)yq_cancel;

@end

NS_ASSUME_NONNULL_END
