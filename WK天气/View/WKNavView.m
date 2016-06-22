//
//  WKNavView.m
//  WangKunKun出品
//
//  Created by WangKunKun on 16/4/28.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "WKNavView.h"
#import <objc/runtime.h>

#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



//诶 用按钮自带状态 会出幺蛾子，自己加属性保证万无一失
@interface UIButton (WKSelected)

@property (nonatomic, strong) NSString  * wk_selectTitle;
@property (nonatomic, strong) NSString  * wk_normalTitle;

@property (nonatomic, strong) UIColor  * wk_normalTitleColor;
@property (nonatomic, strong) UIColor  * wk_selectTitleColor;

@property (nonatomic, strong) UIImage * wk_normalImage;
@property (nonatomic, strong) UIImage * wk_selectImage;

@property (nonatomic, assign) BOOL wkSelected;

@end

@implementation UIButton (WKSelected)

- (void)setWk_normalImage:(UIImage *)wk_normalImage
{
    objc_setAssociatedObject(self, @selector(wk_normalImage), wk_normalImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (UIImage *)wk_normalImage
{
    return objc_getAssociatedObject(self, @selector(wk_normalImage));

}

- (void)setWk_selectImage:(UIImage *)wk_selectImage
{
    objc_setAssociatedObject(self, @selector(wk_selectImage), wk_selectImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)wk_selectImage
{
    return objc_getAssociatedObject(self, @selector(wk_selectImage));
}

- (void)setWk_normalTitleColor:(UIColor *)wk_normalTitleColor
{
    objc_setAssociatedObject(self, @selector(wk_normalTitleColor), wk_normalTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIColor *)wk_normalTitleColor
{
    return objc_getAssociatedObject(self, @selector(wk_normalTitleColor));
    
}

- (void)setWk_selectTitleColor:(UIColor *)wk_selectTitleColor
{
    objc_setAssociatedObject(self, @selector(wk_selectTitleColor), wk_selectTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wk_selectTitleColor
{
    return objc_getAssociatedObject(self, @selector(wk_selectTitleColor));
}

- (void)setWk_selectTitle:(NSString *)wk_selectTitle
{
    objc_setAssociatedObject(self, @selector(wk_selectTitle), wk_selectTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)wk_selectTitle
{
    return objc_getAssociatedObject(self, @selector(wk_selectTitle));
}

- (void)setWk_normalTitle:(NSString *)wk_normalTitle
{
    objc_setAssociatedObject(self, @selector(wk_normalTitle), wk_normalTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)wk_normalTitle
{
    return objc_getAssociatedObject(self, @selector(wk_normalTitle));
}

- (void)setWkSelected:(BOOL)wkSelected
{
    UIImage * image = wkSelected ? self.wk_selectImage : self.wk_normalImage;
    NSString * str = wkSelected ? self.wk_selectTitle : self.wk_normalTitle;
    UIColor * color = wkSelected ? self.wk_selectTitleColor : self.wk_normalTitleColor;
    
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:str forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    
    objc_setAssociatedObject(self, @selector(wkSelected), @(wkSelected), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)wkSelected
{
    return [objc_getAssociatedObject(self, @selector(wkSelected)) boolValue];
}


@end

//为标签添加属性 万无一失
@interface UILabel (WKSelected)

@property (nonatomic, strong) NSString  * wk_selectText;
@property (nonatomic, strong) NSString  * wk_normalText;

@property (nonatomic, strong) UIColor  * wk_normalColor;
@property (nonatomic, strong) UIColor  * wk_selectColor;

@property (nonatomic, assign) BOOL wkSelected;

@end

@implementation UILabel (WKSelected)

- (void)setWk_normalColor:(UIColor *)wk_normalColor
{
    objc_setAssociatedObject(self, @selector(wk_normalColor), wk_normalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (UIColor *)wk_normalColor
{
    return objc_getAssociatedObject(self, @selector(wk_normalColor));

}

- (void)setWk_selectColor:(UIColor *)wk_selectColor
{
    objc_setAssociatedObject(self, @selector(wk_selectColor), wk_selectColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wk_selectColor
{
    return objc_getAssociatedObject(self, @selector(wk_selectColor));
}

- (void)setWk_selectText:(NSString *)wk_selectText
{
    objc_setAssociatedObject(self, @selector(wk_selectText), wk_selectText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)wk_selectText
{
    return objc_getAssociatedObject(self, @selector(wk_selectText));
}

- (void)setWk_normalText:(NSString *)wk_normalText
{
    objc_setAssociatedObject(self, @selector(wk_normalText), wk_normalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)wk_normalText
{
    return objc_getAssociatedObject(self, @selector(wk_normalText));
}

- (void)setWkSelected:(BOOL)wkSelected
{
    
    self.text = wkSelected ? self.wk_selectText : self.wk_normalText;
    self.textColor = wkSelected ? self.wk_selectColor : self.wk_normalColor;
    objc_setAssociatedObject(self, @selector(wkSelected), @(wkSelected), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)wkSelected
{
    return [objc_getAssociatedObject(self, @selector(wkSelected)) boolValue];
}

@end


@interface WKNavView ()

//控件
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIButton *leftBtn;
@property (strong, nonatomic)  UIButton *rightBtn;

@property (strong, nonatomic)  UIView *backgroundView;


//滚动
@property (nonatomic, strong) UIScrollView * scrollView;
//临界值
@property (nonatomic, assign) CGFloat maxValue;
//有效方向
@property (nonatomic, assign) BOOL validDirection;
//当前模式
@property (assign, nonatomic) WKNavViewModel presentModel;
//初始化模式
@property (assign, nonatomic) WKNavViewModel initialModel;


@end

@implementation WKNavView




- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = UIColorFromRGB(0x4595e5);
        [self addSubview:_backgroundView];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 20, 80, 44);
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 8, 5, 10);
        _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(5, _leftBtn.imageView.frame.size.width + 8 + 5 , 5, 10);

        
        //设置内容靠左
        _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _leftBtn.imageView.contentMode = UIViewContentModeLeft;
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;


        [self addSubview:_leftBtn];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 20, 100, 44);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        //25写死不太好 将就 10 + 5 距离边距 15了~
        _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10 , 5, 10);
        _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10 + _rightBtn.imageView.frame.size.width + 5);
        
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _rightBtn.imageView.contentMode = UIViewContentModeRight;
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;



        [self addSubview:_rightBtn];
        
        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.bounds = CGRectMake(0, 0, 120, 44);
        _titleLabel.center = CGPointMake(self.center.x, 42);
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.wk_normalColor = [UIColor whiteColor];
        _titleLabel.wk_selectColor = [UIColor whiteColor];
        _titleLabel.wkSelected = NO;
        [self addSubview:_titleLabel];
        
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        [_titleLabel.layer addAnimation:transition forKey:nil];
        [_leftBtn.titleLabel.layer addAnimation:transition forKey:nil];
        [_leftBtn.imageView.layer addAnimation:transition forKey:nil];
        [_rightBtn.titleLabel.layer addAnimation:transition forKey:nil];
        [_rightBtn.imageView.layer addAnimation:transition forKey:nil];
        
    }
    return self;
}

- (void)awakeFromNib
{
    CGRect frame = self.frame;
    frame.size.width = SCREEN_WIDTH;
    self.frame = frame;
    [self layoutIfNeeded];
}





+ (instancetype)navViewWithModel:(WKNavViewModel)model
{
    WKNavView * view = [[WKNavView alloc] init] ;
    view.presentModel = model;
    view.initialModel = model;
    view.minimumAlpha = 0.2;
    if (model == WKNavViewModel_Transparent) {
        view.backgroundView.alpha = 0;
    }

    
    return view;
}

- (void)rightBtnClick:(UIButton *)sender {
    
    
    if (_wkNVDelegate && [_wkNVDelegate respondsToSelector:@selector(rightBtnClick:model:)]) {
        [_wkNVDelegate rightBtnClick:sender model:_presentModel];
    }
}


- (void)leftBtnClick:(UIButton *)sender {
    
    
    if ( _wkNVDelegate && [_wkNVDelegate respondsToSelector:@selector(leftBtnClick:model:)]) {
        [_wkNVDelegate leftBtnClick:sender model:_presentModel];
    }
}


- (void)setScrollView:(UIScrollView *)scrollView
{
    
//    if (nil != _scrollView) {
//        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
//    }
    _scrollView = scrollView;
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)setScrollView:(UIScrollView *)scrollView andMaxValue:(CGFloat)value toDirection:(BOOL)direction
{
    NSAssert(scrollView != nil, @"scrollView can't be nil");
    
    _validDirection = direction;
    self.scrollView = scrollView;
    _maxValue = value;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == nil) {

        static NSUInteger i = 0;
        if (i < 2) {
            i++;
            return;
        }
        CGPoint point ;
        [change[@"new"] getValue:&point];
        CGFloat presentValue = _validDirection == WKVertical ? point.x : point.y;
        CGFloat realMaxValue = _maxValue * (1 + _minimumAlpha);//保证最低透明度
//        NSLog(@"当前%.2lf",presentValue);
        if (presentValue <= _maxValue) {
            self.presentModel = _initialModel;
            
            CGFloat alpha = _initialModel == WKNavViewModel_Transparent ? (presentValue / realMaxValue) : 1 - (presentValue / realMaxValue);
            
            self.backgroundView.alpha = alpha;
        }
        else
        {
//            NSLog(@"临界值");
            //超过临界值状态取反
            self.presentModel = !_initialModel;

        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)show:(BOOL)flag
{
    CGFloat alpha = flag ? 1 : 0;
    if (flag) {
        self.hidden = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = alpha;
    } completion:^(BOOL finished) {
        if (finished && !flag) {
            self.hidden = YES;
        }
    }];
}

- (void)alphaChange:(CGFloat)scale
{
    self.alpha = scale;
}

- (void)setImage:(UIImage *)image forNavViewModel:(WKNavViewModel)model toBtnWithDirection:(BOOL)direction;
{
    //根据direction 决定是设置左右哪个按钮
    UIButton * tempBtn = direction ? _rightBtn : _leftBtn;
    if (model == _initialModel) {
        [tempBtn setImage:image forState:UIControlStateNormal];
    }
    
    switch (model) {
        case WKNavViewModel_Normal: {
            tempBtn.wk_normalImage = image;
            break;
        }
        case WKNavViewModel_Transparent: {
            tempBtn.wk_selectImage = image;
            break;
        }
    }
}

- (void)setTitle:(NSString *)title forNavViewModel:(WKNavViewModel)model toBtnWithDirection:(BOOL)direction;
{
    //根据direction 决定是设置左右哪个按钮
    UIButton * tempBtn = direction ? _rightBtn : _leftBtn;
    if (model == _initialModel) {
        [tempBtn setTitle:title forState:UIControlStateNormal];
    }
    
    switch (model) {
        case WKNavViewModel_Normal: {
            tempBtn.wk_normalTitle = title;
            break;
        }
        case WKNavViewModel_Transparent: {
            tempBtn.wk_selectTitle = title;
            break;
        }
    }
}
- (void)setTitleColor:(UIColor *)color forNavViewModel:(WKNavViewModel)model toBtnWithDirection:(BOOL)direction
{
    //根据direction 决定是设置左右哪个按钮
    UIButton * tempBtn = direction ? _rightBtn : _leftBtn;
    if (model == _initialModel) {
        [tempBtn setTitleColor:color forState:UIControlStateNormal];
    }
    
    switch (model) {
        case WKNavViewModel_Normal: {
            tempBtn.wk_normalTitleColor = color;
            break;
        }
        case WKNavViewModel_Transparent: {
            tempBtn.wk_selectTitleColor = color;
            break;
        }
    }
}

- (void)setTitle:(NSString *)title forNavViewModel:(WKNavViewModel)model
{
    
    if (model == _initialModel) {
        _titleLabel.text = title;
    }
    
    switch (model) {
        case WKNavViewModel_Normal: {
            _titleLabel.wk_normalText = title;
            break;
        }
        case WKNavViewModel_Transparent: {
            _titleLabel.wk_selectText = title;
            break;
        }
    }
}

- (void)setTitleColor:(UIColor *)color forNavViewModel:(WKNavViewModel)model
{
    if (model == _initialModel) {
        _titleLabel.textColor = color;
    }
    
    switch (model) {
        case WKNavViewModel_Normal: {
            _titleLabel.wk_normalColor = color;
            break;
        }
        case WKNavViewModel_Transparent: {
            _titleLabel.wk_selectColor = color;
            break;
        }
    }
}

- (void)setPresentModel:(WKNavViewModel)presentModel
{
    if (_presentModel == presentModel) {
        return;
    }
    _presentModel = presentModel;
    _leftBtn.wkSelected = presentModel;
    _rightBtn.wkSelected = presentModel;
    _titleLabel.wkSelected = presentModel;
    

    
}


- (void)dealloc
{
    
    if (_scrollView != nil) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}


@end
