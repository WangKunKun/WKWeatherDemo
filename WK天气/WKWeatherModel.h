//
//  WKWeatherModel.h
//  WK天气
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <Foundation/Foundation.h>

//指数数据
@interface WKWeatherIndexInfo : NSObject

@property (nonatomic, strong) NSArray * dressIndex;//穿衣指数
@property (nonatomic, strong) NSArray * coldIndex;//感冒指数
@property (nonatomic, strong) NSArray * airConIndex;//感冒指数
@property (nonatomic, strong) NSArray * polluteIndex;//感冒指数
@property (nonatomic, strong) NSArray * dustIndex;//洗车指数
@property (nonatomic, strong) NSArray * sportIndex;//运动指数
@property (nonatomic, strong) NSArray * rayIndex;//紫外线指数

@end

//PM数据
@interface WKWeatherPmInfo : NSObject

@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSString * dateTime;
@property (nonatomic, strong) NSString * pmDes;
@property (nonatomic, strong) NSString * pmQuality;
@property (nonatomic, strong) NSNumber * pm10;
@property (nonatomic, strong) NSNumber * pm25;
@property (nonatomic, assign) NSUInteger pmLevel;
@property (nonatomic, assign) NSUInteger curPM;

@end

@interface WKWeatherRealTimeInfo : NSObject

@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSString * moon;//未知
@property (nonatomic, strong) NSString * cityCode;
@property (nonatomic, strong) NSString * date;//日期
@property (nonatomic, strong) NSNumber * time;//当前时间
@property (nonatomic, assign) NSUInteger dataUpTime;//时间戳
@property (nonatomic, assign) NSUInteger week;//周几

@property (nonatomic, strong) NSString * windDirect;//风向
@property (nonatomic, strong) NSString * windOffset;//风偏移
@property (nonatomic, strong) NSString * windPow;//风力
@property (nonatomic, strong) NSString * windSpeed;//风速


@property (nonatomic, strong) NSString * weatherInfo;//天气信息
@property (nonatomic, assign) NSUInteger temperature;//温度
@property (nonatomic, assign) NSUInteger humidity;//湿度


@end


typedef enum : NSUInteger {
    WKWeatherType_Number = 0,
    WKWeatherType_Text,
    WKWeatherTemperature,
    WKWeatherWindDirection,
    WKWeatherWindPow,//微风
    WKWeatherTime
} WKWeatherDayInfoIndex;

@interface WKWeatherDayInfo : NSObject

@property (nonatomic, strong) NSString * presentDate;
@property (nonatomic, strong) NSString * presentChineseData;
@property (nonatomic, strong) NSString * week;

//天气类型 数字，天气类型 文字，温度 数字，风向 文字，风种 文字，开始时间 时间
@property (nonatomic, strong) NSArray * day;
@property (nonatomic, strong) NSArray * night;
@property (nonatomic, strong) NSArray * dawn;


@end




@interface WKWeatherModel : NSObject

@property (nonatomic, strong) WKWeatherIndexInfo * indexInfo;
@property (nonatomic, strong) WKWeatherPmInfo * pmInfo;
@property (nonatomic, strong) WKWeatherRealTimeInfo * realtimeInfo;
@property (nonatomic, strong) NSArray<WKWeatherDayInfo *> * weatherDayInfos;

+ (instancetype)createWeatherModelWithDict:(NSDictionary *)dict;

@end
