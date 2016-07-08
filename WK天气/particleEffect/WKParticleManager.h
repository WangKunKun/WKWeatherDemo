//
//  WKParticleManager.h
//  WK天气
//
//  Created by qitian on 16/7/1.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WKParticleStyle)
{
    WKParticleStyle_Rain ,//雨
    WKParticleStyle_Snow,//雪
    WKParticleStyle_Cloud,
    WKParticleStyle_Sunshine,//晴
    WKParticleStyle_Waiting,
    WKParticleStyle_Fireworks
};
 

@interface WKParticleManager : NSObject

+ (CAEmitterLayer *)createParticleEffectWithStyle:(WKParticleStyle)style;

+ (WKParticleStyle)weatherTypeToParticleStyle:(WKWeatherType)type;

@end
