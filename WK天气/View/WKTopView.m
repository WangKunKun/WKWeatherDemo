//
//  WKTopView.m
//  WK天气
//
//  Created by qitian on 16/6/23.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKTopView.h"
#import "NSString+WKNumberToChinese.h"

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

- (void)setTemperature:(NSString *)temperature
{
    _temperatureLabel.text = temperature;
}


- (void)setInterFaceWithModel:(WKWeatherModel *)model
{
    //2016-6-22 转为 六月二十二日
    NSMutableArray * dateArr = [[model.weatherDayInfos[0].presentDate componentsSeparatedByString:@"-"] mutableCopy];
    [dateArr removeObjectAtIndex:0];//去掉年份
    NSMutableString * dateStr = [NSMutableString string];
    NSArray * tempArr = @[@"月",@"日"];
    for (NSUInteger i = 0; i < dateArr.count ; i++) {
        [dateStr appendString:[NSString numberToChinese:dateArr[i]]];
        [dateStr appendString:tempArr[i]];
    }
    self.date =  !model ? @"" : [NSString stringWithFormat:@"国 %@",dateStr];
    self.chineseDate =  !model ? @"" : [NSString stringWithFormat:@"阴 %@",model.weatherDayInfos[0].presentChineseData];
    self.week =   !model ? @"" : [NSString stringWithFormat:@"星期%@",[NSString numberToChinese:@(model.realtimeInfo.week)]];
    
    self.weather =  !model ? @"--" : model.realtimeInfo.weatherInfo;
    self.temperature =  !model ? @"--" : [NSString stringWithFormat:@"%ld°",model.realtimeInfo.temperature];
    self.dayTemperature =  !model ? @"" : [NSString stringWithFormat:@"%@",model.weatherDayInfos[0].day[WKWeatherTemperature]];
    self.nightTemperature =  !model ? @"" : [NSString stringWithFormat:@"%@",model.weatherDayInfos[0].night[WKWeatherTemperature]];
    self.cityName =  !model ? @"" : model.realtimeInfo.cityName;
}
@end
