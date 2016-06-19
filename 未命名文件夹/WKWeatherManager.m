//
//  WKWeatherManager.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/14.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#define APPID_WEATHER @"9bb7a755538977046a2de94ee1ff81d7"


#import "WKWeatherManager.h"
#import <AFNetworking/AFNetworking.h>
#import "WKWeatherModel.h"


@interface WKWeatherManager ()

//请求
@property(nonatomic, strong) AFHTTPSessionManager* httpManager;
@property(nonatomic, strong) NSURLSessionTask*  sessionTask;


@property (nonatomic, copy) WKWeatherBlock block;
@end

@implementation WKWeatherManager

+ (void)getWeatherWithCityName:(NSString *)cn block:(WKWeatherBlock)block
{
    WKWeatherManager * wm = [self shareWKWM];
    wm.block = block;
    [wm getWeatherWithCityName:cn];
}

+ (WKWeatherManager *)shareWKWM
{
    static WKWeatherManager * wm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wm = [[WKWeatherManager alloc] init];
        [wm initVar];
    });
    return wm;
}

- (void)initVar
{
    _httpManager=[AFHTTPSessionManager manager];
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    _httpManager.requestSerializer.timeoutInterval=25;
}

-(void)getWeatherWithCityName:(NSString* )cityName{
    
    NSDictionary *params = @{@"cityname":cityName,@"key":APPID_WEATHER};
    _sessionTask=[_httpManager POST:@"http://op.juhe.cn/onebox/weather/query" parameters:params success:^(NSURLSessionTask*taskOperation ,id responseObject)
                  {

//                      WKWeatherModel * model = [WKWeatherModel mj_objectWithKeyValues:responseObject[@"result"][@"data"]];
//                      NSLog(@"%@",model.indexInfo.dressIndex[1]);
//                      NSLog(@"%@",model.pmInfo.cityName);
//                      NSLog(@"%d",model.realtimeInfo.week);
//
//                      NSLog(@"%@",model.weatherData);

                      
                      if ([[responseObject objectForKey:@"result"] isKindOfClass:[NSNull class]]) {
                          
                      }else
                      {
                          NSDictionary* lifeDict=[[[[responseObject objectForKey:@"result"]objectForKey:@"data"]objectForKey:@"life"]objectForKey:@"info" ];
                          
                          NSDictionary* pmDict=[[[responseObject objectForKey:@"result"]objectForKey:@"data"]objectForKey:@"pm25"];
                          NSDictionary* temperatureDict=[[[responseObject objectForKey:@"result"]objectForKey:@"data"]objectForKey:@"realtime"];
                          
                          NSString* wuRanStr=[lifeDict objectForKey:@"wuran"][0];
                          NSString* yundongStr=[lifeDict objectForKey:@"yundong"][0];
                          
                          NSString* curPm=[[pmDict objectForKey:@"pm25"] objectForKey:@"curPm"];
                          NSString* quality=[[pmDict objectForKey:@"pm25"]objectForKey:@"quality"];
                          
                          NSString* temperatureStr=[[temperatureDict objectForKey:@"weather"] objectForKey:@"temperature"];
                          NSLog(@"当前temperatureStr:%@",temperatureStr);
                          NSLog(@"当前quality:%@",quality);
                          NSLog(@"当前Pm:%@",curPm);
                          NSLog(@"污染:%@",wuRanStr);
                          NSLog(@"运动:%@",yundongStr);
                          NSLog(@"天气Life返回数据:%@",lifeDict);
                          NSLog(@"天气pm:%@",pmDict);
//                          NSLog(@"天气返回数据:%@",responseObject);
                          
                          
                          if (_block) {
                              _block(responseObject[@"result"]);
                          }
                          
                      }

                  
                  }failure:nil];
    
    
    
}

@end
