//
//  WKWeatherManager.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/14.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WKPollutionConditionExcellent = 0,
    WKPollutionConditionGood,
    WKPollutionConditionMild,
    WKPollutionConditionMedium,
    WKPollutionConditionSerious
} WKPollutionCondition;

typedef void(^WKWeatherBlock)(NSDictionary *);




@interface WKWeatherManager : NSObject

+ (void)getWeatherWithCityName:(NSString *)cn block:(WKWeatherBlock)block;


@end
