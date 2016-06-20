//
//  WKWeatherCell.m
//  WK天气
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKWeatherCell.h"

@interface WKWeatherCell ()

@property (strong, nonatomic) IBOutlet UILabel *dayTemperatureLabel;

@property (strong, nonatomic) IBOutlet UILabel *nightTemperatureLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIV;
@property (strong, nonatomic) IBOutlet UILabel *weekTitleLabel;

@end

@implementation WKWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDayTemperature:(NSNumber *)dayTemperature
{
    _dayTemperatureLabel.text = [NSString stringWithFormat:@"%@",dayTemperature];
}

- (void)setNightTemperature:(NSNumber *)nightTemperature
{
    _nightTemperatureLabel.text = [NSString stringWithFormat:@"%@",nightTemperature];
}

- (void)setWeekDay:(NSString *)weekDay
{
    _weekTitleLabel.text = weekDay;
}

- (void)setInterFaceWithModel:(WKWeatherDayInfo *)model
{
//    _weekTitleLabel.text = [NSString stringWithFormat:@"星期%@",model.week];
    _weekTitleLabel.text = model.day[WKWeatherType_Text];
    _dayTemperatureLabel.text = [NSString stringWithFormat:@"%@",model.day[WKWeatherTemperature]] ;
    _nightTemperatureLabel.text = [NSString stringWithFormat:@"%@",model.night[WKWeatherTemperature]] ;
    
    NSMutableString * imageName = [NSMutableString stringWithFormat:@"weather_code_day_%@",model.day[WKWeatherType_Number]];
    
    
    _weatherIV.image = [UIImage imageNamed:imageName];
}



@end
