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
#import "UIViewExt.h"
#import "WKWeatherCell.h"
#import "WKWeatherModel.h"


static NSString * reuseID = @"WKWeatherCell";

//宽高
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//颜色
#define RGB(_R,_G,_B,_A) [UIColor colorWithRed:_R/255.0f green:_G/255.0f blue:_B/255.0f alpha:_A]

//16进制的颜色配置
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define   DEGREES(degrees)  ((M_PI * (degrees))/ 180.f)


@interface ViewController ()<WKTimerHolderDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CAGradientLayer *colorLayer;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong) WKWeatherModel * model;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setGradient];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(_topView.heightS, 0, 0, 0);
    [_tableView addSubview:_topView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:@"WKWeatherCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    
    _topView.widthS = SCREEN_WIDTH;
    _topView.originS = CGPointMake(0, -_topView.heightS);
    _topView.backgroundColor = [UIColor clearColor];
    
    
    [WKWeatherManager getWeatherWithCityName:@"成都" block:^(NSDictionary * dict){
        _model = [WKWeatherModel createWeatherModelWithDict:dict[@"data"]];
        [_tableView reloadData];
        
    }];
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.905 alpha:1.000];
    

    
    UILabel * label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSString * info = @"今天：现在局部多云。最高气温32度。今晚大部多云，最低气温23度。";
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
{
    
    NSString * info = @"今天：现在局部多云。最高气温32度。今晚大部多云，最低气温23度。";
    return [self countSizeWithText:info font:[UIFont systemFontOfSize:15]].height + 10;
    
}



- (CGSize)countSizeWithText:(NSString *)text font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelsize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return labelsize;

}

- (void)onWKTimerFired:(WKTimerHolder *)timerHolder
{
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"locations"];
    fadeAnim.fromValue = @[@(-0.2), @(-0.1), @(0)];
    fadeAnim.toValue   = @[@(1.0), @(1.1), @(1.2)];
    fadeAnim.duration  = 1.5;
    [_colorLayer addAnimation:fadeAnim forKey:nil];
}
//动画 主要是mask属性 6666
- (void)test
{
    self.view.backgroundColor = [UIColor blackColor];
    
    _colorLayer = [CAGradientLayer layer];
    _colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    _colorLayer.frame    = (CGRect){CGPointZero, CGSizeMake(200, 200)};
    _colorLayer.position = self.view.center;
    [self.view.layer addSublayer:_colorLayer];
    
    // 颜色分配
    _colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                          (__bridge id)[UIColor whiteColor].CGColor,
                          (__bridge id)[UIColor redColor].CGColor];
    _colorLayer.locations  = @[@(-0.2), @(-0.1), @(0)];
    
    // 起始点
    _colorLayer.startPoint = CGPointMake(0, 0);
    
    // 结束点
    _colorLayer.endPoint   = CGPointMake(1, 0);
    
    CAShapeLayer *circle = [self LayerWithCircleCenter:CGPointMake(102, 100)
                                                              radius:80
                                                          startAngle:DEGREES(0)
                                                            endAngle:DEGREES(360)
                                                           clockwise:YES
                                                     lineDashPattern:nil];
    circle.strokeColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:circle];
    circle.strokeEnd = 1.f;
    _colorLayer.mask = circle;
    
    WKTimerHolder * timeHolder = [[WKTimerHolder alloc] init];
    [timeHolder startTimer:1.0 repeats:YES delegate:self];
}

- (CAShapeLayer *)LayerWithCircleCenter:(CGPoint)point
                                 radius:(CGFloat)radius
                             startAngle:(CGFloat)startAngle
                               endAngle:(CGFloat)endAngle
                              clockwise:(BOOL)clockwise
                        lineDashPattern:(NSArray *)lineDashPattern
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 贝塞尔曲线(创建一个圆)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0)
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:clockwise];
    
    // 获取path
    layer.path = path.CGPath;
    layer.position = point;
    
    // 设置填充颜色为透明
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 获取曲线分段的方式
    if (lineDashPattern)
    {
        layer.lineDashPattern = lineDashPattern;
    }
    
    return layer;
}

- (void)setGradient
{
    CAGradientLayer *_colorLayer = [CAGradientLayer layer];
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
