//
//  WMReceiveOrderView.m
//  PowerBank
//
//  Created by baiju on 2017/8/29.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMReceiveOrderView.h"
#import "WMOrderModel.h"
#import <MAMapKit/MAMapKit.h>


@interface WMReceiveOrderView ()

@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *receiveUser;
@property (weak, nonatomic) IBOutlet UILabel *sendUser;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *addressAppend;
@property (weak, nonatomic) IBOutlet UILabel *powernumber;

@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation WMReceiveOrderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
    }
    return self;
}

- (IBAction)cancleOrder:(id)sender {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}
- (IBAction)commitSended:(id)sender {
    if (self.commitBlock) {
        self.commitBlock();
    }
}
- (IBAction)call:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _model.userRequireModel.userMobilephone]]];
}
- (IBAction)nav:(id)sender {
    
    
}

- (void)setModel:(WMOrderModel *)model
{
    _model = model;
    _address.text = model.requiremodel.address;
    _detailAddress.text = model.requiremodel.addr;
    NSLog(@"%@", model.requiremodel.money);
    _price.text = [NSString stringWithFormat:@"%@", [model.requiremodel.money componentsSeparatedByString:@"."][0]];
    // 截取时间
    _time.text = [NSString stringWithFormat:@"%@", [model.requiremodel.getTime substringWithRange:NSMakeRange(11, 5)]];
    _sendUser.text = model.userShareModel.userNickName;
    NSLog(@"%@", model.quantity);
    _powernumber.text = [NSString stringWithFormat:@"%@%%(估)", model.shareModel.quantity];
    _receiveUser.text = model.userRequireModel.userNickName;
    
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_model.shareModel.latitude floatValue], [_model.shareModel.longitude floatValue]));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_model.requiremodel.latitude floatValue], [_model.requiremodel.longitude floatValue]));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    self.distance.text = [NSString stringWithFormat:@"%.0f米", distance];
    
}

@end
