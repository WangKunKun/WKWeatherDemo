//
//  WKPageControl.h
//  WK天气
//
//  Created by qitian on 16/7/5.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKLine.h"

@interface WKPageControl : UIView

@property(nonatomic, assign) NSInteger pageCount;


@property(nonatomic, assign) NSInteger selectedPage;

@property(nonatomic, strong) UIColor *unSelectedColor;

@property(nonatomic, strong) UIColor *selectedColor;


- (void)animateToIndex:(NSInteger)index;

//回调
@property(nonatomic, copy) void (^didSelectIndexBlock)(NSInteger index);
@end
