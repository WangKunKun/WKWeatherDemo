//
//  NSString+WKNumberToChinese.m
//  WK天气
//
//  Created by qitian on 16/6/22.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "NSString+WKNumberToChinese.h"



@implementation NSString (WKNumberToChinese)

//只针对月份和日子 所以只到十位
+ (NSString *)numberToChinese:(id)number
{
    
    
    NSAssert([number isKindOfClass:[NSString class]] || [number isKindOfClass:[NSNumber class]], @"只接受NSNumber 或者 NSString为输入参数");

    
    NSUInteger num = [number integerValue];
    
    NSUInteger shi =  num / 10;
    NSUInteger ge  = num % 10;
    
    
    NSMutableString * str =[NSMutableString string];
    if (shi > 0) {
        [str appendString:[self arabicToChinese:shi]];
        [str appendString:@"十"];
    }
    
    if (ge > 0) {
        [str appendString:[self arabicToChinese:ge]];
    }
    
    return str;
}


//个位数
+ (NSString *)arabicToChinese:(NSUInteger)n
{
    NSArray * arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    return arr[n - 1];
}


@end
