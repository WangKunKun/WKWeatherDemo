//
//  WKWeatherBriefView.m
//  WK天气
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKWeatherBriefView.h"
#import "WKBriefCell.h"
static NSUInteger tableViewWidth = 250;

@interface WKWeatherBriefView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray<WKBriefModel *> * datasource;
@end

@implementation WKWeatherBriefView


+ (instancetype)viewFromNIB
{
    WKWeatherBriefView * view = [[[NSBundle mainBundle]loadNibNamed:@"WKWeatherBriefView" owner:nil options:nil]firstObject];
    view.backgroundColor = [UIColor clearColor];
    [view setInterFace];
    return view;
}


- (void)awakeFromNib
{
    self.widthS = SCREEN_WIDTH;
    [self layoutIfNeeded];
}

- (void)setInterFace
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake((self.widthS - tableViewWidth) / 2,125, tableViewWidth, self.heightS - 125) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    

    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:@"WKBriefCell" bundle:nil] forCellReuseIdentifier:@"WKBriefCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKBriefCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"WKBriefCell" forIndexPath:indexPath];
    [cell setInterFaceWithModel:_datasource[indexPath.row]];
    return cell;
}

- (void)setModel:(WKWeatherModel *)model
{
    _model = model;
    //做处理
    _temperatureLabel.text = [NSString stringWithFormat:@"%lu°",(unsigned long)model.realtimeInfo.temperature];
    _weatherLabel.text =  model.realtimeInfo.weatherInfo;
    
    _indexLabel.text = model.indexInfo.dressIndex[0];
    [self creatDataSource];

}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)creatDataSource
{
    NSString * humStr = [NSString stringWithFormat:@"%lu\%",(unsigned long)_model.realtimeInfo.humidity];
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString * hourStr = [formatter stringFromDate:date];
    
    BOOL flag = [hourStr integerValue] > 7 && [hourStr integerValue] < 19;
    
//    NSString * windDir = flag ? _model.weatherDayInfos[0].day[3] : _model.weatherDayInfos[0].night[3];
    NSString * windPow = flag ? _model.weatherDayInfos[0].day[4] : _model.weatherDayInfos[0].night[4];
    
    NSString * windStr = [NSString stringWithFormat:@"%@ %@",_model.realtimeInfo.windDirect,windPow];
    NSString * polluteStr = _model.indexInfo.polluteIndex[0];
    NSString * rayStr = _model.indexInfo.rayIndex[0];
    
    WKBriefModel * bm =[WKBriefModel createModelWithTitle:@"湿度" detail:humStr];
    [self.datasource addObject:bm];
    bm =[WKBriefModel createModelWithTitle:@"风" detail:windStr];
    [self.datasource addObject:bm];
    
    bm =[WKBriefModel createModelWithTitle:@"污染" detail:polluteStr];
    [self.datasource addObject:bm];
    
    bm =[WKBriefModel createModelWithTitle:@"紫外线" detail:rayStr];
    [self.datasource addObject:bm];
    
    
    //加载数据
    NSLog(@"%@",_tableView);
    NSLog(@"%@",_datasource);
    
    [self.tableView reloadData];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
