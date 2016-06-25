//
//  WKDegreesModelView.m
//  WK天气
//
//  Created by qitian on 16/6/24.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKDegreesModelView.h"

@interface WKDegreesModelView ()

@property (weak, nonatomic) IBOutlet UILabel *sLabel;//摄氏度
@property (weak, nonatomic) IBOutlet UILabel *hLabel;//华氏度


@end


@implementation WKDegreesModelView


+ (instancetype)viewFromNIB
{
    WKDegreesModelView * view = [[[NSBundle mainBundle]loadNibNamed:@"WKDegreesModelView" owner:nil options:nil]firstObject];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeModel)];
    [self addGestureRecognizer:tap];
}

- (void)changeModel
{
    //默认摄氏度
    static NSUInteger i = 1;
    _sLabel.textColor = i % 2 == 0? [UIColor lightTextColor] : [UIColor whiteColor];
    _hLabel.textColor = !(i % 2 == 0) ? [UIColor lightTextColor] : [UIColor whiteColor];
    if (_block) {
        _block(i%2);
    }
    
    i++;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
