//
//  WKNavView.h
//  WangKunKun出品
//
//  Created by MacBook on 16/4/28.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WKNavViewModel)
{
    
    WKNavViewModel_Normal = 0, //正常模式
    WKNavViewModel_Transparent,//透明模式
};

#define WKLeft  0
#define WKRight 1


#define WKVertical  0//水平
#define WKHorizontal 1//垂直
@protocol WKNavViewDelegate <NSObject>

@optional
- (void)leftBtnClick:(UIButton *)btn model:(WKNavViewModel)model;
- (void)rightBtnClick:(UIButton *)btn model:(WKNavViewModel)model;

@end

@interface WKNavView : UIView

//此时决定新建添加时，是透明模式 还是正常模式
+ (instancetype)navViewWithModel:(WKNavViewModel)model;

//点击代理
@property (nonatomic, assign) id<WKNavViewDelegate> wkNVDelegate;


//最小透明度 默认为0.2
@property (nonatomic, assign) CGFloat minimumAlpha;

//为按钮设置图片、文本、文本颜色
- (void)setImage:(UIImage *)image forNavViewModel:(WKNavViewModel)model toBtnWithDirection:(BOOL)direction;
- (void)setTitle:(NSString *)title forNavViewModel:(WKNavViewModel)model toBtnWithDirection:(BOOL)direction;
- (void)setTitleColor:(UIColor *)color forNavViewModel:(WKNavViewModel)model toBtnWithDirection:(BOOL)direction;
//为标题设置文本、文本颜色
- (void)setTitle:(NSString *)title forNavViewModel:(WKNavViewModel)model;
- (void)setTitleColor:(UIColor *)color forNavViewModel:(WKNavViewModel)model;
//设置被观察的scrollView 以及其临界值 以及其方向
- (void)setScrollView:(UIScrollView *)scrollView andMaxValue:(CGFloat)value toDirection:(BOOL)direction;

- (void)show:(BOOL)flag;

@end
