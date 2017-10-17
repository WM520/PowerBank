//
//  WMCreditValueHeadView.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCreditValueHeadView.h"
#import "WMUserModel.h"

@interface WMCreditValueHeadView ()

@property (nonatomic, strong) UIImageView * instrumentImageView;
@property (nonatomic, strong) UILabel * creditLabelCount;
@property (nonatomic, strong) UIButton * creditButton;

@end

@implementation WMCreditValueHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self configLayout];
    }
    return self;
}


- (void)initUI
{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"CreditValueBG"];
    [self addSubview:bgImageView];
    _instrumentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instrumentImage"]];
    [self addSubview:_instrumentImageView];
    _creditLabelCount = [[UILabel alloc] init];
    _creditLabelCount.text = @"100";
    _creditLabelCount.font = Font(45);
    _creditLabelCount.textColor = [UIColor whiteColor];
    _creditLabelCount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_creditLabelCount];
    _creditButton = [[UIButton alloc] init];
    _creditButton.clipsToBounds = YES;
    _creditButton.layer.cornerRadius = 15;
    [_creditButton setBackgroundColor:RGBA(255, 255, 255, 0.3)];
    [_creditButton addTarget:self action:@selector(goToIntroductionController) forControlEvents:UIControlEventTouchUpInside];
    [_creditButton setTitle:@"了解信用值" forState:UIControlStateNormal];
    [_creditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_creditButton];
}

- (void)setModel:(WMUserModel *)model
{
    _model = model;
    _creditLabelCount.text = model.userCreditNum;
}

- (void)configLayout
{
    _instrumentImageView.sd_layout
    .centerXEqualToView(self)
    .widthIs(200)
    .heightIs(130)
    .topSpaceToView(self, 90);
    
    _creditLabelCount.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 150)
    .widthIs(80)
    .heightIs(50);
    
    _creditButton.sd_layout
    .topSpaceToView(_instrumentImageView, 20)
    .centerXEqualToView(self)
    .widthIs(150)
    .heightIs(30);
}

- (void)goToIntroductionController
{
    if ([self.delegate respondsToSelector:@selector(goToCreditController)]) {
        [self.delegate goToCreditController];
    }
}

@end
