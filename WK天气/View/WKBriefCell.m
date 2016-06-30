//
//  WKBriefCell.m
//  WK天气
//
//  Created by qitian on 16/6/30.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "WKBriefCell.h"

@interface WKBriefModel ()

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * detail;

@end
@implementation WKBriefModel

+ (instancetype)createModelWithTitle:(NSString *)title detail:(NSString *)detail
{
    WKBriefModel * model = [[self alloc] init];
    model.title = title;
    model.detail = detail;
    return model;
}

@end

@interface WKBriefCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation WKBriefCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setInterFaceWithModel:(WKBriefModel *)model
{
    _detailLabel.text = model.detail;
    _titleLabel.text = model.title;

}

@end
