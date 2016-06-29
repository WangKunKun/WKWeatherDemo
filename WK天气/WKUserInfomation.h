//
//  WKUesrInfomation.h
//  WK天气
//
//  Created by qitian on 16/6/20.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * notificationName = @"WKWeatherDataRefresh";
static NSString * defaultValue = @"WKWeather";

@interface WKUserInfomation : NSObject


+ (WKUserInfomation *)shardUsrInfomation;

- (NSArray *)allKeys;
- (NSArray *)allValues;


//单个调用这里
- (void)wkSetObject:(id)value forKey:(NSString *)key;
//多个调用这里 防止 数据请求多次
- (void)setCityModels:(NSDictionary *)dict;

- (id)wkObjectForKey:(NSString *)key;
- (void)wkRemoveObjectForKey:(NSString *)key;


//单独的数据 上次定位地点

+ (NSString *)getCityName;
+ (void)setCityName:(NSString *)cn;

@end
