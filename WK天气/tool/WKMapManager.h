//
//  WKMapManager.h
//  WK天气
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

typedef void(^LocationBlock)(NSString * name);

@interface WKMapManager : NSObject

+ (WKMapManager *)shardMapManager;
- (void)startLocationWithBlock:(LocationBlock)block;
@end
