//
//  WKEffectLabel.m
//  WK天气
//
//  Created by qitian on 16/6/22.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKEffectLabel.h"

static NSString * animKey = @"WKEffect";
static CGFloat layerWidth = 45;
@interface WKEffectLabel ()

@property (nonatomic, strong) CAGradientLayer * colorLayer;

@end

@implementation WKEffectLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addMaskLayer];
        
    }
    return self;
}

- (void)addMaskLayer
{
    
    _colorLayer = [CAGradientLayer layer];
    _colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //这里设置大小就好了
    _colorLayer.bounds    = CGRectMake(0, 0, layerWidth, self.heightS);
    _colorLayer.position = CGPointMake(self.center.x, self.center.y);
    [self.layer addSublayer:_colorLayer];
    
    // 颜色分配
    _colorLayer.colors = @[(__bridge id)UIColorFromRGB(0x4595e5).CGColor,
                          (__bridge id)[UIColor whiteColor].CGColor,
                          (__bridge id)UIColorFromRGB(0x4595e5).CGColor];
    
    _colorLayer.locations  = @[@(-0.2), @(-0.1), @(0)];
    
    // 起始点
    _colorLayer.startPoint = CGPointMake(0, 0);
    
    // 结束点
    _colorLayer.endPoint   = CGPointMake(1, 0);
    
    //画圆角矩形 它不需要 设置位置和 大小 他是被mask的
    CAShapeLayer * rr = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, layerWidth, self.heightS) cornerRadius:5];
    rr.path = path.CGPath;
    
    rr.lineWidth = 3;
    rr.fillColor = [UIColor clearColor].CGColor;
    rr.strokeColor = UIColorFromRGB(0x4595e5).CGColor;
    rr.strokeEnd = 1.f;
    rr.lineCap = kCALineCapRound;
    rr.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:rr];
    //被mask对象不需要设置 位置 和 大小，自然被mask
    _colorLayer.mask = rr;
    
    _colorLayer.hidden = YES;
    
    
}

- (void)startAnim
{
    _colorLayer.hidden = NO;
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"locations"];
    fadeAnim.fromValue = @[@(-0.2), @(-0.1), @(0)];
    fadeAnim.toValue   = @[@(1.0), @(1.1), @(1.2)];
    fadeAnim.duration  = 1.5;
    fadeAnim.repeatCount = INT64_MAX;
    fadeAnim.removedOnCompletion = NO;
    [_colorLayer addAnimation:fadeAnim forKey:animKey];
}

- (void)stopAnim
{
    [_colorLayer removeAnimationForKey:animKey];
    _colorLayer.hidden = YES;

}

@end
