//
//  WKPageControl.m
//  WK天气
//
//  Created by qitian on 16/7/5.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKPageControl.h"

@interface WKPageControl ()

@property(nonatomic, strong) WKLine *line;


@end

@implementation WKPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (WKLine *)line {
    if (!_line) {
        _line = [WKLine layer];
        _line.frame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _line.pageCount = self.pageCount;
        _line.selectedPage = 0;
        _line.unSelectedColor = self.unSelectedColor;
        _line.selectedColor = self.selectedColor;
        _line.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return _line;
}

@end
