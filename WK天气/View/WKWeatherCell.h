//
//  WKWeatherCell.h
//  WK天气
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WKWeatherType) {
    WKWeatherType_Sunny = 0,
    WKWeatherType_Cloudy,
    WKWeatherType_Shade,//阴
    WKWeatherType_Shower,//阵雨
    WKWeatherType_ThunderShower,//雷阵雨
    WKWeatherType_ThunderShowerWithHail,//雷阵雨加冰雹
    WKWeatherType_Sleet,//雨夹雪
    WKWeatherType_LightRain,//小雨
    WKWeatherType_ModerateRain,//中雨
    WKWeatherType_HeavyRain,//大雨
    WKWeatherType_Rainstorm,//暴雨
    WKWeatherType_HeavyRainstorm,//大暴雨
    WKWeatherType_ExtraordinaryRainstorm,//特大暴雨
    WKWeatherType_SnowShower,//阵雪
    WKWeatherType_LightSnow,//小雪
    WKWeatherType_ModerateSnow,//中雪
    WKWeatherType_HeavySnow,//大雪
    WKWeatherType_Blizzard,//暴雪 哈哈
    WKWeatherType_Fog,//雾
    WKWeatherType_FreezingRain,//冻雨
    WKWeatherType_DustStorms,//沙尘暴
    WKWeatherType_LightModerateRain,//小-中雨
    WKWeatherType_ModerateHeavyRain,//中-大雨
    WKWeatherType_HeavyStormRain,//大—暴雨
    WKWeatherType_StormHeavyRain,//暴-大暴雨
    WKWeatherType_StormExtraordinaryRain,//大暴-特大暴雨
    WKWeatherType_FlyAsh,//浮尘
    WKWeatherType_Micrometeorology,//扬沙
    WKWeatherType_StrongSandstorms,//强沙尘暴
    WKWeatherType_Haze = 53//霾
};


@interface WKWeatherCell : UITableViewCell

@property (nonatomic, strong) NSString * weekDay;
@property (nonatomic, strong) NSNumber * weatherType;
@property (nonatomic, strong) NSNumber * dayTemperature;
@property (nonatomic, strong) NSNumber * nightTemperature;

- (void)setInterFaceWithModel:(WKWeatherDayInfo *)model;

@end
