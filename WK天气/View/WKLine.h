//
//  WKLine.h
//  WK天气
//
//  Created by qitian on 16/7/5.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface WKLine : CALayer

@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat ballDiameter;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) UIColor * unSelectedColor;
@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, assign) NSUInteger selectedPage;

@end
