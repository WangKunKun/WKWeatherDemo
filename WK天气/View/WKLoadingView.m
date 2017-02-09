//
//  WKLoadingView.m
//  WK天气
//
//  Created by qitian on 16/7/4.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKLoadingView.h"

@interface WKLoadingView ()

@property (nonatomic, strong) CAEmitterLayer * eLayer;

@end

@implementation WKLoadingView


- (void)setInterFace
{

    _eLayer = [WKParticleManager createParticleEffectWithStyle:WKParticleStyle_Waiting];
    _eLayer.emitterPosition = CGPointMake(self.widthS / 2.0, self.heightS / 2.0);
    [self.layer addSublayer:_eLayer];

}


//动画来
- (void)stop
{
    
    //关键帧-渐隐
    CAKeyframeAnimation *opacityAnimOut = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimOut.values = @[@1,@0];
    opacityAnimOut.duration=1.0;
    
    //基础动画-缩放
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(1.f);
    scaleAnimation.toValue = @.2f;
    scaleAnimation.duration = 1.0;
    
    WEAKSELF
    //动画组
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[opacityAnimOut, scaleAnimation];
    groupAnimation.duration = 1.0;
    groupAnimation.delegate = weakSelf;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.3 :0 :0];
    [self.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
    
    groupAnimation.removedOnCompletion = NO;
    
}

+ (void)showWithView:(UIView *)view
{
    [self showWithView:view center:CGPointMake(view.widthS / 2.0, view.heightS / 2.0 )];
}

+ (void)showWithView:(UIView *)view center:(CGPoint)center
{
    WKLoadingView * lv = [[WKLoadingView alloc] init];
    lv.center = center;
    lv.bounds = CGRectMake(0, 0, 50, 50);
    [lv setInterFace];
    [view addSubview:lv];
}


+ (void)hideWithView:(UIView *)view
{
    for (UIView * vv in view.subviews) {
        if ([vv isKindOfClass:[self class]]) {
            WKLoadingView * temp = (WKLoadingView *)vv;
            [temp stop];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.eLayer.birthRate = 0;
        [self removeFromSuperview];
    }
}
@end
