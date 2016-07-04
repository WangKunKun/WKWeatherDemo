//
//  WKLoadingView.h
//  WK天气
//
//  Created by qitian on 16/7/4.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WKLoadingView : UIView


+ (void)showWithView:(UIView *)view;

+ (void)showWithView:(UIView *)view center:(CGPoint)center;

+ (void)hideWithView:(UIView *)view;
@end
