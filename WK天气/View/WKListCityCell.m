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
@property (strong, nonatomic) CAEmitterLayer * eLayer;
@end

@implementation WKListCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //添加点击效果
    _eLayer = [WKParticleManager createParticleEffectWithStyle:WKParticleStyle_Fireworks];
    _eLayer.frame = self.contentView.frame;
    [self.contentView.layer addSublayer:_eLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WKWeatherModel *)model
{
    _model = model;
    if (![_model isKindOfClass:[WKWeatherModel class]]) {
        _model = nil;
        return;
    }
    NSArray * colors = @[UIColorFromRGB(0x11cb60),UIColorFromRGB(0xffc703),UIColorFromRGB(0xff8004),UIColorFromRGB(0xfe3d3d),UIColorFromRGB(0xa50894),UIColorFromRGB(0x45018a)];
    self.contentView.backgroundColor = colors[model.pmInfo.pmLevel - 1];

    _temperatureLabel.text = [NSString stringWithFormat:@"%ld°",model.realtimeInfo.temperature];
    _cityNameLabel.text = model.realtimeInfo.cityName;
    
    [self setDate];
    
}

- (void)setDate
{
    
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
    _flag =flag;
//    NSLog(@"%@",[NSString stringWithFormat:@"%.1f°",(32 + _model.realtimeInfo.temperature * 1.8f)]);
    NSString * str = flag ? [NSString stringWithFormat:@"%.1f°",(32 + _model.realtimeInfo.temperature * 1.8f)] : [NSString stringWithFormat:@"%ld°",_model.realtimeInfo.temperature];
    _temperatureLabel.text = str;
}

- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    _cityNameLabel.text = cityName;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];
    
    //添加粒子效果动画
    CABasicAnimation *burst = [CABasicAnimation animationWithKeyPath:@"emitterCells.ring.birthRate"];
    burst.fromValue			= [NSNumber numberWithFloat: 20.0];
    burst.toValue			= [NSNumber numberWithFloat: 0.0];
    burst.duration			= 0.5;
    burst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.eLayer addAnimation:burst forKey:@"burst"];
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.eLayer.emitterPosition	= touchPoint;
    [CATransaction commit];
    
    [super touchesBegan:touches withEvent:event];

}

@end
