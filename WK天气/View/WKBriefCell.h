//
//  WKBriefCell.h
//  WK天气
//
//  Created by qitian on 16/6/30.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKBriefModel : NSObject

@property (nonatomic, strong,readonly) NSString * title;
@property (nonatomic, strong,readonly) NSString * detail;

+ (instancetype)createModelWithTitle:(NSString *)title detail:(NSString *)detail;

@end

@interface WKBriefCell : UITableViewCell

- (void)setInterFaceWithModel:(WKBriefModel *)model;

@end
