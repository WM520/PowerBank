//
//  WMAdressListTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/24.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMAdressListTableViewCell.h"

@interface WMAdressListTableViewCell ()


@end

@implementation WMAdressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
