//
//  WKLine.m
//  WK天气
//
//  Created by qitian on 16/7/5.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKLine.h"
#import "KYSpringLayerAnimation.h"
//相邻小球之间的距离
#define DISTANCE ((self.frame.size.width - self.ballDiameter) / (self.pageCount - 1))
@implementation WKLine

- (id)init {
    self = [super init];
    if (self) {
        //属性默认值
        self.selectedPage = 0;
        self.lineHeight = 2.0;
        self.ballDiameter = 10.0;
        self.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.selectedColor   = [UIColor redColor];
        self.pageCount = 6;
        self.selectedLineLength = 0;
    }
    return self;
}


//必须重载  drawInContext前必调此方法，需要拷贝上一个状态
- (id)initWithLayer:(WKLine *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        self.selectedPage = layer.selectedPage;
        self.lineHeight = layer.lineHeight;
        self.ballDiameter = layer.ballDiameter;
        self.unSelectedColor = layer.unSelectedColor;
        self.selectedColor   = layer.selectedColor;
        self.pageCount = layer.pageCount;
        self.masksToBounds = layer.masksToBounds;
        self.selectedLineLength = layer.selectedLineLength;
    }
    
    return self;
}

//设置动画最重要的部分 使用自定义属性设置动画 比如返回yes
+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqual: @"selectedLineLength"]) {
        return  YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    if (self.pageCount == 0) {
        return;
    }
    
    
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    //线从 第一个小球中心点开始画
    CGPathMoveToPoint(linePath, nil, self.ballDiameter / 2,
                      self.frame.size.height / 2);
    //添加圆角矩形 作为默认背景线
    CGPathAddRoundedRect(linePath, nil, CGRectMake(self.ballDiameter / 2, self.frame.size.height / 2 - self.lineHeight / 2,
                                                   self.frame.size.width - self.ballDiameter, self.lineHeight), 0, 0);

    //画pageCount个小圆
    for (NSInteger i = 0; i < self.pageCount; i++) {
        CGRect circleRect = CGRectMake(
                                       0 + i * DISTANCE, self.frame.size.height / 2 - self.ballDiameter / 2,
                                       self.ballDiameter, self.ballDiameter);
        CGPathAddEllipseInRect(linePath, nil, circleRect);
    }
    
    //填充颜色
    CGContextAddPath(ctx, linePath);
    CGContextSetFillColorWithColor(ctx, self.unSelectedColor.CGColor);
    CGContextFillPath(ctx);
    
    //重新开始
    CGContextBeginPath(ctx);
    linePath = CGPathCreateMutable();
    //画带颜色的线
    CGPathAddRoundedRect(
                         linePath, nil,
                         CGRectMake(self.ballDiameter / 2,
                                    self.frame.size.height / 2 - self.lineHeight / 2,
                                    self.selectedLineLength, self.lineHeight),
                         0, 0);
    //画pageCount个有色小圆
    for (NSInteger i = 0; i < (self.selectedPage + 1); i++) {
        
        //这个条件是为了 让绘制最后一个红色小圆的时候，线段已经达到指定位置 这样不会出现 有色线段还未到达新增小红点的
        if (i * DISTANCE <= self.selectedLineLength + 0.1) {
            CGRect circleRect =
            CGRectMake(0 + i * DISTANCE,
                       self.frame.size.height / 2 - self.ballDiameter / 2,
                       self.ballDiameter, self.ballDiameter);
            CGPathAddEllipseInRect(linePath, nil, circleRect);
        }
    }
    //填充颜色
    CGContextAddPath(ctx, linePath);
    CGContextSetFillColorWithColor(ctx, self.selectedColor.CGColor);
    CGContextFillPath(ctx);
    
    
}

- (void)setSelectedPage:(NSUInteger)selectedPage
{
    _selectedPage = selectedPage;
}

//tap index to scroll
- (void)animateSelectedLineToNewIndex:(NSInteger)newIndex {
    
    CGFloat newLineLength = newIndex * DISTANCE;
    // Spring Animation
    //    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager]
    //    createSpringAnima:@"selectedLineLength" duration:1.0
    //    usingSpringWithDamping:0.5 initialSpringVelocity:3
    //    fromValue:@(self.selectedLineLength) toValue:@(newLineLength)];
    
    // Half curve animation
    
    
    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager]
                                 createHalfCurveAnima:@"selectedLineLength"
                                 duration:1.0
                                 fromValue:@(self.selectedLineLength)
                                 toValue:@(newLineLength)];
    
    
    // line animation
    //    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager]
    //    createBasicAnima:@"selectedLineLength" duration:0.2
    //    fromValue:@(self.selectedLineLength) toValue:@(newLineLength)];
    
    NSLog(@"new = %f  old = %f",newLineLength,self.selectedLineLength);
    
    self.selectedLineLength = newLineLength;
    anim.delegate = self;
    anim.removedOnCompletion = YES;
    [self addAnimation:anim forKey:@"lineAnimation"];
    self.selectedPage = newIndex;
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    NSLog(@"stop");
//}

@end
