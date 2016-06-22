//
//  ViewController.m
//  WK天气
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "ViewController.h"
#import "WKWeatherManager.h"
#import "WKTimerHolder.h"
#import "WKWeatherCell.h"
#import "WKWeatherModel.h"
#import "WKMapManager.h"
#import "WKCityIndexViewController.h"
#import "NSString+WKNumberToChinese.h"

static NSString * reuseID = @"WKWeatherCell";




@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CAGradientLayer *colorLayer;


@property (nonatomic, strong) WKWeatherModel * model;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSString * todayWeatherInfo;

@property (strong, nonatomic) IBOutlet UIView *topView;
//TopView的控件
@property (weak, nonatomic) IBOutlet UILabel *topTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *topWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *topWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *topDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *topChineseDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *topDayTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNightTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *topCityNameLabel;

@end


//TODO : 省市区 通讯录模式选择。  下方做一个列表 可以点击
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setGradient];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , SCREEN_HEIGHT - 30 - 20) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(_topView.heightS, 0, 0, 0);
    [_tableView addSubview:_topView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //xib cell 注册方法 
    [_tableView registerNib:[UINib nibWithNibName:@"WKWeatherCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    self.cityName = @"成都";
    
    _topView.widthS = SCREEN_WIDTH;
    _topView.originS = CGPointMake(0, -_topView.heightS);
    _topView.backgroundColor = [UIColor clearColor];
    
    [[WKMapManager shardMapManager] startLocationWithBlock:^(NSString *name) {
        [self showAlertVCWithCityName:name];
    }];
    
    

    
    UIView * bottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.905 alpha:1.000];
    [bottom addSubview:topLine];
    
    [self.view addSubview:bottom];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottom addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottom);
        make.bottom.equalTo(bottom);
        make.right.equalTo(bottom);
        make.width.equalTo(@60);
    }];
    [btn setTitle:@"切换城市" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showAlertVCWithCityName:(NSString *)cityName
{
    if (cityName.length <= 0 ) {
        NSLog(@"出问题了");
        return;
    }
    
    NSString * msg = [NSString stringWithFormat:@"检测到您现在位于【%@】,您需要显示当前城市天气么？",cityName];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.cityName = cityName;
    }];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"不用" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    
    [alert addAction:ensureAction];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setCityName:(NSString *)cityName
{
    if ([cityName isEqualToString:_cityName]) {
        return;
    }
    
    _cityName = cityName;
    [WKWeatherManager getWeatherWithCityName:cityName block:^(NSDictionary * dict){
        self.model = [WKWeatherModel createWeatherModelWithDict:dict[@"data"]];
    }];
}

- (void)btnClick
{
//进入选择页面
    NSLog(@"进入选择页面");
    WKCityIndexViewController * vc = [[WKCityIndexViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)setModel:(WKWeatherModel *)model
{
    _model = model;

    _todayWeatherInfo = [NSString stringWithFormat:@"空气质量:  %@\n健康小贴士: %@",_model.pmInfo.pmQuality,_model.pmInfo.pmDes];
    
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
    _topDateLabel.text = [NSString stringWithFormat:@"国 %@",dateStr];
    
    
    _topChineseDateLabel.text = [NSString stringWithFormat:@"阴 %@",_model.weatherDayInfos[0].presentChineseData];
    
    
    _topWeekLabel.text =  [NSString stringWithFormat:@"星期%@",[NSString numberToChinese:@(_model.realtimeInfo.week)]];
    
    _topWeatherLabel.text = _model.realtimeInfo.weatherInfo;
    _topTemperatureLabel.text = [NSString stringWithFormat:@"%lu°",(unsigned long)_model.realtimeInfo.temperature];
    _topDayTemperatureLabel.text = [NSString stringWithFormat:@"%@",_model.weatherDayInfos[0].day[WKWeatherTemperature]];
    _topNightTemperatureLabel.text = [NSString stringWithFormat:@"%@",_model.weatherDayInfos[0].night[WKWeatherTemperature]];
    _topCityNameLabel.text = _model.realtimeInfo.cityName;

}

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
    
    WKWeatherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WKWeatherCell"];
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



- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
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

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSLog(@"%@",title);
    
    return index;
}

- (void)setGradient
{
    _colorLayer = [CAGradientLayer layer];
    _colorLayer.frame    = self.view.frame;
    [self.view.layer addSublayer:_colorLayer];
    // 颜色分配
    _colorLayer.colors = @[(__bridge id)UIColorFromRGB(0x4595e5).CGColor,
                          (__bridge id)[UIColor colorWithRed:0.000 green:0.759 blue:1.000 alpha:1.000].CGColor];
    // 颜色分割线
    _colorLayer.locations  = @[@(0.5)];
    // 起始点
    _colorLayer.startPoint = CGPointMake(0, 0);
    // 结束点
    _colorLayer.endPoint   = CGPointMake(0, 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
