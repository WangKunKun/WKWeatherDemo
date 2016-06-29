//
//  WKTopView.h
//  WK天气
//
//  Created by qitian on 16/6/23.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKTopView : UIView

@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSString * weather;
@property (nonatomic, strong) NSString * chineseDate;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * week;
@property (nonatomic, strong) NSString * temperature;
@property (nonatomic, strong) NSString * dayTemperature;
@property (nonatomic, strong) NSString * nightTemperature;
+ (instancetype)viewFromNIB;

- (void)setInterFaceWithModel:(WKWeatherModel *)model;

@end
