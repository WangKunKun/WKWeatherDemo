//
//  WKMapManager.m
//  WK天气
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKMapManager.h"

@interface WKMapManager ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager * locatiobManager;

@end

@implementation WKMapManager

- (void)initGDMap
{
    [AMapLocationServices sharedServices].apiKey = @"2b2f504535c6feae63cc83578be7aa8b";
    _locatiobManager = [[AMapLocationManager alloc] init];
    _locatiobManager.pausesLocationUpdatesAutomatically = NO;//不会被系统暂停
    _locatiobManager.allowsBackgroundLocationUpdates = YES;//启动后台定位
    _locatiobManager.distanceFilter = 5;
    _locatiobManager.delegate = self;
}

+ (WKMapManager *)shardMapManager
{
    static WKMapManager * WKMapmanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WKMapmanager = [[WKMapManager alloc] init];
        [WKMapmanager initGDMap];
    });
    return WKMapmanager;
}

- (void)startLocationWithBlock:(LocationBlock)block;
{

    [_locatiobManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (block) {
            NSString * cityName = !error ? regeocode.city : @"成都市";
            if (cityName.length > 0) {
                block(cityName);
            }
        }
    }];
}

@end
