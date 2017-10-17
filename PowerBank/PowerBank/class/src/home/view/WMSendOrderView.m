//
//  WMSendOrderView.m
//  PowerBank
//
//  Created by foreverlove on 2017/7/21.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMSendOrderView.h"
#import "WMAlertViewExtension.h"
#import "WMSendDemandModel.h"
#import "WMOrderModel.h"
#import <MAMapKit/MAMapKit.h>

@interface WMSendOrderView ()


@property (nonatomic, strong) UIButton * canclebutton;
@property (nonatomic, strong) UIImageView * addressImageView;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UIImageView * rightLink;
@property (nonatomic, strong) UILabel * detailArress;
@property (nonatomic, strong) UILabel * partLineImage;
@property (nonatomic, strong) UILabel * walletLabel;
@property (nonatomic, strong) UILabel * walletCount;
@property (nonatomic, strong) UILabel * verticalPartLine;
@property (nonatomic, strong) UILabel * sendTimeLabel;
@property (nonatomic, strong) UILabel * sendTimeLabelCount;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIButton * addMoney;
@property (nonatomic,strong) UISwipeGestureRecognizer * up;
@property (nonatomic,strong) UISwipeGestureRecognizer * down;
/*******************courier***********************/
@property (nonatomic, strong) UILabel * secondPartLine;
@property (nonatomic, strong) UILabel * courierName;
@property (nonatomic, strong) UIImageView * courierIconImageView;
@property (nonatomic, strong) UIImageView * courierDistanceImage;
@property (nonatomic, strong) UILabel * courierDistanceLabel;
@property (nonatomic, strong) UIImageView * powerElectricityImage;
@property (nonatomic, strong) UILabel * powerElectricityLabel;
@property (nonatomic, strong) UIButton * callButton;

@end

@implementation WMSendOrderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _count = 0;
        _isReceived = NO;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        _addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
        [self addSubview:_addressImageView];
        _canclebutton = [[UIButton alloc] init];
        _canclebutton.backgroundColor = [UIColor blackColor];
        [_canclebutton setTitle:@"取消" forState:UIControlStateNormal];
        [_canclebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_canclebutton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_canclebutton];
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.text = @"南京市中海大厦南京市中海大厦南京市中海大厦";
        _addressLabel.font = Font(15);
        _addressLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        [self addSubview:_addressLabel];
        _detailArress = [[UILabel alloc] init];
        _detailArress.text = @"详细地址";
        _detailArress.textColor = [UIColor colorWithHexString:@""];
        _detailArress.font = Font(14);
        [self addSubview:_detailArress];
        _partLineImage = [[UILabel alloc] init];
        [_partLineImage setBackgroundColor:RGBA(234, 234, 234, 1)];
        [self addSubview:_partLineImage];
        _walletLabel = [[UILabel alloc] init];
        _walletLabel.text = @"红包";
        _walletLabel.font = Font(14);
        _walletLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _walletLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_walletLabel];
        _walletCount = [[UILabel alloc] init];
        _walletCount.userInteractionEnabled = YES;
        _walletCount.textAlignment = NSTextAlignmentCenter;
        NSString * count = @"￥15元";
        _walletCount.attributedText = [self createWithString:count];
        self.up=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
        self.up.direction=UISwipeGestureRecognizerDirectionUp;
        [_walletCount addGestureRecognizer:self.up];
        self.down=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
        self.down.direction=UISwipeGestureRecognizerDirectionDown;
        [_walletCount addGestureRecognizer:self.down];
        [self addSubview:_walletCount];
        
        self.addMoney = [[UIButton alloc] init];
        [self.addMoney setBackgroundImage:[UIImage imageNamed:@"addMoney"] forState:UIControlStateNormal];
        [self.addMoney addTarget:self action:@selector(addMoneyAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addMoney];
        
        _verticalPartLine = [[UILabel alloc] init];
        [_verticalPartLine setBackgroundColor:RGBA(234, 234, 234, 1)];
        [self addSubview:_verticalPartLine];
        _sendTimeLabel = [[UILabel alloc] init];
        _sendTimeLabel.text = @"希望送达时间";
        _sendTimeLabel.font = Font(14);
        _sendTimeLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _sendTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_sendTimeLabel];
        _sendTimeLabelCount = [[UILabel alloc] init];
        _sendTimeLabelCount.text = @"17:30";
        _sendTimeLabelCount.textAlignment = NSTextAlignmentCenter;
        _sendTimeLabelCount.font = Font(25);
        _sendTimeLabelCount.textColor = [UIColor redColor];
        [self addSubview:_sendTimeLabelCount];

        [self setupLayout];
    }
    return self;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [window addSubview:self];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .25;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}
- (void)immediatelyHide
{
    [self removeFromSuperview];
}
// 移除
- (void)hide {
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancelAction
{
    if ([self.delegate respondsToSelector:@selector(cancle)]) {
        [self.delegate cancle];
    }
}

- (void)setModel:(WMSendDemandModel *)model
{
    _model = model;
    _addressLabel.text = model.address;
    _detailArress.text = model.addr;
    NSArray *array = [model.money componentsSeparatedByString:@"."];
    NSString * count = [NSString stringWithFormat:@"￥%@元", array[0]];
    _walletCount.attributedText = [self createWithString:count];
    _sendTimeLabelCount.text = [model.date substringWithRange:NSMakeRange(11, 5)];
    self.isReceived = [[NSString stringWithFormat:@"%@", model.status] isEqualToString:@"1"] == YES || model.status == nil ? NO: YES;
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender

{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        _count++;
        _walletCount.text = [NSString stringWithFormat:@"￥%ld元", _count];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        _count--;
        _walletCount.text = [NSString stringWithFormat:@"￥%ld元", _count];
    }
}

- (void)setOrderModel:(WMOrderModel *)orderModel
{
    _orderModel = orderModel;
    _courierName.text = orderModel.userShareModel.userNickName;
    
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([orderModel.shareModel.latitude floatValue], [orderModel.shareModel.longitude floatValue]));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([orderModel.requiremodel.latitude floatValue], [orderModel.requiremodel.longitude floatValue]));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    self.courierDistanceLabel.text = [NSString stringWithFormat:@"%.0f米", distance];
    _powerElectricityLabel.text = [NSString stringWithFormat:@"%@%%(估)", orderModel.shareModel.quantity];
    
}

- (void)setupLayout
{
    _addressImageView.sd_layout
    .leftSpaceToView(self, 5)
    .topSpaceToView(self, 10)
    .widthIs(12)
    .heightIs(15);
    
    _addressLabel.sd_layout
    .leftSpaceToView(_addressImageView, 3)
    .centerYEqualToView(_addressImageView)
    .heightIs(20)
    .minWidthIs(100);
    [_addressLabel setSingleLineAutoResizeWithMaxWidth:180];
    
    _canclebutton.sd_layout
    .rightEqualToView(self)
    .heightIs(50)
    .widthIs(100)
    .topSpaceToView(self, 0);
    
    
    _detailArress.sd_layout
    .topSpaceToView(_addressLabel, 2)
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, 100)
    .heightIs(20);
    
    _partLineImage.sd_layout
    .topSpaceToView(_detailArress, 0)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(1);
    
    _walletLabel.sd_layout
    .centerXIs(self.frame.size.width / 4)
    .widthIs(50)
    .topSpaceToView(_partLineImage, 10)
    .heightIs(21);
    
    if (!_isReceived) {
        _walletCount.sd_layout
        .leftSpaceToView(self, 10)
        .widthIs(60)
        .topSpaceToView(_walletLabel, 5)
        .heightIs(40);
        
        _addMoney.sd_layout
        .leftSpaceToView(_walletCount, 5)
        .widthIs(60)
        .topSpaceToView(_walletLabel, 15)
        .heightIs(25);
    } else {
        _walletCount.sd_layout
        .leftSpaceToView(self, 10)
        .widthIs(120)
        .topSpaceToView(_walletLabel, 5)
        .heightIs(40);
    }
    
    
    _verticalPartLine.sd_layout
    .centerXEqualToView(self)
    .widthIs(1)
    .heightIs(50)
    .topSpaceToView(_detailArress, 20);
    
    _sendTimeLabel.sd_layout
    .centerXIs((self.frame.size.width / 4) * 3)
    .widthIs(150)
    .topSpaceToView(_partLineImage, 10)
    .heightIs(21);
    
    _sendTimeLabelCount.sd_layout
    .centerXIs((self.frame.size.width / 4) * 3)
    .widthIs(150)
    .topSpaceToView(_sendTimeLabel, 5)
    .heightIs(40);
    
    if (_isReceived) {
        _addMoney.hidden = YES;
        _secondPartLine.sd_layout
        .topSpaceToView(_sendTimeLabelCount, 10)
        .leftSpaceToView(self, 10)
        .rightSpaceToView(self, 10)
        .heightIs(1);
        
        _courierIconImageView.sd_layout
        .leftSpaceToView(self, 10)
        .topSpaceToView(_secondPartLine, 10)
        .widthIs(40)
        .heightIs(40);
        
        _courierName.sd_layout
        .leftSpaceToView(_courierIconImageView, 5)
        .widthIs(150)
        .heightIs(20)
        .topSpaceToView(_secondPartLine, 10);
        
        _powerElectricityImage.sd_layout
        .leftSpaceToView(_courierIconImageView, 5)
        .topSpaceToView(_courierName, 5)
        .heightIs(15)
        .widthIs(15);
        
        _powerElectricityLabel.sd_layout
        .leftSpaceToView(_powerElectricityImage, 3)
        .topSpaceToView(_courierName, 5)
        .widthIs(80)
        .heightIs(15);
        
        _courierDistanceImage.sd_layout
        .leftSpaceToView(_powerElectricityLabel, 10)
        .topSpaceToView(_courierName, 5)
        .heightIs(15)
        .widthIs(15);
        
        _courierDistanceLabel.sd_layout
        .leftSpaceToView(_courierDistanceImage, 3)
        .topSpaceToView(_courierName, 5)
        .widthIs(50)
        .heightIs(15);
        
        _callButton.sd_layout
        .centerYEqualToView(_courierIconImageView)
        .rightSpaceToView(self, 10)
        .widthIs(30)
        .heightIs(30);
    }
    
}


#pragma mark -calluser
- (void)calluser
{
    NSLog(@"calluser");
    if ([self.delegate respondsToSelector:@selector(call)]) {
        [self.delegate call];
    }
}
/** 添加金钱 */
- (void)addMoneyAction
{
    WMAlertViewExtension * alert = [[WMAlertViewExtension alloc] initWithTitle:@"输入加价金额" Msg:@"" CancelBtnTitle:@"" OKBtnTitle:@"确定加价" Img:nil];
    __weak typeof(self) weakself = self;
    alert.returnMoney = ^(NSString * money) {
        NSLog(@"%@", weakself.model.money);
        NSString * count = [NSString stringWithFormat:@"￥%.f元", [money floatValue] + [weakself.model.money floatValue]];
        weakself.walletCount.attributedText = [weakself createWithString:count];
        if ([weakself.delegate respondsToSelector:@selector(addPrice:)]) {
            [weakself.delegate addPrice:money];
        }
    };
    [alert show];
}

#pragma mark - getters or setters
- (void)setIsReceived:(BOOL)isReceived
{
    _isReceived = isReceived;
    // 第二个分割线
    _secondPartLine = [[UILabel alloc] init];
    [_secondPartLine setBackgroundColor:RGBA(234, 234, 234, 1)];
    [self addSubview:_secondPartLine];
    // 接单人姓名
    _courierName = [[UILabel alloc] init];
    _courierName.text = @"汪淼";
    [self addSubview:_courierName];
    // 接单人头像
    _courierIconImageView = [[UIImageView alloc] init];
    _courierIconImageView.layer.cornerRadius = 20;
    _courierIconImageView.clipsToBounds = YES;
    _courierIconImageView.image = [UIImage imageNamed:@"iconuser"];
    [self addSubview:_courierIconImageView];
    // 电量
    _powerElectricityImage = [[UIImageView alloc] init];
    _powerElectricityImage.image = [UIImage imageNamed:@"power"];
    [self addSubview:_powerElectricityImage];
    _powerElectricityLabel = [[UILabel alloc] init];
    _powerElectricityLabel.text = @"50%";
    _powerElectricityLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:_powerElectricityLabel];
    // 距离
    _courierDistanceImage = [[UIImageView alloc] init];
    _courierDistanceImage.image = [UIImage imageNamed:@"orderDistance"];
    [self addSubview:_courierDistanceImage];
    _courierDistanceLabel = [[UILabel alloc] init];
    _courierDistanceLabel.text = @"700m";
    _courierDistanceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:_courierDistanceLabel];
    // 电话按钮
    _callButton = [[UIButton alloc] init];
    [_callButton addTarget:self action:@selector(calluser) forControlEvents:UIControlEventTouchUpInside];
    [_callButton setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    [self addSubview:_callButton];
    [self setupLayout];
    
}

- (NSAttributedString *)createWithString:(NSString *)text
{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:13.0]
     
                          range:NSMakeRange(0, 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithHexString:@"#999999"]
     
                          range:NSMakeRange(0, 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithHexString:@"#999999"]
     
                          range:NSMakeRange(text.length - 1, 1)];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:13.0]
     
                          range:NSMakeRange(text.length - 1, 1)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(1, text.length - 2)];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:25.0]
     
                          range:NSMakeRange(1, text.length - 2)];
    return AttributedStr;
}

@end
