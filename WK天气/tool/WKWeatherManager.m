//
//  WKWeatherManager.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/14.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#define APPID_WEATHER @"9bb7a755538977046a2de94ee1ff81d7"


#import "WKWeatherManager.h"


@interface WKWeatherManager ()

//请求
@property(nonatomic, strong) AFHTTPSessionManager* httpManager;
@property(nonatomic, strong) NSURLSessionTask*  sessionTask;


@end

@implementation WKWeatherManager

+ (void)getWeatherWithCityName:(NSString *)cn block:(WKWeatherBlock)block
{
    WKWeatherManager * wm = [self shareWKWM];
    [wm getWeatherWithCityName:cn block:block];
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

-(void)getWeatherWithCityName:(NSString* )cityName block:(WKWeatherBlock)block{
    
    NSDictionary *params = @{@"cityname":cityName,@"key":APPID_WEATHER};
    _sessionTask=[_httpManager POST:@"http://op.juhe.cn/onebox/weather/query" parameters:params success:^(NSURLSessionTask*taskOperation ,id responseObject){
      
        id result = responseObject[@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (block ) {
                WKWeatherModel * model = [WKWeatherModel createWeatherModelWithDict:responseObject[@"result"][@"data"]];
                block(model,cityName);
            }
        }
        else
        {
            NSLog(@"对不起，暂无此城市的数据~");
            if (block ) {
                block(nil,cityName);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        if (block ) {
            block(nil,cityName);
        }
    }];
}

+ (void)getWeatherWithCityNames:(NSArray<NSString *> *)cns block:(WKWeathersBlock)block
{
    NSLog(@"数据请求中");
    
    WKWeatherManager * wm = [self shareWKWM];
    dispatch_group_t queueGroup = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSMutableArray * models = [NSMutableArray array];
    __block NSMutableArray * invaildCitys = [NSMutableArray array];

    for (NSUInteger i = 0; i < cns.count; i ++) {
        
       dispatch_group_async(queueGroup, dispatch_get_global_queue(0,0), ^{
            [wm getWeatherWithCityName:cns[i] block:^(WKWeatherModel * model,NSString * cityname) {
                if (model != nil) {
                    [models addObject:model];
                }
                else
                {
                    [invaildCitys addObject:cityname];
                }
                dispatch_semaphore_signal(semaphore);
            }];
       });

    }
    
    for (NSUInteger i = 0; i < cns.count; i ++) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    NSString * hint = @"";
    for (NSString * str in invaildCitys) {
        hint = [hint stringByAppendingString:str];
        hint = [hint stringByAppendingString:@"," ];
    }
    
    if (hint.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            WKAlertView * av = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring noticStyle:1 title:@"对不起,下列城市占无数据" detail:[hint substringToIndex:hint.length - 1] canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
                //点击效果
                
            }];
            [av show];

        });
    }


    NSLog(@"数据请求完毕");

    if (block) {
        block([models copy],invaildCitys);
    }
}


@end
