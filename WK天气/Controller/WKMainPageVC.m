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
#import "WKAnimatorManager.h"
#import "WKBriefWeatherVC.h"

@interface WKMainPageVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) CAGradientLayer *colorLayer;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) NSMutableArray <WKWeatherView *>* weatherViews;

@property (nonatomic, strong) NSArray * citys;
@property (nonatomic, strong) NSArray <WKWeatherModel *>* models;


@property (nonatomic, strong) WKAnimatorManager * am;
@end


@implementation WKMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.



    
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
    
}

- (void)dateRefresh
{
    self.models = [[WKUserInfomation shardUsrInfomation] allValues];
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidAppear:(BOOL)animated
{
    [self showAlertVCWithCityName:@"成都市"];
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


//需要写到appdelegate里
- (void)showAlertVCWithCityName:(NSString *)cityName
{

    
    
    
    NSArray * citys = [[WKUserInfomation shardUsrInfomation] allKeys];
    
    BOOL flag = NO;
    NSUInteger index = 0;
    for (NSString * str in citys) {
        if ([str isEqualToString:cityName]) {
            flag = YES;
            index = [citys indexOfObject:str];
            break;
        }
    }
    
    NSString * title = [NSString stringWithFormat:@"您现在正位于【%@】",cityName];
    
    WKAlertView * av =  [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring noticStyle:WKAlertViewNoticStyleFace title:title detail:@"是否需要查看该城市天气？" canleButtonTitle:@"不用" okButtonTitle:@"好的" callBlock:^(MyWindowClick buttonIndex) {
        if (buttonIndex == 0) {
            if (!flag) {
                //新界面
                WKBriefWeatherVC * vc = [[WKBriefWeatherVC alloc] init];
                _am = [[WKAnimatorManager alloc] init];
                _am.style = WKAnimatorStyle_WindowedModel;
                _am.toViewHeight = 280;
                vc.cityName = cityName;
                vc.transitioningDelegate = _am;
                vc.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:vc animated:YES completion:nil];
            }
            else
            {
                self.presentIndex = index;
            }
        }
    }];
    
    [av show];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)btnClick
{
    //进入选择页面
    WKCityListVC * vc = [[WKCityListVC alloc] init];
    _am = [[WKAnimatorManager alloc] init];
    _am.style = WKAnimatorStyle_FilpToon;
    vc.transitioningDelegate = _am;
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

@end
