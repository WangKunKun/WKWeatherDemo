//
//  WKTimerHolder.h
//  Example
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

//防止定时器循环引用
@class WKTimerHolder;

@protocol WKTimerHolderDelegate <NSObject>
- (void)onWKTimerFired:(WKTimerHolder *)timerHolder;
@end

@interface WKTimerHolder : NSObject

//配套使用
- (void)startTimer: (NSTimeInterval)seconds  repeats: (BOOL)repeats delegate: (id<WKTimerHolderDelegate>)delegate;
- (void)stopTimer;
- (void)pauseTimer;
- (void)resumeTimer;
//- (void)startTimer: (NSTimeInterval)seconds  repeats:(BOOL)repeats delegate: (id<WKTimerHolderDelegate>)delegate start:(BOOL)start;

//开始配套使用
- (void)timerWithSeconds:(NSTimeInterval)seconds repeats:(BOOL)repeats delegate:(id<WKTimerHolderDelegate>)delegate;
- (void)startTimerWithRunLoop:(NSRunLoop *)runLoop;


@end
