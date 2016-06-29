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

@interface WKBriefWeatherVC ()

@property (nonatomic, strong)  WKTopView * topView;

@end

@implementation WKBriefWeatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _topView = [WKTopView viewFromNIB];
    _topView.originS = CGPointMake(0, 0);
    [self.view addSubview:_topView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    self.topView.backgroundColor = [UIColor brownColor] ;
    [WKWeatherManager getWeatherWithCityName:_cityName block:^(WKWeatherModel * model, NSString * cn) {
        if (model) {
            [_topView setInterFaceWithModel:model];
        }
    }];
    
}

- (void)tapClick
{
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
