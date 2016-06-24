//
//  WKListCityCell.h
//  WK天气
//
//  Created by qitian on 16/6/24.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWeatherModel.h"

typedef NS_ENUM(NSUInteger, WKAirQuality)
{
    WKAirQuality_Excellent = 1,//优
    WKAirQuality_Good,//量
    WKAirQuality_Mild,//轻度
    WKAirQuality_Medium,//中度
    WKAirQuality_Severe,//重度
    WKAirQuality_Grave//严重

};


@interface WKListCityCell : UITableViewCell

@property (nonatomic, strong) WKWeatherModel * model;
@property (nonatomic, assign) BOOL flag;//No 为 摄氏度，Yes为华氏度

@end
