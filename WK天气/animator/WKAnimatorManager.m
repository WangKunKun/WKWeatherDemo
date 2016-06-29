//
//  WKAnimatorManager.m
//  WK天气
//
//  Created by qitian on 16/6/29.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKAnimatorManager.h"
#import "WKFilpToonAnimator.h"
#import "WKCircleSpreadAnimator.h"
#import "WKWindowedModelAnimator.h"
@implementation WKAnimatorManager


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    WKBaseAnimator * animator = nil;
    
    switch (self.style) {
        case WKAnimatorStyle_CircleSpread: {
            animator = [WKCircleSpreadAnimator new];
            WKCircleSpreadAnimator * present = (WKCircleSpreadAnimator *)animator;
            present.circleFrame = _circleFrame;
            break;
        }
        case WKAnimatorStyle_FilpToon: {
             animator = [WKFilpToonAnimator new];

            break;
        }
        case WKAnimatorStyle_WindowedModel: {
            animator = [WKWindowedModelAnimator new];
            WKWindowedModelAnimator * present = (WKWindowedModelAnimator *)animator;
            present.toViewHeight = _toViewHeight;
            break;
        }
    }
    
    // 推出控制器的动画
    
    animator.type = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    WKBaseAnimator * animator = nil;
    switch (self.style) {
        case WKAnimatorStyle_CircleSpread: {
            animator = [WKCircleSpreadAnimator new];
            WKCircleSpreadAnimator * present = (WKCircleSpreadAnimator *)animator;
            present.circleFrame = _circleFrame;
            break;
        }
        case WKAnimatorStyle_FilpToon: {
            animator = [WKFilpToonAnimator new];
            
            break;
        }
        case WKAnimatorStyle_WindowedModel: {
            animator = [WKWindowedModelAnimator new];
            WKWindowedModelAnimator * present = (WKWindowedModelAnimator *)animator;
            present.toViewHeight = _toViewHeight;
            break;
        }
    }
    
    // 退出控制器动画
    return animator;
}

@end
