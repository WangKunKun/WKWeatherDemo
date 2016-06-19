//
//  WKWeatherCell.h
//  WK天气
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWeatherModel.h"
@interface WKWeatherCell : UITableViewCell

@property (nonatomic, strong) NSString * weekDay;
@property (nonatomic, strong) NSNumber * weatherType;
@property (nonatomic, strong) NSNumber * dayTemperature;
@property (nonatomic, strong) NSNumber * nightTemperature;

- (void)setInterFaceWithModel:(WKWeatherDayInfo *)model;

@end
