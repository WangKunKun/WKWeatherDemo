//
//  WKAnimatorManager.h
//  WK天气
//
//  Created by qitian on 16/6/29.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WKAnimatorStyle)
{
    WKAnimatorStyle_CircleSpread ,//圆圈拓展
    WKAnimatorStyle_FilpToon,//翻页
    WKAnimatorStyle_WindowedModel//窗口模式
};

@interface WKAnimatorManager : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic,assign) WKAnimatorStyle style;

/**
 *  圆圈拓展专用
 */
@property (nonatomic,assign) CGFloat toViewHeight;
/**
 *  窗口模式专用
 */
@property (nonatomic,assign) CGRect circleFrame;

@end
