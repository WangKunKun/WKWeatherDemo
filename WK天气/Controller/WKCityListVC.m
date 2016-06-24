//
//  WKCityListVC.m
//  WK天气
//
//  Created by qitian on 16/6/24.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKCityListVC.h"
#import "WKNavView.h"
#import "WKListCityCell.h"
#import "WKCityIndexViewController.h"
#import "WKDegreesModelView.h"



@interface WKCityListVC ()<UITableViewDelegate,UITableViewDataSource,WKNavViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) BOOL flag;
@end

@implementation WKCityListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGradient];

    // Do any additional setup after loading the view.
    WKNavView * nav = [WKNavView navViewWithModel:WKNavViewModel_Normal];
    [self.view addSubview:nav];
    [nav setTitle:@"返回" forNavViewModel:WKNavViewModel_Normal toBtnWithDirection:WKLeft];
    [nav setTitle:@"收藏列表" forNavViewModel:WKNavViewModel_Normal];
    nav.wkNVDelegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //xib cell 注册方法
    [_tableView registerNib:[UINib nibWithNibName:@"WKListCityCell" bundle:nil] forCellReuseIdentifier:@"WKListCityCell"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WKListCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WKListCityCell"];
    cell.model= _dataSource[indexPath.row];
    cell.flag = _flag;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"top-添加"] forState:UIControlStateNormal];
    button.frame = CGRectMake(SCREEN_WIDTH - 25 -10 , (view.heightS - 25) / 2.0f, 25, 25);
    [view addSubview:button];
    
    WKDegreesModelView * dmView = [WKDegreesModelView viewFromNIB];
    dmView.originS = CGPointMake(5, (view.heightS - dmView.heightS) / 2.0f);
    [view addSubview:dmView];
    [dmView setBlock:^(BOOL flag){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.flag = flag;
        });
    }];
    
    return view;
}

- (void)setFlag:(BOOL)flag
{
    _flag = flag;
    [_tableView reloadData];
}

//- (void)changeModel:(NSNotification *)notification
//{
//    NSInteger presentModel = [notification.userInfo[@"model"] integerValue];
//    presentModel % 2;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)leftBtnClick:(UIButton *)btn model:(WKNavViewModel)model
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//背景渐变
- (void)setGradient
{
    CAGradientLayer * colorLayer = [CAGradientLayer layer];
    colorLayer.frame    = self.view.frame;
    [self.view.layer addSublayer:colorLayer];
    // 颜色分配
    colorLayer.colors = @[(__bridge id)UIColorFromRGB(0x4595e5).CGColor,
                           (__bridge id)[UIColor colorWithRed:0.000 green:0.759 blue:1.000 alpha:1.000].CGColor];
    // 颜色分割线
    colorLayer.locations  = @[@(0.5)];
    // 起始点
    colorLayer.startPoint = CGPointMake(0, 0);
    // 结束点
    colorLayer.endPoint   = CGPointMake(0, 1);
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
