//
//  WMRechargeTableViewCell.m
//  PowerBank
//
//  Created by baiju on 2017/8/7.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMRechargeTableViewCell.h"

@interface WMRechargeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *powerLabel;

@end


@implementation WMRechargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WMRechargeModel *)model
{
    _createTime.text = model.createTime;
    _orderNumber.text = model.openSatus;
    _addressLabel.text = model.address;
    _powerLabel.text = [NSString stringWithFormat:@"%@%%",model.openSatus];

}


@end
