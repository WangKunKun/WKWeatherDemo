//
//  WKBriefWeatherVC.m
//  WK天气
//
//  Created by qitian on 16/6/29.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKBriefWeatherVC.h"
#import "WKTopView.h"
#import "WKWeatherManager.h"
#import "WKWeatherBriefView.h"
#import "WKLoadingView.h"

@interface WKBriefWeatherVC ()

@property (nonatomic, assign) BOOL isSave;

@property (nonatomic, strong)  WKWeatherBriefView * briefView;

@end

@implementation WKBriefWeatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _briefView = [WKWeatherBriefView viewFromNIB];
    _briefView.originS = CGPointMake(0, 0);
    [self.view addSubview:_briefView];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor brownColor] ;
    
    WKModelBaseVC * vc =  (WKModelBaseVC *)self.presentingViewController;
    
    
    [WKLoadingView showWithView:self.view center:CGPointMake(self.view.widthS / 2.0, vc.am.toViewHeight / 2.0)];
    [WKWeatherManager getWeatherWithCityName:_cityName block:^(WKWeatherModel * model, NSString * cn) {
        [WKLoadingView hideWithView:self.view];
        if (model) {
            _briefView.model = model;
        }
    }];
    
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, 60, 60);
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    closeBtn.tag = 100;
    
    UIButton * collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 60);
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];


    [self.view addSubview:collectBtn];
    collectBtn.tag = 101;
    [closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag - 100) {
        case 0:
            //关闭
            [self tapClick];
            break;
        case 1:
            //收藏
            btn.selected = !btn.selected;
            _isSave = btn.selected;
            break;
        default:
            break;
    }
}

- (void)tapClick
{
    
    if (_isSave) {
        [WKUserInfomation setCityName:_cityName];
        //存储
        [[WKUserInfomation shardUsrInfomation] wkSetObject:_briefView.model forKey:_cityName];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
