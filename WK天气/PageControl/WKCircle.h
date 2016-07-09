//
//  WKCircle.h
//  WK天气
//
//  Created by qitian on 16/7/6.
//  Copyright © 2016年 王琨. All rights reserved.
//

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@class WKPageControl;


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface WKCircle : CALayer

@property(nonatomic, assign) CGFloat indicatorSize;
@property(nonatomic, strong) UIColor *indicatorColor;
@property(nonatomic, assign) CGRect currentRect;
@property(nonatomic, assign) NSUInteger selectedPage;
@property(nonatomic, assign) ScrollDirection scrollDirection;

- (void)animateIndicatorWithPage:(NSUInteger)page
                          andIndicator:(WKPageControl *)pgctl;
- (void)restoreAnimation:(id)howmanydistance;

@end
