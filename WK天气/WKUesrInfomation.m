//
//  WKUesrInfomation.m
//  WK天气
//
//  Created by qitian on 16/6/20.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKUesrInfomation.h"

static NSString * citysKey = @"citys";

@implementation WKUesrInfomation

+ (WKUesrInfomation *)shardUsrInfomation
{
    static WKUesrInfomation * ui = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ui = [[WKUesrInfomation alloc] init];
    });
    return ui;
}

- (void)setCitys:(NSArray *)citys
{
    [[NSUserDefaults standardUserDefaults] setObject:citys forKey:citysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)citys
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:citysKey];
}

@end
