//
//  WKMainPageVC.m
//  WK天气
//
//  Created by qitian on 16/6/23.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKMainPageVC.h"
#import "WKWeatherView.h"
#import "WKWeatherManager.h"
#import "WKMapManager.h"
#import "WKCityListVC.h"
#import "WKBriefWeatherVC.h"

@interface WKMainPageVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) CAGradientLayer *colorLayer;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) NSMutableArray <WKWeatherView *>* weatherViews;

@property (nonatomic, strong) NSArray * citys;
@property (nonatomic, strong) NSArray <WKWeatherModel *>* models;


@end


@implementation WKMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //初始值 先设置一下
    _presentIndex = 500;

    
    [self setGradient];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 30 - 20)];
    [self.view addSubview:_scrollView];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _weatherViews = [NSMutableArray arrayWithCapacity:3];

    

    
    UIView * bottom  = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
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
    [btn setTitle:@"列表" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self setInterFace];
    
    self.models = [[WKUserInfomation shardUsrInfomation] allValues];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateRefresh) name:notificationName object:nil];
    
    [self my];
    
}

- (void)dateRefresh
{
    self.models = [[WKUserInfomation shardUsrInfomation] allValues];
}

- (void)viewWillAppear:(BOOL)animated
{

}


- (void)setInterFace
{
    static CGFloat startX = 0;
    
    for (NSUInteger i = 0; i < 3; i ++) {
        WKWeatherView * view = [[WKWeatherView alloc] initWithFrame:CGRectMake(startX, 0, _scrollView.widthS, _scrollView.heightS)];
        [_scrollView addSubview:view];
        [_weatherViews addObject:view];
        startX += SCREEN_WIDTH;
    }
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, _scrollView.heightS);
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH , 0)];
}



- (void)setModels:(NSArray<WKWeatherModel *> *)models
{
    
    _models = models;
    if (_models.count > 0) {
        self.presentIndex = 0;
    }
    else
    {
        for (WKWeatherView * view in _weatherViews) {
            view.model = nil;
        }
    }
}




- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)btnClick
{
    //进入选择页面
    WKCityListVC * vc = [[WKCityListVC alloc] init];
    self.am = [[WKAnimatorManager alloc] init];
    self.am.style = WKAnimatorStyle_FilpToon;
    vc.transitioningDelegate = self.am;
    vc.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//背景渐变
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



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    if (page == 1) {
        return;
    }
    NSUInteger index = 0;
    page < 1 ? ({
        if (_presentIndex == 0) {
            index = _models.count - 1;
        }
        else
            index = _presentIndex - 1;
    }) : ({
        if (_presentIndex == _models.count - 1) {
            index = 0;
        }
        else
        {
            index = _presentIndex + 1;
        }
    });
    

    
    self.presentIndex = index;
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
}

- (void)setPresentIndex:(NSUInteger)presentIndex
{
    
    if (_presentIndex == presentIndex) {
        return;
    }
    
    _presentIndex = presentIndex;
    if (_models.count > 0) {
        NSUInteger left = presentIndex == 0 ? _models.count - 1 : presentIndex - 1;
        NSUInteger right = presentIndex == _models.count - 1 ? 0 : presentIndex + 1;
        NSArray * numbers = @[@(left),@(presentIndex),@(right)];
        for (WKWeatherView * view in _weatherViews) {
            NSUInteger curIndex = [_weatherViews indexOfObject:view];
            NSUInteger currIndex = [numbers[curIndex] integerValue];
            view.model = _models[currIndex];
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        return;
    }
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)my
{
    CGRect frame = self.view.frame;
    
    CAEmitterLayer * layer = [CAEmitterLayer layer];
    layer.frame = frame;
    layer.emitterShape = kCAEmitterLayerLine;
//    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.emitterPosition = CGPointMake(frame.size.width / 2.0, -50);
    layer.emitterSize = frame.size;
    layer.emitterMode = kCAEmitterLayerSurface;
    CAEmitterCell * cell =  [CAEmitterCell new];
    //cell 内容
    cell.contents = (id)[UIImage imageWithColor:[UIColor lightTextColor] size:CGSizeMake(1, 5)].CGImage;
    //
    cell.birthRate = 3000;
    cell.lifetime =3;//存活时间 = cell.lifetime * layer.lifeTime;
    cell.lifetimeRange = 10.0;
    cell.yAcceleration = 200.0;  //给Y方向一个加速度
    //    cell.xAcceleration = 20.0; //x方向一个加速度
    cell.velocity = 200; //初始速度
    //    cell.emissionLongitude = M_PI_2; //向左
    //    cell.velocityRange = 200.0;   //随机速度 -200+20 --- 200+20
    //    cell.emissionRange = M_PI_2; //随机方向 -pi/2 --- pi/2
    //    cell.color = [UIColor redColor].CGColor; //指定颜色
    cell.redRange = 0.3;
    cell.greenRange = 0.3;
    cell.blueRange = 0.3 ; //三个随机颜色
    //    cell.scale =
    //    cell.scaleRange = 0.8 ; //0 - 1.6
    //    cell.scaleSpeed = -0.15 ; //逐渐变小
    cell.alphaRange = 0.2;   //随机透明度
    cell.alphaSpeed = -0.15;
    
    
    layer.emitterCells = @[cell];
    [self.view.layer addSublayer:layer];
}

@end
