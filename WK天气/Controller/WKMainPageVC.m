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

@interface WKMainPageVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) CAGradientLayer *colorLayer;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) NSMutableArray <WKWeatherView *>* weatherViews;

@property (nonatomic, strong) NSArray * citys;
@property (nonatomic, strong) NSArray <WKWeatherModel *>* models;

@property (nonatomic, assign) NSUInteger presentIndex;
@end


@implementation WKMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    ;


    
    [self setGradient];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 30 - 20)];
    [self.view addSubview:_scrollView];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _weatherViews = [NSMutableArray arrayWithCapacity:3];
    _models = [NSMutableArray array];

    

    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateRefresh) name:notificationName object:nil];
    
}

- (void)dateRefresh
{
    self.models = [[WKUserInfomation shardUsrInfomation].city_models allValues];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self dateRefresh];
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

- (void)showCityWeatherWithIndex:(NSUInteger)index
{
    _presentIndex = index;
    
    NSUInteger left = index == 0 ? _models.count - 1 : index - 1;
    NSUInteger right = index == _models.count - 1 ? 0 : index + 1;
    NSArray * numbers = @[@(left),@(index),@(right)];
    for (WKWeatherView * view in _weatherViews) {
        NSUInteger curIndex = [_weatherViews indexOfObject:view];
        NSUInteger currIndex = [numbers[curIndex] integerValue];
        view.model = _models[currIndex];
    }
    
}

- (void)setModels:(NSArray<WKWeatherModel *> *)models
{
    
    _models = models;
    if (_models.count > 0) {
        [self showCityWeatherWithIndex:0];
    }
}

- (void)showAlertVCWithCityName:(NSString *)cityName
{
//    if (cityName.length <= 0 || [cityName isEqualToString:_cityName]) {
//        NSLog(@"出问题了");
//        return;
//    }
    
    NSString * msg = [NSString stringWithFormat:@"检测到您现在位于【%@】,是否切换至该城市？",cityName];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

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
- (void)btnClick
{
    //进入选择页面
    WKCityListVC * vc = [[WKCityListVC alloc] init];
    
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
    

    
    [self showCityWeatherWithIndex:index];
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        return;
    }
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
