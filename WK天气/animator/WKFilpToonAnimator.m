//
//  wkFilpToonAnimator.m
//  WK天气
//
//  Created by qitian on 16/6/29.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKFilpToonAnimator.h"

@implementation WKFilpToonAnimator

- (void)present
{
    //对tempView做动画，避免bug;
    UIView *tempView = [self.fromViewController.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = self.fromViewController.view.frame;
    [self.containerView addSubview:self.toViewController.view];
    [self.containerView addSubview:tempView];
    self.fromViewController.view.hidden = YES;
    [self.containerView insertSubview:self.toViewController.view atIndex:0];
    [tempView setAnchorPointTo:CGPointMake(0, 0.5)];
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    self.containerView.layer.sublayerTransform = transfrom3d;
    //增加阴影
    CAGradientLayer *fromGradient = [CAGradientLayer layer];
    fromGradient.frame = self.fromViewController.view.bounds;
    fromGradient.colors = @[(id)[UIColor blackColor].CGColor,
                            (id)[UIColor blackColor].CGColor];
    fromGradient.startPoint = CGPointMake(0.0, 0.5);
    fromGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *fromShadow = [[UIView alloc]initWithFrame:self.fromViewController.view.bounds];
    fromShadow.backgroundColor = [UIColor clearColor];
    [fromShadow.layer insertSublayer:fromGradient atIndex:1];
    fromShadow.alpha = 0.0;
    [tempView addSubview:fromShadow];
    CAGradientLayer *toGradient = [CAGradientLayer layer];
    toGradient.frame = self.fromViewController.view.bounds;
    toGradient.colors = @[(id)[UIColor blackColor].CGColor,
                          (id)[UIColor blackColor].CGColor];
    toGradient.startPoint = CGPointMake(0.0, 0.5);
    toGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *toShadow = [[UIView alloc]initWithFrame:self.fromViewController.view.bounds];
    toShadow.backgroundColor = [UIColor clearColor];
    [toShadow.layer insertSublayer:toGradient atIndex:1];
    toShadow.alpha = 1.0;
    [self.toViewController.view addSubview:toShadow];
    [UIView animateWithDuration:self.transitionDuration animations:^{
        tempView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        fromShadow.alpha = 1.0;
        toShadow.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self completeTransition];
    }];
}

- (void)dismiss
{
    //拿到present时候的View
    UIView *tempView = self.containerView.subviews.lastObject;
    [UIView animateWithDuration:self.transitionDuration animations:^{
        tempView.layer.transform = CATransform3DIdentity;
        self.fromViewController.view.subviews.lastObject.alpha = 1.0;
        tempView.subviews.lastObject.alpha = 0.0;
    } completion:^(BOOL finished) {

            [self completeTransition];
            [tempView removeFromSuperview];
            self.toViewController.view.hidden = NO;
    }];
}



@end
