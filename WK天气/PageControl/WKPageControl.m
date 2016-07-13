//
//  WKPageControl.m
//  WK天气
//
//  Created by qitian on 16/7/5.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKPageControl.h"
#import "WKCircle.h"

@interface WKPageControl ()

@property(nonatomic, strong) WKLine *line;
@property(nonatomic, strong) WKCircle *circle;

@end

@implementation WKPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.layer addSublayer:self.line];
    [self.layer insertSublayer:self.circle above:self.line];

    [self.line setNeedsDisplay];
}

- (WKLine *)line {
    if (!_line) {
        _line = [[WKLine alloc] init];
        _line.frame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _line.pageCount = self.pageCount;
        _line.selectedPage = 0;
        _line.unSelectedColor = [UIColor grayColor];
        _line.selectedColor =[UIColor redColor];
        _line.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return _line;
}

- (WKCircle *)circle {
    if (!_circle) {
        _circle = [WKCircle layer];
        _circle.indicatorColor = self.selectedColor;
        _circle.frame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _circle.indicatorSize = self.indicatorSize;
        _circle.contentsScale = [UIScreen mainScreen].scale;
    }
    [_circle animateIndicatorWithPage:self.selectedPage andIndicator:self];
    return _circle;
}

- (void)setSelectedPage:(NSInteger)selectedPage
{
    _selectedPage = selectedPage;
    [self.line animateSelectedLineToNewIndex:selectedPage];

    
    [_circle animateIndicatorWithPage:selectedPage andIndicator:self];

}


- (WKLine *)pageControlLine {
    return self.line;
}

@end
