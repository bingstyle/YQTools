//
//  NSObject+Block_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/3/23.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "NSObject+Block_yq.h"

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1010)
#define DISPATCH_CANCELLATION_SUPPORTED 1
#else
#define DISPATCH_CANCELLATION_SUPPORTED 1
#endif

NS_INLINE dispatch_time_t BKTimeDelay(NSTimeInterval t) {
    return dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(NSEC_PER_SEC * t));
}

NS_INLINE BOOL BKSupportsDispatchCancellation(void) {
#if DISPATCH_CANCELLATION_SUPPORTED
    return (&dispatch_block_cancel != NULL);
#else
    return NO;
#endif
}

NS_INLINE dispatch_queue_t BKGetBackgroundQueue(void) {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

static id <NSObject, NSCopying> BKDispatchCancellableBlock(dispatch_queue_t queue, NSTimeInterval delay, void(^block)(void)) {
    dispatch_time_t time = BKTimeDelay(delay);
    
#if DISPATCH_CANCELLATION_SUPPORTED
    if (BKSupportsDispatchCancellation()) {
        dispatch_block_t ret = dispatch_block_create(0, block);
        dispatch_after(time, queue, ret);
        return ret;
    }
#endif
    
    __block BOOL cancelled = NO;
    void (^wrapper)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block();
    };
    
    dispatch_after(time, queue, ^{
        wrapper(NO);
    });
    
    return wrapper;
}


@implementation NSObject (Block_yq)

- (id <NSObject, NSCopying>)yq_performAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(id obj))block
{
    return [self yq_performOnQueue:dispatch_get_main_queue() afterDelay:delay usingBlock:block];
}

+ (id <NSObject, NSCopying>)yq_performAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block
{
    return [NSObject yq_performOnQueue:dispatch_get_main_queue() afterDelay:delay usingBlock:block];
}

- (id <NSObject, NSCopying>)yq_performInBackgroundAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(id obj))block
{
    return [self yq_performOnQueue:BKGetBackgroundQueue() afterDelay:delay usingBlock:block];
}

+ (id <NSObject, NSCopying>)yq_performInBackgroundAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block
{
    return [NSObject yq_performOnQueue:BKGetBackgroundQueue() afterDelay:delay usingBlock:block];
}

- (id <NSObject, NSCopying>)yq_performOnQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay usingBlock:(void (^)(id obj))block
{
    NSParameterAssert(block != nil);
    
    return BKDispatchCancellableBlock(queue, delay, ^{
        block(self);
    });
}

+ (id <NSObject, NSCopying>)yq_performOnQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block
{
    NSParameterAssert(block != nil);
    
    return BKDispatchCancellableBlock(queue, delay, block);
}

+ (void)yq_cancelBlock:(id <NSObject, NSCopying>)block
{
    NSParameterAssert(block != nil);
    
#if DISPATCH_CANCELLATION_SUPPORTED
    if (BKSupportsDispatchCancellation()) {
        dispatch_block_cancel((dispatch_block_t)block);
        return;
    }
#endif
    
    void (^wrapper)(BOOL) = (void(^)(BOOL))block;
    wrapper(YES);
}

@end
