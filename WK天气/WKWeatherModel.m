//
//  WKWeatherModel.m
//  WK天气
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKWeatherModel.h"
#import <MJExtension/MJExtension.h>

@implementation WKWeatherDayInfo

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"presentDate":@"date",
             @"presentChineseData":@"nongli",
             @"week":@"week",
             @"day":@"info.day",
             @"night":@"info.night",
             @"dawn":@"info.dawn"
             };
}

@end

@implementation WKWeatherPmInfo

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{
             @"cityName":@"cityName",
             @"dateTime":@"dateTime",
             @"curPm":@"pm25.curPm",
             @"pmDes":@"pm25.des",
             @"pmQuality":@"pm25.quality",
             @"pm10":@"pm25.pm10",
             @"pm25":@"pm25.pm25",
             @"pmLevel":@"pm25.level"
             };
}

@end

@implementation WKWeatherRealTimeInfo

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{
             @"cityName":@"city_name",
             @"cityCode":@"city_code",
             @"dataUptime":@"dataUptime",
             @"date":@"date",
             @"moon":@"moon",
             @"time":@"time",
             @"week":@"week",
             
             @"humidity":@"weather.humidity",
             @"weatherInfo":@"weather.info",
             @"temperature":@"weather.temperature",
             
             @"windDirect":@"wind.direct",
             @"windOffset":@"wind.offset",
             @"windPower":@"wind.power",
             @"windSpeed":@"wind.windspeed"
             };
}

@end

@implementation WKWeatherIndexInfo

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{
             @"dressIndex":@"chuanyi",
             @"coldIndex":@"ganmao",
             @"airConIndex":@"kongtiao",
             @"polluteIndex":@"wuran",
             @"dustIndex":@"ziwaixian",
             @"dustIndex":@"xiche",
             @"sportIndex":@"yundong",
             };
}

@end
@interface WKWeatherModel ()

@property (nonatomic, strong) NSArray * weatherDict;


@end

@implementation WKWeatherModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"indexInfo" : @"life.info",
             @"pmInfo":@"pm25",
             @"realtimeInfo":@"realtime",
             @"weatherDict":@"weather"
             };
}

+ (instancetype)createWeatherModelWithDict:(NSDictionary *)dict
{
    WKWeatherModel * model = [WKWeatherModel mj_objectWithKeyValues:dict];
    NSMutableArray * arrM = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in model.weatherDict) {
        WKWeatherDayInfo * day = [WKWeatherDayInfo mj_objectWithKeyValues:dict];
        
        if (day) {
            [arrM addObject:day];
        }
    }
    model.weatherDayInfos = [arrM copy];
    return model;
}

@end
