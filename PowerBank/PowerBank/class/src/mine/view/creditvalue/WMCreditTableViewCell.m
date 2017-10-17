//
//  WMCreditTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/19.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCreditTableViewCell.h"
#import "WMCreditValueModel.h"

@interface WMCreditTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *countLable;

@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;


@property (weak, nonatomic) IBOutlet UILabel *isShareSuccessLabel;

@end

@implementation WMCreditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WMCreditValueModel *)model
{
    _model = model;
    if ([[NSString stringWithFormat:@"%@", model.option] isEqualToString:@"0"]) {
        _countLable.text = @"-1";
        if ([[NSString stringWithFormat:@"%@", model.type] isEqualToString:@"1"]) {
            _isShareSuccessLabel.text = @"共享方取消订单";
        } else if ([[NSString stringWithFormat:@"%@", model.type] isEqualToString:@"2"]) {
            _isShareSuccessLabel.text = @"需求方取消订单";
        }
    } else if ([[NSString stringWithFormat:@"%@", model.option] isEqualToString:@"1"]) {
        _countLable.text = @"+1";
        if ([[NSString stringWithFormat:@"%@", model.type] isEqualToString:@"1"]) {
            _isShareSuccessLabel.text = @"共享方完成订单";
        } else if ([[NSString stringWithFormat:@"%@", model.type] isEqualToString:@"2"]) {
            _isShareSuccessLabel.text = @"需求方完成订单";
        }
    }
    
    _createTimeLabel.text = [NSString stringWithFormat:@"%@", model.createTime];
 
}

@end
