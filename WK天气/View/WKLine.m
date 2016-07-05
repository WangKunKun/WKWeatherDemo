//
//  WKLine.m
//  WK天气
//
//  Created by qitian on 16/7/5.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKLine.h"
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
    }
    
    return self;
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
                                    self.selectedPage * DISTANCE, self.lineHeight),
                         0, 0);
    //画pageCount个有色小圆
    for (NSInteger i = 0; i < (self.selectedPage + 1); i++) {
        
            CGRect circleRect =
            CGRectMake(0 + i * DISTANCE,
                       self.frame.size.height / 2 - self.ballDiameter / 2,
                       10, 10);
            CGPathAddEllipseInRect(linePath, nil, circleRect);
    }
    //填充颜色
    CGContextAddPath(ctx, linePath);
    CGContextSetFillColorWithColor(ctx, self.selectedColor.CGColor);
    CGContextFillPath(ctx);
}

@end
