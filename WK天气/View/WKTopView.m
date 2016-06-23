//
//  WKTopView.m
//  WK天气
//
//  Created by qitian on 16/6/23.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKTopView.h"

@interface WKTopView ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *nightTemperatureLabel;

@end

@implementation WKTopView

+ (instancetype)viewFromNIB
{
    WKTopView * view = [[[NSBundle mainBundle]loadNibNamed:@"WKTopView" owner:nil options:nil]firstObject];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)awakeFromNib
{
    self.widthS = SCREEN_WIDTH;
    [self layoutIfNeeded];
}

- (void)setCityName:(NSString *)cityName
{
    _cityNameLabel.text = cityName;
}

- (void)setDate:(NSString *)date
{
    _dateLabel.text = date;
}

- (void)setChineseDate:(NSString *)chineseDate
{
    _chineseDateLabel.text = chineseDate;
}

- (void)setWeek:(NSString *)week
{
    _weekLabel.text = week;
}

- (void)setWeather:(NSString *)weather
{
    _weatherLabel.text = weather;
}

- (void)setDayTemperature:(NSString *)dayTemperature
{
    _dayTemperatureLabel.text = dayTemperature;
}

- (void)setNightTemperature:(NSString *)nightTemperature
{
    _nightTemperatureLabel.text = nightTemperature;
}
@end
