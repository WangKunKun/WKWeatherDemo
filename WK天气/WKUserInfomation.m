//
//  WKUesrInfomation.m
//  WK天气
//
//  Created by qitian on 16/6/20.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKUserInfomation.h"
#import "WKWeatherManager.h"

static NSString * citysKey = @"citys";

static NSString * localData = @"WKWeatherLocalData";

@interface WKUserInfomation ()

@property (nonatomic, strong) NSDictionary * city_models;

@end

@implementation WKUserInfomation

+ (WKUserInfomation *)shardUsrInfomation
{
    static WKUserInfomation * ui = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ui = [[WKUserInfomation alloc] init];
        //获得 存储
        [ui fetch];
        //注册通知 只在特定时候保存到本地
        UIApplication *app = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:ui selector:@selector(save) name:UIApplicationWillResignActiveNotification object:app];
    });
    return ui;
}



- (void)setCity_models:(NSDictionary *)city_models
{
    _city_models = city_models;
    [self checkModel];
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)setCityModels:(NSDictionary *)dict
{
    self.city_models = dict;
}

- (void)checkModel
{
    NSMutableArray * noModelCitys = [NSMutableArray array];
    NSLog(@"%@",NSStringFromSelector(_cmd));

    //得到没有数据的城市名字
    for (NSString * key in [_city_models allKeys]) {
        id value = [_city_models objectForKey:key];
        if ([value isEqual:defaultValue]) {
            [noModelCitys addObject:key];
        }
    }
    
    
    dispatch_queue_t queue = dispatch_queue_create("WKGetData", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [WKWeatherManager getWeatherWithCityNames:noModelCitys block:^(NSArray<WKWeatherModel *> *models,NSArray<NSString *>*invaildCitys) {
            for (WKWeatherModel * temp in models)
            {
                //取得数据的n城市名
                NSString * cityName = temp.realtimeInfo.cityName;
                for (NSString * key in [_city_models allKeys])//遍历存储的城市名
                {
                    //因为存储的城市名可能字符要多一些
                    if (key.length >= cityName.length) {
                        //截取恰当的部分
                        NSString * subKey = [key substringToIndex:cityName.length];
                        //比对
                        if ([subKey isEqualToString:cityName]) {
                            //相等后则将数据存入对应的城市名
                            [self wkInnerSetObject:temp forKey:key];
                            break;
                        }
                    }
                }
            }
            //没有数据的城市
            for (NSString * key in invaildCitys) {
                [self wkRemoveObjectForKey:key];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            });
            
        }];
    });
}

- (NSArray *)allKeys
{
    return [_city_models allKeys];
}

- (NSArray *)allValues
{
    return [_city_models allValues];
}

//两个一样的功能 刷新数据
- (void)wkSetObject:(id)value forKey:(NSString *)key
{
    NSMutableDictionary * dict = _city_models ?[_city_models mutableCopy] : [NSMutableDictionary dictionary];
    [dict setValue:value forKey:key];
    self.city_models = [dict copy];
}
//不刷新数据  优化
- (void)wkInnerSetObject:(id)value forKey:(NSString *)key
{
    NSMutableDictionary * dict = _city_models ?[_city_models mutableCopy] : [NSMutableDictionary dictionary];
    [dict setValue:value forKey:key];
    _city_models = [dict copy];
}


- (id)wkObjectForKey:(NSString *)key
{
    return [_city_models objectForKey:key];
}

- (void)wkRemoveObjectForKey:(NSString *)key
{
    NSMutableDictionary * dict = [_city_models mutableCopy];
    [dict removeObjectForKey:key];
    _city_models = [dict copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    });

}

- (void)save
{

    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:_city_models forKey:localData];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self getFilePath] atomically:YES];
    
}

- (void)fetch
{
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePath]];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //解档出数据模型Student
    _city_models = [unarchiver decodeObjectForKey:localData];
    [unarchiver finishDecoding];
    

}

- (NSString *)getFilePath
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingString:@"/weatherData.archiver"];
    return path;
}
@end
