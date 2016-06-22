//
//  NSString+WKNumberToChinese.h
//  WK天气
//
//  Created by qitian on 16/6/22.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WKNumberToChinese)

//只接受数字和
+ (NSString *)numberToChinese:(id)number;


@end
