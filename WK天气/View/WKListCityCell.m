//
//  WKListCityCell.m
//  WK天气
//
//  Created by qitian on 16/6/24.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKListCityCell.h"

@interface WKListCityCell ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation WKListCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WKWeatherModel *)model
{
    _model = model;
    NSArray * colors = @[UIColorFromRGB(0x11cb60),UIColorFromRGB(0xffc703),UIColorFromRGB(0xff8004),UIColorFromRGB(0xfe3d3d),UIColorFromRGB(0xa50894),UIColorFromRGB(0x45018a)];
    self.contentView.backgroundColor = colors[model.pmInfo.pmLevel - 1];
    _temperatureLabel.text = [NSString stringWithFormat:@"%lu°",model.realtimeInfo.temperature];
    _cityNameLabel.text = model.realtimeInfo.cityName;
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString * hourStr = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"hh:mm"];
    NSString * dateStr = [formatter stringFromDate:date];
    
    NSString * subStr = [hourStr integerValue] > 12 ? @"下午" :@"上午";
    
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",subStr,dateStr];
    
}

- (void)setFlag:(BOOL)flag
{
    NSString * str = flag ? [NSString stringWithFormat:@"%d°",(int)(_model.realtimeInfo.temperature * 33.8f)] : [NSString stringWithFormat:@"%lu°",(unsigned long)_model.realtimeInfo.temperature];
    _temperatureLabel.text = str;
}
@end
