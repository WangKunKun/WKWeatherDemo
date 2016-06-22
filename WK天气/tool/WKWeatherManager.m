//
//  WKWeatherManager.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/14.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#define APPID_WEATHER @"9bb7a755538977046a2de94ee1ff81d7"


#import "WKWeatherManager.h"
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
    _sessionTask=[_httpManager POST:@"http://op.juhe.cn/onebox/weather/query" parameters:params success:^(NSURLSessionTask*taskOperation ,id responseObject){
      
        id result = responseObject[@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (_block ) {
                _block(responseObject[@"result"]);
            }
        }
        else
        {
            NSLog(@"对不起，暂无此城市的数据~");
        }
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    
}

@end
