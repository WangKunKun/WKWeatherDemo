//
//  WKParticleManager.m
//  WK天气
//
//  Created by qitian on 16/7/1.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKParticleManager.h"

@implementation WKParticleManager

+ (CAEmitterLayer *)createParticleEffectWithStyle:(WKParticleStyle)style
{
    
    CAEmitterLayer * layer = nil;
    
    switch (style) {
        case WKParticleStyle_Rain: {
            layer = [self rain];
            break;
        }
        case WKParticleStyle_Snow: {
            layer = [self snow];
            break;
        }
        case WKParticleStyle_Sunshine: {
            layer = [self sunny];
            break;
        }
            
        case WKParticleStyle_Cloud:
        {
            layer = [self cloud];
        }
            
            
            break;
        case WKParticleStyle_Waiting: {
            layer = [self waiting];
            break;
        }
            
        case WKParticleStyle_Fireworks:
        {
            layer = [self fireworks];
            break;
        }
    }
    
    return layer;
}


+ (CAEmitterLayer *)rain
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CAEmitterLayer * layer = [CAEmitterLayer layer];
    layer.frame = frame;
    layer.emitterShape = kCAEmitterLayerLine;
    //    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.emitterPosition = CGPointMake(frame.size.width / 2.0, -50);
    layer.emitterSize = frame.size;
    layer.emitterMode = kCAEmitterLayerSurface;
    CAEmitterCell * cell =  [CAEmitterCell new];
    //cell 内容
    cell.contents = (id)[UIImage imageNamed:@"ele_rainLine3"].CGImage;
    cell.birthRate = 300;//粒子每秒创建数
    cell.lifetime =3;//存活时间 = cell.lifetime * layer.lifeTime;
    cell.lifetimeRange = 10.0;//周期时间偏移量
    cell.yAcceleration = 200.0;  //给Y方向一个加速度
    cell.velocity = 200; //初始速度
    //粒子生成时，颜色的随机生成 参数 原色 +- range
    cell.redRange = 0.3;
    cell.greenRange = 0.3;
    cell.blueRange = 0.3 ;
    
    cell.alphaRange = 0.2;   //随机透明度
    cell.alphaSpeed = -0.15;//透明度变化速度
    
    
    layer.emitterCells = @[cell];
    
    return layer;

}

+ (CAEmitterLayer *)snow
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CAEmitterLayer * layer = [CAEmitterLayer layer];
    layer.frame = frame;
    layer.emitterShape = kCAEmitterLayerLine;

    layer.emitterPosition = CGPointMake(frame.size.width / 2.0, 0);
    layer.emitterSize = frame.size;
    layer.emitterMode = kCAEmitterLayerSurface;
    CAEmitterCell * cell =  [CAEmitterCell new];
    //cell 内容
    cell.contents = (id)[UIImage imageNamed:@"ele_snowGrain1"].CGImage;
    
    cell.birthRate = 300;//粒子每秒创建数
    cell.lifetime =3;//存活时间 = cell.lifetime * layer.lifeTime;
    cell.lifetimeRange = 10.0;//周期时间偏移量
    cell.yAcceleration = 200;  //给Y方向一个加速度
    cell.velocity = 200; //初始速度
    
    //粒子生成时，颜色的随机生成 参数 原色 +- range
    cell.redRange = 0.3;
    cell.greenRange = 0.3;
    cell.blueRange = 0.3 ;
    

    
    layer.emitterCells = @[cell];
    
    return layer;
}

+ (CAEmitterLayer *)cloud
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CAEmitterLayer * layer = [CAEmitterLayer layer];
    layer.frame = frame;
    layer.emitterShape = kCAEmitterLayerRectangle;
    
    layer.emitterPosition = CGPointMake(- 100, 250 / 2);
    layer.emitterSize = CGSizeMake( -200, 250);
    layer.emitterMode = kCAEmitterLayerSurface;
    
    CAEmitterCell * cell =  [CAEmitterCell new];
     UIImage * image = [UIImage imageNamed:@"ele_sunnyCloud1"] ;
    image = [image compressImage:CGSizeMake(image.size.width / 2.0, image.size.height / 2.0)];
    cell.contents = (id)image.CGImage;
    cell.birthRate = 0.05;//粒子每秒创建数
    cell.lifetime =60;//存活时间 = cell.lifetime * layer.lifeTime;
    cell.lifetimeRange = 10.0;//周期时间偏移量
    cell.velocity = 10; //初始速度
    cell.emissionLongitude =0.086;
    
    
    CAEmitterCell * cell1 =  [CAEmitterCell new];
    UIImage * image1 = [UIImage imageNamed:@"ele_sunnyCloud2"] ;
    image1 = [image1 compressImage:CGSizeMake(image1.size.width / 2.0, image1.size.height / 2.0)];
    cell1.contents = (id)image.CGImage;
    cell1.birthRate = 0.1;//粒子每秒创建数
    cell1.lifetime =50;//存活时间 = cell.lifetime * layer.lifeTime;
    cell1.lifetimeRange = 10.0;//周期时间偏移量
    cell1.velocity = 10; //初始速度
    cell1.emissionLongitude =0.086;
    
    layer.emitterCells = @[cell,cell1];
    return layer;
}

+ (CAEmitterLayer *)sunny
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CAEmitterLayer * layer = [CAEmitterLayer layer];
    layer.frame = frame;
    layer.emitterShape = kCAEmitterLayerPoint;
    
    layer.emitterPosition = CGPointMake(80, 40);
    layer.emitterSize = frame.size;
    layer.emitterMode = kCAEmitterLayerPoints;
    
    CAEmitterCell * sunCell =  [CAEmitterCell new];
    UIImage * sunImage = [UIImage imageNamed:@"ele_sunnySun"] ;
    sunCell.contents = (id)sunImage.CGImage;
    sunCell.birthRate = 1 / 30.0;//粒子每秒创建数
    sunCell.lifetime = 30;//存活时间 = cell.lifetime * layer.lifeTime;
    sunCell.velocity = 0; //初始速度

    
    CAEmitterCell * sunshineCell =  [CAEmitterCell new];
    UIImage * sunshineImage = [UIImage imageNamed:@"ele_sunnySunshine"] ;
    sunshineCell.contents = (id)sunshineImage.CGImage;
    sunshineCell.birthRate = 1 / 10.0;//粒子每秒创建数
    sunshineCell.lifetime = 10;//存活时间 = cell.lifetime * layer.lifeTime;
    sunshineCell.velocity = 0; //初始速度
    sunshineCell.alphaSpeed = -(1.0 / sunshineCell.lifetime);//透明度
    //旋转角度 (M_PI/180)*90.0 旋转90度  除以10是将90度分配到10秒钟
    sunshineCell.spin = ((M_PI/180)*90.0) / 10;
    
    layer.emitterCells = @[sunCell,sunshineCell];
    return layer;
}


//模拟出来的转圈
+ (CAEmitterLayer *)waiting
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CAEmitterLayer * layer = [CAEmitterLayer layer];
    layer.frame = CGRectMake(0, 0, 50, 50);
    layer.emitterShape = kCAEmitterLayerCircle;
    
    layer.emitterPosition = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
    layer.emitterSize = CGSizeMake(50, 50);
    layer.emitterMode = kCAEmitterLayerOutline;
    
    CAEmitterCell * cell =  [CAEmitterCell new];
    UIImage * image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10) cornerRadius:5];
    
    cell.contents = (id)image.CGImage;
    cell.birthRate = 500;//粒子每秒创建数
    cell.lifetime = 0.1;//存活时间 = cell.lifetime * layer.lifeTime;
    cell.emissionLongitude = M_PI * 0.5;

    
    cell.scale = 0.5;
    cell.scaleRange = 0.3;
    
    cell.alphaRange = 0.5;
    //粒子生成时，颜色的随机生成 参数 原色 +- range
    cell.redRange = .5f;
    cell.greenRange = .5f;
    cell.blueRange = .5f ;
    cell.velocity = 100; //初始速度
    
    layer.emitterCells = @[cell];
    return layer;
}

+ (CAEmitterLayer *)fireworks
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CAEmitterLayer * layer = [CAEmitterLayer layer];
    layer.frame = CGRectMake(0, 0, 50, 50);
    layer.emitterShape = kCAEmitterLayerPoint;
    layer.emitterPosition = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
    layer.emitterSize = CGSizeMake(50, 50);
    layer.emitterMode = kCAEmitterLayerOutline;
    
    CAEmitterCell * cell =  [CAEmitterCell new];
    UIImage * image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10) cornerRadius:5];
    [cell setName:@"ring"];
    cell.contents = (id)image.CGImage;
//    cell.birthRate = 5;//粒子每秒创建数 不设置默认为0
    cell.lifetime = 1;//存活时间 = cell.lifetime * layer.lifeTime;
    cell.emissionLongitude  =  - (M_PI * 0.5);
    cell.emissionRange		= M_PI * 0.5;	// 360 deg
    cell.yAcceleration		= 75;
    
    cell.scale = 0.5;
    cell.scaleRange = 0.3;
    
    cell.alphaRange = 0.5;
    cell.scaleSpeed =-0.2;
    //粒子生成时，颜色的随机生成 参数 原色 +- range
    cell.redRange = .5f;
    cell.greenRange = .5f;
    cell.blueRange = .5f ;
    cell.velocity = 125; //初始速度
    
    layer.emitterCells = @[cell];
    return layer;

}

+ (WKParticleStyle)weatherTypeToParticleStyle:(WKWeatherType)type
{
    WKParticleStyle style = 0;
//TODO 后续需要添加 太多共用了
    switch (type) {
        case WKWeatherType_Sunny: {
            style = WKParticleStyle_Sunshine;
            break;
        }
            
        case WKWeatherType_FlyAsh:
        case WKWeatherType_Micrometeorology:
        case WKWeatherType_StrongSandstorms:
        case WKWeatherType_Haze:
        case WKWeatherType_Fog:
        case WKWeatherType_DustStorms:
        case WKWeatherType_Cloudy:
        case WKWeatherType_Shade: {
            style = WKParticleStyle_Cloud;
            break;
        }
        case WKWeatherType_Shower:
        case WKWeatherType_ThunderShower:
        case WKWeatherType_ThunderShowerWithHail:
        case WKWeatherType_Sleet:
        case WKWeatherType_LightRain:
        case WKWeatherType_ModerateRain:
        case WKWeatherType_HeavyRain:
        case WKWeatherType_Rainstorm:
        case WKWeatherType_HeavyRainstorm:
        case WKWeatherType_ExtraordinaryRainstorm:
        case WKWeatherType_FreezingRain:
        case WKWeatherType_LightModerateRain:
        case WKWeatherType_ModerateHeavyRain:
        case WKWeatherType_HeavyStormRain:
        case WKWeatherType_StormHeavyRain:
        case WKWeatherType_StormExtraordinaryRain: {
            style = WKParticleStyle_Rain;
            break;
        }

            
            
        case WKWeatherType_SnowShower:
        case WKWeatherType_LightSnow:
        case WKWeatherType_ModerateSnow:
        case WKWeatherType_HeavySnow:
        case WKWeatherType_Blizzard: {
            style = WKParticleStyle_Snow;
            break;
        }
    }
    
    return style;
}



@end
