//
//  SharedRecordTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/11.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "SharedRecordTableViewCell.h"

@interface SharedRecordTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *introductionImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@end

@implementation SharedRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WMShareListModel *)model
{
    _model = model;
    if ([model.status isEqualToString:@"收"]) {
        _introductionImage.image = [UIImage imageNamed:@"received"];
    } else if ([model.status isEqualToString:@"送"]) {
        _introductionImage.image = [UIImage imageNamed:@"require"];
    }
    _timeLabel.text = model.timeString;
    _addreeLabel.text = model.address;
    _orderStatus.text = model.payStatus;
    if ([model.payStatus isEqualToString:@"失败"]) {
        
        _orderStatus.textColor = [UIColor redColor];
    } else if ([model.payStatus isEqualToString:@"已完成"]) {
        _orderStatus.textColor = [UIColor colorWithHexString:@"#414141"];
    } else if ([model.payStatus isEqualToString:@"未支付"]) {
        _orderStatus.textColor = RGB(224, 180, 99);
    } else if ([model.payStatus isEqualToString:@"未送达"]) {
        _orderStatus.textColor = RGB(100, 199, 128);
    }
}

@end
