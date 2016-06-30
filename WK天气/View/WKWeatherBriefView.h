//
//  WKWeatherBriefView.h
//  WK天气
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKWeatherBriefView : UIView
+ (instancetype)viewFromNIB;
@property (nonatomic, strong) WKWeatherModel * model;

@end
