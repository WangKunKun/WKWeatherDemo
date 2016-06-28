//
//  WKWeatherView.m
//  WK天气
//
//  Created by qitian on 16/6/23.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKWeatherView.h"
#import "WKTopView.h"
#import "WKWeatherCell.h"
#import "NSString+WKNumberToChinese.h"

static NSString * reuseID = @"WKWeatherCell";

@interface WKWeatherView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WKTopView * topView;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSString * todayWeatherInfo;





@end

@implementation WKWeatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInterFace];
    }
    return self;
}

- (void)setInterFace
{
    _topView = [WKTopView viewFromNIB];
    _topView.originS = CGPointMake(0, 0);
    [self addSubview:_topView];
    self.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.bottomS, self.widthS , self.heightS-_topView.heightS) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //xib cell 注册方法
    [_tableView registerNib:[UINib nibWithNibName:@"WKWeatherCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    
    
}

- (void)setModel:(WKWeatherModel *)model
{
    _model = model;
    if (![_model isKindOfClass:[WKWeatherModel class]]) {
        _model = nil;
        return;
    }
    //重置初始化位置
    self.contentOffset = CGPointMake(0, 0);
    
    _todayWeatherInfo = !model ? @"" : [NSString stringWithFormat:@"空气质量:  %@\n健康小贴士: %@",_model.pmInfo.pmQuality,_model.pmInfo.pmDes];
    
    [_tableView reloadData];
    
    
    //2016-6-22 转为 六月二十二日
    NSMutableArray * dateArr = [[_model.weatherDayInfos[0].presentDate componentsSeparatedByString:@"-"] mutableCopy];
    [dateArr removeObjectAtIndex:0];//去掉年份
    NSMutableString * dateStr = [NSMutableString string];
    NSArray * tempArr = @[@"月",@"日"];
    for (NSUInteger i = 0; i < dateArr.count ; i++) {
        [dateStr appendString:[NSString numberToChinese:dateArr[i]]];
        [dateStr appendString:tempArr[i]];
    }
    _topView.date =  !model ? @"" : [NSString stringWithFormat:@"国 %@",dateStr];
    _topView.chineseDate =  !model ? @"" : [NSString stringWithFormat:@"阴 %@",_model.weatherDayInfos[0].presentChineseData];
    _topView.week =   !model ? @"" : [NSString stringWithFormat:@"星期%@",[NSString numberToChinese:@(_model.realtimeInfo.week)]];
    
    _topView.weather =  !model ? @"" : _model.realtimeInfo.weatherInfo;
    _topView.temperature =  !model ? @"" : [NSString stringWithFormat:@"%lu°",(unsigned long)_model.realtimeInfo.temperature];
    _topView.dayTemperature =  !model ? @"" : [NSString stringWithFormat:@"%@",_model.weatherDayInfos[0].day[WKWeatherTemperature]];
    _topView.nightTemperature =  !model ? @"" : [NSString stringWithFormat:@"%@",_model.weatherDayInfos[0].night[WKWeatherTemperature]];
    _topView.cityName =  !model ? @"" : _model.realtimeInfo.cityName;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tableView.heightS = _tableView.contentSize.height;
        
        self.contentSize = CGSizeMake(self.widthS, _topView.heightS + _tableView.heightS);
    });
    
    
}



#pragma mark UITableViewDelegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.weatherDayInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WKWeatherCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    [cell setInterFaceWithModel:_model.weatherDayInfos[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString * info = _todayWeatherInfo;
    return [self countSizeWithText:info font:[UIFont systemFontOfSize:15]].height + 10;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.905 alpha:1.000];
    
    UILabel * label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSString * info =_todayWeatherInfo;
    CGSize labelsize = [self countSizeWithText:info font:[UIFont systemFontOfSize:15]];
    label.sizeS = labelsize;
    label.font = [UIFont systemFontOfSize:15];
    label.originS = CGPointMake(10, 5);
    label.text = info;
    label.textColor = [UIColor whiteColor];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [view addSubview:label];
    view.heightS = label.heightS + 10;
    
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.heightS - 0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = [UIColor colorWithWhite:0.905 alpha:1.000];
    
    [view addSubview:topLine];
    [view addSubview:bottomLine];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 250;
}


//tableview footer
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!_model) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    CGFloat startY = 10;
    CGFloat height = 15;
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.905 alpha:1.000];
    [view addSubview:topLine];
    
    //指数信息添加
    
    
    NSArray * arr = @[@"日出",@"日落",@"风向",@"风速",@"穿衣",@"感冒",@"空调",@"污染",@"洗车",@"运动",@"紫外线"];
    NSMutableArray * content = [NSMutableArray array];
    if (_model.indexInfo) {
        [content addObject:_model.weatherDayInfos[0].day[WKWeatherTime]];
        [content addObject:_model.weatherDayInfos[0].night[WKWeatherTime]];
        
        [content addObject:_model.realtimeInfo.windDirect];
        [content addObject:_model.realtimeInfo.windSpeed];
        
        
        [content addObject:_model.indexInfo.dressIndex[0]];
        [content addObject:_model.indexInfo.coldIndex[0]];
        [content addObject:_model.indexInfo.airConIndex[0]];
        [content addObject:_model.indexInfo.polluteIndex[0]];
        [content addObject:_model.indexInfo.dustIndex[0]];
        [content addObject:_model.indexInfo.sportIndex[0]];
        [content addObject:_model.indexInfo.rayIndex[0]];
        
    }
    
    for (NSUInteger i = 0; i < arr.count; i ++) {
        UILabel * label = [self createIndexLabel];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.width.lessThanOrEqualTo(@20);
            make.height.equalTo(@(height));
            make.top.equalTo(view).with.offset(startY);
        }];
        label.text = @": ";
        
        UILabel * titleLabel = [self createIndexLabel];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.width.lessThanOrEqualTo(@50);
            make.height.equalTo(@(height));
            make.top.equalTo(label);
        }];
        titleLabel.text = arr[i];
        
        UILabel * contentLabel = [self createIndexLabel];
        [view addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.width.lessThanOrEqualTo(@200);
            make.height.equalTo(@(height));
            make.top.equalTo(label);
        }];
        if (content.count  > i) {
            contentLabel.text = content[i];
        }
        startY += 15 + 5;
        
        if (i == 1 || i == 3) {
            startY += 10;
        }
    }
    
    
    return view;
}
#pragma mark 自定义方法
//快捷创建同类型Label
- (UILabel *)createIndexLabel
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//计算数字占据宽度 高度
- (CGSize)countSizeWithText:(NSString *)text font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelsize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return labelsize;
    
}

@end
