//
//  WMOrderTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMOrderTableViewCell.h"

@interface WMOrderTableViewCell ()





@end

@implementation WMOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle =UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setIndex:(NSInteger)index
{
    if (index == 0) {
        _iconImage.image = [UIImage imageNamed:@"1"];
        _descLabel.text = @"发起用电请求";
        _topLine.hidden = YES;
    } else if (index == 1) {
        _iconImage.image = [UIImage imageNamed:@"2"];
        _descLabel.text = @"接受派送";
    } else if (index == 2) {
        _iconImage.image = [UIImage imageNamed:@"3"];
        _descLabel.text = @"派送成功";
    } else if (index == 3) {
        _iconImage.image = [UIImage imageNamed:@"4"];
        _descLabel.text = @"支付成功";
        _underLabel.hidden = YES;
    }
}

@end
