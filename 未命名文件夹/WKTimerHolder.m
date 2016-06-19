//
//  WKTimerHolder.m
//  Example
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKTimerHolder.h"

@interface WKTimerHolder ()
{
    NSTimer *_timer;
    BOOL _repeats;
}

@property (nonatomic, weak) id<WKTimerHolderDelegate> timerDelegate;

- (void)onTimer:(NSTimer *)timer;

@end
@implementation WKTimerHolder

- (void)dealloc {
    [self stopTimer];
}

- (void)startTimer: (NSTimeInterval)seconds  repeats: (BOOL)repeats delegate: (id<WKTimerHolderDelegate>)delegate
{
    [self startTimer:seconds repeats:YES delegate:delegate start:YES];
}

- (void)timerWithSeconds:(NSTimeInterval)seconds repeats:(BOOL)repeats delegate:(id<WKTimerHolderDelegate>)delegate
{
    _repeats = repeats;
    _timerDelegate = delegate;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(onTimer:) userInfo:nil repeats:repeats];
}

- (void)startTimerWithRunLoop:(NSRunLoop *)runLoop
{
    //默认加入这个模式
    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)startTimer: (NSTimeInterval)seconds  repeats:(BOOL)repeats delegate: (id<WKTimerHolderDelegate>)delegate start:(BOOL)start
{
    _repeats = repeats;
    _timerDelegate = delegate;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(onTimer:) userInfo:nil repeats:repeats];
    
    if (start == NO) {
        [self pauseTimer];
    }
}
- (void)stopTimer {
    
    [_timer invalidate];
    _timer = nil;
    _timerDelegate = nil;
}

- (void)pauseTimer
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer
{
    [_timer setFireDate:[NSDate date]];

}

- (void)onTimer: (NSTimer *)timer {
    if (!_repeats) { _timer = nil; }
    if (_timerDelegate && [_timerDelegate respondsToSelector:@selector(onWKTimerFired:)]) { [_timerDelegate onWKTimerFired:self]; }
}
@end
