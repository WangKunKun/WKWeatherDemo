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


- (void)wkSetObject:(id)value forKey:(NSString *)key;
- (id)wkObjectForKey:(NSString *)key;
- (void)wkRemoveObjectForKey:(NSString *)key;
@end
