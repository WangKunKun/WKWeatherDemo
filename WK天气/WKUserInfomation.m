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

static NSString * presentCityName = @"WKPresentCityName";

@interface WKUserInfomation ()

@property (nonatomic, strong) NSMutableArray<NSDictionary *> * city_models;

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



- (void)setCity_models:( NSMutableArray<NSDictionary *> *)city_models
{
    _city_models = city_models;    
    [self checkModel];
    
}

- (void)setCityModels:( NSMutableArray<NSDictionary *> *)dict
{
    
    
    self.city_models = dict;
}

- (void)checkModel
{
    NSMutableArray * noModelCitys = [NSMutableArray array];

    NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
    //城市名 转换为纯字典 因为不需要绝对顺序
    for (NSDictionary * dict in _city_models) {
        NSString * key = [dict allKeys][0];
        NSString * value = [dict allValues][0];
        [dicts setObject:value forKey:key];
    }
    
    //得到没有数据的城市名字
    for (NSString * key in [dicts allKeys]) {
        id value = [dicts objectForKey:key];
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
                for (NSString * key in [dicts allKeys])//遍历存储的城市名
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
                [self wkInnerRemoveObjectForKey:key];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            });
            
        }];
    });
}

- (NSArray *)allKeys
{
    
    NSMutableArray * keys = [NSMutableArray array];
    for (NSDictionary * dict in _city_models) {
        [keys addObjectsFromArray:[dict allKeys]];
    }
    
    return keys;
}

- (NSArray *)allValues
{
    
    NSMutableArray * values = [NSMutableArray array];
    for (NSDictionary * dict in _city_models) {
        [values addObjectsFromArray:[dict allValues]];
    }
    return values;
}

//两个一样的功能 刷新数据
- (void)wkSetObject:(id)value forKey:(NSString *)key
{
    [self wkInnerSetObject:value forKey:key];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    });
}
//不刷新数据  优化
- (void)wkInnerSetObject:(id)value forKey:(NSString *)key
{
    [self wkInnerRemoveObjectForKey:key];
    NSDictionary * dict = @{key:value};
    [self.city_models addObject:dict];
}




- (NSDictionary *)wkInnerRemoveObjectForKey:(NSString *)key
{
    NSDictionary * newDict = nil;
    for (NSDictionary * dict in _city_models) {
        if ([[dict allKeys] containsObject:key]) {
            newDict = dict;
            break;
        }
    }
    if (newDict) {
        [_city_models removeObject:newDict];
    }
    return newDict;
}


- (void)wkRemoveObjectForKey:(NSString *)key
{
    NSDictionary * newDict = [self wkInnerRemoveObjectForKey:key];
    
    if (newDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        });
    }
}

- (id)wkObjectForKey:(NSString *)key
{
    
    NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
    //城市名 转换为纯字典 因为不需要绝对顺序
    for (NSDictionary * dict in _city_models) {
        NSString * key = [dict allKeys][0];
        NSString * value = [dict allValues][0];
        [dicts setObject:value forKey:key];
    }
    
    
    return [dicts objectForKey:key];
}

- (void)save
{

    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:_city_models forKey:localData];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self getFilePath] atomically:YES];
    //存储当前定位城市
    [[NSUserDefaults standardUserDefaults] synchronize];

}

//获得数据
- (void)fetch
{
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePath]];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //解档出数据模型Student
    _city_models = [unarchiver decodeObjectForKey:localData];
    [unarchiver finishDecoding];
    

}
//获得路径
- (NSString *)getFilePath
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingString:@"/weatherData.archiver"];
    return path;
}


+ (NSString *)getCityName
{
    id str = [[NSUserDefaults standardUserDefaults] objectForKey:presentCityName];
    return  str ? : @"";
}

+ (void)setCityName:(NSString *)sn
{
    [[NSUserDefaults standardUserDefaults] setObject:sn forKey:presentCityName];
}

@end
