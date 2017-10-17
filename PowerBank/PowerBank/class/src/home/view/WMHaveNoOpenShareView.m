//
//  WMHaveNoOpenShareView.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/26.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMHaveNoOpenShareView.h"

@interface WMHaveNoOpenShareView ()

@property (nonatomic, strong) UILabel * remindLabel;
@property (nonatomic, strong) UIButton * addreeModelButton;
@property (nonatomic, strong) UILabel * partLine;

@end

@implementation WMHaveNoOpenShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self setupLayout];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    _remindLabel = [[UILabel alloc] init];
    _remindLabel.text = @"暂未开启共享，请开启下方共享开关。";
    _remindLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _remindLabel.font = Font(14);
    [self addSubview:_remindLabel];
    
    _addreeModelButton = [[UIButton alloc] init];
    [_addreeModelButton addTarget:self action:@selector(swithToAddress) forControlEvents:UIControlEventTouchUpInside];
    [_addreeModelButton setImage:[UIImage imageNamed:@"mapMode"] forState:UIControlStateNormal];
    [self addSubview:_addreeModelButton];
    
    _partLine = [[UILabel alloc] init];
    _partLine.backgroundColor = RGB(234, 234, 234);
    [self addSubview:_partLine];
}

- (void)setupLayout
{
    _remindLabel.sd_layout
    .leftSpaceToView(self, 10)
    .topEqualToView(self)
    .heightIs(40)
    .rightSpaceToView(self, 40);
    
    _addreeModelButton.sd_layout
    .rightSpaceToView(self, 0)
    .topEqualToView(self)
    .heightIs(40)
    .widthIs(40);
    
    _partLine.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(1);
    
}

- (void)swithToAddress
{
    if ([self.delegate respondsToSelector:@selector(swithToAddress)]) {
        [self.delegate swithToAddress];
    }
}

@end
