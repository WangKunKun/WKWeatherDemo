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

@interface WKCityIndexViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, strong) NSArray * provinces;
@property (nonatomic, strong) NSArray<NSArray *> * citys;

@property (nonatomic, strong) NSMutableArray<NSString *> * sectionRects;

@end

@implementation WKCityIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sectionRects = [NSMutableArray array];
    
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
    
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    for (NSUInteger i = 0; i < _provinces.count; i ++) {
         [_sectionRects addObject:NSStringFromCGRect([_tableView rectForSection:i])];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGPoint point ;
    [change[@"new"] getValue:&point];
    for (NSUInteger i = 0 ; i < _sectionRects.count; i ++) {
        
        NSString * str = _sectionRects[i];
        CGRect temp = CGRectFromString(str);
        if(CGRectContainsPoint(temp, point))
        {
            [_pickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
    
}

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
    WKEffectLabel * label = [[WKEffectLabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.widthS, 18)];
    label.textColor = UIColorFromRGB(0x4595e5);
    label.font = [UIFont systemFontOfSize:13];
    label.text = _provinces[row];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [pickerView WKHiddenSelectLine];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    static NSUInteger presentRow = 0;
    [(WKEffectLabel *)[pickerView viewForRow:presentRow forComponent:component] stopAnim];
    
    
    WKEffectLabel * label = (WKEffectLabel *)[pickerView viewForRow:row forComponent:component];
    [label startAnim];
    presentRow = row;
    
    [_tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:row]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
}




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
    return cell;
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
    [view addSubview:label];
    view.backgroundColor = UIColorFromRGB(0xeeeeee);
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController * vc = (ViewController *)self.presentingViewController;
    
    vc.cityName = _citys[indexPath.section][indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftBtnClick:(UIButton *)btn model:(WKNavViewModel)model
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
