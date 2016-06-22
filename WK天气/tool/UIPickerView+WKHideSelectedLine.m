//
//  UIPickerView+WKHideSelectedLine.m
//  WK天气
//
//  Created by qitian on 16/6/22.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "UIPickerView+WKHideSelectedLine.h"
#import <objc/runtime.h>
@implementation UIPickerView (WKHideSelectedLine)

- (void)WKHiddenSelectLine
{
    if (!self.selectedLineHidden)//该方法会被多次调用，加一个标示让它只调用一次
    {
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.height < 1)
            {
                obj.backgroundColor = [UIColor clearColor];
            }
        }];

    }
    self.selectedLineHidden = YES;
}
- (BOOL)selectedLineHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setSelectedLineHidden:(BOOL)selectedLineHidden
{
    objc_setAssociatedObject(self, @selector(selectedLineHidden), @(selectedLineHidden), OBJC_ASSOCIATION_ASSIGN);
}



@end
