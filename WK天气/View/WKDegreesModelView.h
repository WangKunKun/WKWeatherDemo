//
//  WKDegreesModelView.h
//  WK天气
//
//  Created by qitian on 16/6/24.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeModelBlock)(BOOL flag);

@interface WKDegreesModelView : UIView

@property (nonatomic, copy) changeModelBlock block;

+ (instancetype)viewFromNIB;

@end
