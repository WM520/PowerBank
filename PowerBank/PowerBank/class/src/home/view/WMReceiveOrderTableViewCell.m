//
//  WMReceiveOrderTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/26.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMReceiveOrderTableViewCell.h"
#import "WMRequireModel.h"

@interface WMReceiveOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *needTime;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation WMReceiveOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)receiveOrder:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(receiveOrder:)]) {
        [self.delegate receiveOrder: self];
    }
    
}

- (void)setModel:(WMRequireModel *)model
{
    _model = model;
    _addrLabel.text = model.address;
    _addressLabel.text = ![model.addr isEqualToString:@""] ? model.addr : @"用户没有输入详细地址";
    _moneyLabel.text = [NSString stringWithFormat:@"%@￥", model.money];
    _needTime.text = [model.getTime substringFromIndex:11];
    MAMapPoint point1 = MAMapPointForCoordinate(_nowLocation.coordinate);
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    _distanceLabel.text = [NSString stringWithFormat:@"%.0f米", distance];
}


@end
