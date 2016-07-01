//
//  UIImage+WKScreenshots.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/22.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WKScreenshots)

+ (UIImage *)getFullImageWithView:(UIView *)view;
//合并
+ (UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage;
//压缩
- (UIImage *)compressImage:(CGSize)size;
//图层截图
+ (UIImage *) glToUIImageWithView:(UIView *)view;
//uikit截图
+ (UIImage *)getTargetViewScreenShotImageWith:(UIView *)TargetView;
//获得纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cor;

@end
