//
//  WKCityIndexViewController.m
//  WK天气
//
//  Created by qitian on 16/6/21.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKCityIndexViewController.h"
#import "ViewController.h"
#import "WKNavView.h"
#import "UIPickerView+WKHideSelectedLine.h"
#import "WKEffectLabel.h"

static NSUInteger presentRow = 0;


@interface WKCityIndexViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, strong) NSArray * provinces;
@property (nonatomic, strong) NSArray<NSArray *> * citys;


@end

@implementation WKCityIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //获得 省市数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ProvinecesData" ofType:@"plist"];
    NSArray * arearArray=[NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray * provinceArray = [NSMutableArray array];
    NSMutableArray * cityArray = [NSMutableArray array];
    
    for (NSDictionary* dict in arearArray) {
        [provinceArray addObject:[dict objectForKey:@"ProvinceName"]];
        NSArray* cityarray=[dict objectForKey:@"cities"];
        NSMutableArray * temp = [NSMutableArray array];
        for (NSDictionary* dict in cityarray) {
            NSString* city=[dict objectForKey:@"CityName"];
            [temp addObject:city];
        }
        [cityArray addObject:temp];
    }
    
    _provinces = [provinceArray copy];
    _citys = [cityArray copy];
    
    //初始化tableview
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionIndexColor = UIColorFromRGB(0x4595e5);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    WKNavView * navV = [WKNavView navViewWithModel:WKNavViewModel_Normal];
    [navV setTitle:@"选择城市" forNavViewModel:WKNavViewModel_Normal];
    [navV setTitle:@"返回" forNavViewModel:WKNavViewModel_Normal toBtnWithDirection:WKLeft];
    [self.view addSubview:navV];
    navV.wkNVDelegate = self;
    
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (SCREEN_HEIGHT - 200)/2.0, 60, 200)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = NO;
    [self.view addSubview:_pickerView];


}

- (void)viewDidAppear:(BOOL)animated
{
    [self pickerViewAnimChangeWithRow:0];
}

#pragma mark UIPickerViewDelegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _provinces.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _provinces[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    WKEffectLabel * label = nil;
    if ([view isKindOfClass:[WKEffectLabel class]]) {
        label = (WKEffectLabel *)view;
        
        [label stopAnim];
    }
    else
    {
        label = [[WKEffectLabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.widthS, 18)];
        label.textColor = UIColorFromRGB(0x4595e5);
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = _provinces[row];
    //隐藏pickerview的选择线
    [pickerView WKHiddenSelectLine];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [self pickerViewAnimChangeWithRow:row];
    //和tableview对应 让tableware滚动到 指定行
    [_tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:row]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark 自定义pickview方法
- (void)pickerViewAnimChangeWithRow:(NSUInteger)row
{
    //去掉之前选中上的动画
    [(WKEffectLabel *)[_pickerView viewForRow:presentRow forComponent:0] stopAnim];
    
    WKEffectLabel * label = (WKEffectLabel *)[_pickerView viewForRow:row forComponent:0];
    [label startAnim];
    
    presentRow = row;
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    //偏移量可以+一个10 这样可以杜绝一些 不太好的情况
    CGPoint offset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + 8);
    
    
    NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:offset];
    [_pickerView selectRow:indexPath.section inComponent:0 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pickerViewAnimChangeWithRow:indexPath.section];
    });

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //减速会调用上一个方法
    if (decelerate) {
        return;
    }
    
    [self scrollViewDidEndDecelerating:scrollView];
    
}
#pragma mark UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _provinces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _citys[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _citys[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = UIColorFromRGB(0x4595e5);

    return cell;
}

#pragma  mark UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController * vc = (ViewController *)self.presentingViewController;
    
    vc.cityName = _citys[indexPath.section][indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = _provinces[section];
    label.textColor = UIColorFromRGB(0x4595e5);

    [view addSubview:label];
    view.backgroundColor = UIColorFromRGB(0xeeeeee);
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 白色状态栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark WKNavViewDelegate methods
- (void)leftBtnClick:(UIButton *)btn model:(WKNavViewModel)model
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
