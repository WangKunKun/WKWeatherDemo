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
#import "WKMainPageVC.h"

static BOOL cellAniFlag = YES;//cell 动画标识

@interface WKCityListVC ()<UITableViewDelegate,UITableViewDataSource,WKNavViewDelegate>


@property (nonatomic, strong) NSMutableArray * dataSource;




@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) BOOL flag;

@property (nonatomic, strong) NSMutableArray * citys;

@property (strong, nonatomic) CAEmitterLayer * eLayer;



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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateRefresh) name:notificationName object:nil];
    
//    
//    _eLayer = [WKParticleManager createParticleEffectWithStyle:WKParticleStyle_Waiting + 1];
//    _eLayer.birthRate = 0.f;
//    [self.view.layer addSublayer:_eLayer];
}

- (void)dateRefresh
{
    //得到新数据
    _dataSource = [[[WKUserInfomation shardUsrInfomation] allValues] mutableCopy];
    _citys = [[[WKUserInfomation shardUsrInfomation] allKeys] mutableCopy];
    cellAniFlag = NO;
//    //刷新数据
    //延时执行 是因为主线程 可能正在执行返回当前界面的动画，此时刷新数据 会对动画造成卡帧的影响，影响用户体验
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });

    
//
//    //需要改回来
    //延时执行 是因为在刷新数据时不需要动画 但是在其他时候需要动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellAniFlag = YES;
    });
    

}

- (void)viewWillAppear:(BOOL)animated
{
    
    _citys = [[[WKUserInfomation shardUsrInfomation] allKeys] mutableCopy];
    _dataSource = [[[WKUserInfomation shardUsrInfomation] allValues] mutableCopy];
    cellAniFlag = YES;
    [_tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[WKUserInfomation shardUsrInfomation] wkRemoveObjectForKey:_citys[indexPath.row]];
        [_citys removeObjectAtIndex:indexPath.row];
        [_dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        tableView.editing = NO;
        
    }];
    
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!cellAniFlag) {
        return;
    }
    
    cell.originS = CGPointMake(cell.originS.x + SCREEN_WIDTH - 20, cell.originS.y);
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:0.7 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        cell.originS = CGPointMake(0, cell.originS.y);
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKListCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WKListCityCell"];
    cell.cityName = _citys[indexPath.row];
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
    [button addTarget:self action:@selector(gotoCityList:) forControlEvents:UIControlEventTouchUpInside];
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((WKMainPageVC *)self.presentingViewController).presentIndex = indexPath.row ;
    [self leftBtnClick:nil model:0];
}

- (void)gotoCityList:(UIButton *)btn
{
    UIView * sv = [btn superview];
    
    WKCityIndexViewController * vc = [[WKCityIndexViewController alloc] init];
    
    self.am = [[WKAnimatorManager alloc] init];
    self.am.style = WKAnimatorStyle_CircleSpread;
    self.am.circleFrame = CGRectMake(sv.widthS - btn.widthS, sv.originS.y + _tableView.topS, btn.widthS, btn.heightS);
    vc.transitioningDelegate = self.am;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setFlag:(BOOL)flag
{
    _flag = flag;
    for (WKListCityCell * cell in [_tableView visibleCells]) {
        cell.flag = flag;
    }
}





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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    
    
        CABasicAnimation *burst = [CABasicAnimation animationWithKeyPath:@"emitterCells.ring.birthRate"];
        burst.fromValue			= [NSNumber numberWithFloat: 125.0];	// short but intense burst
        burst.toValue			= [NSNumber numberWithFloat: 0.0];		// each birth creates 20 aditional cells!
        burst.duration			= 0.5;
        burst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
        [self.eLayer addAnimation:burst forKey:@"burst"];
    
        // Move to touch point
        [CATransaction begin];
        [CATransaction setDisableActions: YES];
        self.eLayer.emitterPosition	= touchPoint;
        [CATransaction commit];
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
