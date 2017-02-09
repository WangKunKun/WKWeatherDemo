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
#import "WKPageControl.h"




@interface WKMainPageVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) CAGradientLayer *colorLayer;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) NSMutableArray <WKWeatherView *>* weatherViews;

@property (nonatomic, strong) NSArray * citys;
@property (nonatomic, strong) NSArray <WKWeatherModel *>* models;

@property (nonatomic, strong) CAEmitterLayer * emitterLayer;

@property (nonatomic, strong) WKPageControl * pc;
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

    
//    _pc = [[WKPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    _pc.center = CGPointMake(SCREEN_WIDTH/2.0, bottom.heightS / 2.0);
//    _pc.pageCount = 6;
//    _pc.selectedPage = 0;
//    _pc.pageControlLine.ballDiameter = 6;
//    _pc.pageControlLine.lineHeight = 1.5f;
//    _pc.bindScrollView = _scrollView;
//    _pc.indicatorSize = 10;
//    _pc.selectedColor = [UIColor blackColor];
//    _pc.unSelectedColor = [UIColor redColor];
//    _pc.backgroundColor = [UIColor redColor];
//    [bottom addSubview:_pc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateRefresh) name:notificationName object:nil];
    

    
//    [self.view.layer addSublayer:[WKParticleManager createParticleEffectWithStyle:WKParticleStyle_Sunshine]];
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
        
        //特殊处理 如果为1 则所有数据更改为同一个model
        if (_models.count == 1) {
            for (WKWeatherView * view in _weatherViews) {
                view.model = _models[0];
            }
        }
        self.presentIndex = 0;
    }
    else
    {
        
        [_emitterLayer removeFromSuperlayer];
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
//    //进入选择页面
    WKCityListVC * vc = [[WKCityListVC alloc] init];
    self.am = [[WKAnimatorManager alloc] init];
    self.am.style = WKAnimatorStyle_FilpToon;
    vc.transitioningDelegate = self.am;
    vc.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:vc animated:YES completion:nil];
    
//    if (self.pc.selectedPage < self.pc.pageCount - 1) {
//        self.pc.selectedPage += 1;
//    }
//    else
//    {
//        self.pc.selectedPage = 0;
//
//    }
    
//    self.pc.selectedPage += (self.pc.selectedPage < self.pc.pageCount ? 1 : -1);
    
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
    
    if(_emitterLayer == nil && _models[presentIndex] != nil)
    {
        NSUInteger weatherType = _models[presentIndex].realtimeInfo.weatherType;
        WKParticleStyle style = [WKParticleManager weatherTypeToParticleStyle:weatherType];
        _emitterLayer = [WKParticleManager createParticleEffectWithStyle:style];
        [self.view.layer addSublayer:_emitterLayer];
    }
    
    if (_presentIndex == presentIndex) {
        return;
    }
    
    _presentIndex = presentIndex;
    //之前的天气类型
    NSUInteger presentWeatherType = _weatherViews[1].model.realtimeInfo.weatherType;
    
    //重新计算当前需要显示的城市数据  滚动轮播需要
    if (_models.count > 0) {
        NSUInteger left = presentIndex == 0 ? _models.count - 1 : presentIndex - 1;
        NSUInteger right = presentIndex == _models.count - 1 ? 0 : presentIndex + 1;
        NSArray * numbers = @[@(left),@(presentIndex),@(right)];
        
        
        for (WKWeatherView * view in _weatherViews) {
            NSUInteger curIndex = [_weatherViews indexOfObject:view];
            NSUInteger currIndex = [numbers[curIndex] integerValue];
            view.model = _models[currIndex];
        }
        //现在的天气类型
        NSUInteger weatherType = _models[presentIndex].realtimeInfo.weatherType;
        //不相等 则更换粒子效果展示
        if((weatherType != presentWeatherType))
        {
            [_emitterLayer removeFromSuperlayer];
            WKParticleStyle style = [WKParticleManager weatherTypeToParticleStyle:weatherType];
            _emitterLayer = [WKParticleManager createParticleEffectWithStyle:style];
            [self.view.layer addSublayer:_emitterLayer];
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


@end
