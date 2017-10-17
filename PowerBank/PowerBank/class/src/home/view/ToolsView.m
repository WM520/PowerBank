//
//  ToolsView.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/3.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "ToolsView.h"
#import "UIButton+ImageTitleSpacing.h"

@interface ToolsView ()

@property (strong, nonatomic, readwrite) UIButton *scanButton;
@property (strong, nonatomic, readwrite) UIButton * shareButton;
@property (assign, nonatomic) NSInteger width;
@property (strong, nonatomic, readwrite) UIButton * hiddenButton;
@property (strong, nonatomic) UIImageView * bgImageView;
@property (strong, nonatomic) UIImageView * test;
@end


@implementation ToolsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
   
        // 初始化UI
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = [UIImage imageNamed:@"toolBG"];
        [self addSubview:_bgImageView];
        _scanButton = [[UIButton alloc] init];
        [_scanButton setTitleColor:[UIColor colorWithHexString:@"414141"] forState:UIControlStateNormal];
        [_scanButton setBackgroundImage:[UIImage imageNamed:@"scanToPower-3"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(goToScanView) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_scanButton];
        
        _shareButton = [[UIButton alloc] init];
        _shareButton.selected = NO;
        [_shareButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"quickshare"] forState:UIControlStateNormal];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"shareBtnSelected"] forState:UIControlStateSelected];
        [_shareButton addTarget:self action:@selector(openShare:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
        
        _hiddenButton = [[UIButton alloc] init];
        _hiddenButton.selected = NO;
//        [_hiddenButton setBackgroundImage:[UIImage imageNamed:@"topdown"] forState:UIControlStateNormal];
//        [_hiddenButton setBackgroundImage:[UIImage imageNamed:@"topup"] forState:UIControlStateSelected];
//        _hiddenButton.imageEdgeInsets=UIEdgeInsetsMake(15, 15, 15, 15);
        _hiddenButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_hiddenButton setImage:[UIImage imageNamed:@"topdown"] forState:UIControlStateNormal];
        [_hiddenButton setImage:[UIImage imageNamed:@"topup"] forState:UIControlStateSelected];
        [_hiddenButton addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_hiddenButton];
        
        _test = [[UIImageView alloc] init];
        _test.userInteractionEnabled = YES;
        [self addSubview:_test];
        // 初始化布局
        [self initLayout];
    }
    return self;
}
/** 把覆盖的点击方法传出去 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([[touches anyObject] view] ==  _test) {
        [self location];
    }
}

- (void)initLayout
{
    _test.sd_layout
    .leftSpaceToView(self, 10)
    .topEqualToView(self)
    .heightIs(50)
    .widthIs(50);
    
    
    _bgImageView.sd_layout
    .leftSpaceToView(self, 0)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self);
    
    _scanButton.sd_layout
    .centerXEqualToView(self)
    .heightIs(55)
    .widthIs(61)
    .topSpaceToView(self, 45);
    
    _shareButton.sd_layout
    .rightSpaceToView(self, 30)
    .bottomSpaceToView(self, 10)
    .widthIs(47)
    .heightIs(35);
    
    _hiddenButton.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 10)
    .heightIs(30)
    .widthIs(30);
}
//- (void)initUI
//{
//    _scanToPower = [UIButton createdbyBackImage:@"findBG"
//                                          title:@"扫码充电"
//                                     titleColor:[UIColor whiteColor]
//                                          image:@"scanToPower"
//                                      addTarget:self
//                                         action:@selector(goToScanView)
//                               forControlEvents:UIControlEventTouchUpInside];
//    [_scanToPower setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
//    _scanToPower.height = 40;
//    [self addSubview:_scanToPower];
//    
//    _findPower = [UIButton createdbyBackImage:@"findBG"
//                           title:@"寻找充电宝"
//                      titleColor:[UIColor whiteColor]
//                           image:@"findPower"
//                       addTarget:self
//                          action:@selector(findNearbyPower)
//                forControlEvents:UIControlEventTouchUpInside];
//    _findPower.height = 40;
//    [_findPower setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
//    [self addSubview:_findPower];
//}
//
//- (void)initLayout
//{
//    NSString * platform = [Utils iphoneType];
//    if ([platform isEqualToString:@"iPhone 5s"] ||
//        [platform isEqualToString:@"iPhone 5"] ||
//        [platform isEqualToString:@"iPhone 5c"] ||
//        [platform isEqualToString:@"iPhone SE"]) {
//        _width = 100;
//        _findPower.titleLabel.font = Font(12);
//        _findPower.layer.cornerRadius = 10;
//        _findPower.layer.masksToBounds = YES;
//        _scanToPower.titleLabel.font = Font(12);
//        _scanToPower.layer.cornerRadius = 10;
//        _scanToPower.layer.masksToBounds = YES;
//        
//    } else if ([platform isEqualToString:@"iPhone 6"] ||
//               [platform isEqualToString:@"iPhone 6s"] ||
//               [platform isEqualToString:@"iPhone 7"]) {
//        _width = 130;
//    } else if ([platform isEqualToString:@"iPhone 6 Plus"] ||
//               [platform isEqualToString:@"iPhone 7 Plus"] ||
//               [platform isEqualToString:@"iPhone 6s Plus"]) {
//        _width = 150;
//    } else {
//        _width = 130;
//    }
//    [self setupAutoMarginFlowItems:@[_findPower, _scanToPower] withPerRowItemsCount:2 itemWidth:_width verticalMargin:(5) verticalEdgeInset:0 horizontalEdgeInset:35];
//}

- (void)goToScanView
{
    if ([self.delegate respondsToSelector:@selector(goToScanView)]) {
        [self.delegate goToScanView];
    }
}

- (void)findNearbyPower
{
    if ([self.delegate respondsToSelector:@selector(findNearbyPower)]) {
//        [self.delegate findNearbyPower];
    }
}

- (void)openShare:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(openShare:)]) {
        [self.delegate openShare:_shareButton];
    }
}

- (void)location
{
    if ([self.delegate respondsToSelector:@selector(location)]) {
        [self.delegate location];
    }
}

- (void)hide:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(hide:)]) {
        [self.delegate hide:btn];
    }
}

@end
