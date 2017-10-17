//
//  MineHeadView.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/4.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "MineHeadView.h"

@interface MineHeadView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton * walletButton;
@property (nonatomic, strong) UILabel * walletLabel;
@property (nonatomic, strong) UIButton * creditValueButton;
@property (nonatomic, strong) UILabel * userNameLabel;
@property (nonatomic, strong) UIButton * authenticationButton;
@property (nonatomic, strong) UILabel * creditValueLabel;

@end



@implementation MineHeadView

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
    bgImageView.image = [UIImage imageNamed:@"mineHeadBg"];
    [self addSubview:bgImageView];
    _walletButton = [[UIButton alloc] init];
    [_walletButton setTitle:@"$5.00" forState:UIControlStateNormal];
    _walletButton.titleLabel.font = Font(25);
    [_walletButton addTarget:self action:@selector(goToWallet) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_walletButton];
    _walletLabel = [[UILabel alloc] init];
    _walletLabel.text = @"我的钱包";
    _walletLabel.font = Font(14);
    _walletLabel.textColor = [UIColor whiteColor];
    _walletLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_walletLabel];
    _creditValueButton = [[UIButton alloc] init];
    [_creditValueButton setTitle:@"800" forState:UIControlStateNormal];
    _creditValueButton.titleLabel.font = Font(25);
    [_creditValueButton addTarget:self action:@selector(goToCreditVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_creditValueButton];
    _creditValueLabel = [[UILabel alloc] init];
    _creditValueLabel.text = @"信用值";
    _creditValueLabel.font = Font(14);
    _creditValueLabel.textColor = [UIColor whiteColor];
    _creditValueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_creditValueLabel];
    _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconuser"]];
    _iconImageView.layer.cornerRadius = 40;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    PrivateLetterTap.delegate= self;
    [_iconImageView addGestureRecognizer:PrivateLetterTap];
    [self addSubview:_iconImageView];
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.text = @"wangmiao";
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
//    _userNameLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_userNameLabel];
    _authenticationButton = [[UIButton alloc] init];
    if ([AppSettings checkIsCertification]) {
        [_authenticationButton setBackgroundImage:[UIImage imageNamed:@"haveCertification"] forState:UIControlStateNormal];
    } else {
        [_authenticationButton setBackgroundImage:[UIImage imageNamed:@"noCertification"] forState:UIControlStateNormal];
    }
    
    [_authenticationButton addTarget:self action:@selector(goToAuthentication) forControlEvents:UIControlEventTouchUpInside];
    [_authenticationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_authenticationButton];
}
- (void)configLayout
{
    _walletButton.sd_layout
    .topSpaceToView(self, 30 + 64)
    .leftSpaceToView(self, 30)
    .widthIs(100)
    .heightIs(30);
    
    _walletLabel.sd_layout
    .topSpaceToView(_walletButton, 3)
    .leftSpaceToView(self, 30)
    .widthIs(100)
    .heightIs(30);
    
    _iconImageView.sd_layout
    .topSpaceToView(self, 20 + 64)
    .leftSpaceToView(self, (SCREEN_WIDTH - 80) / 2)
    .widthIs(80)
    .heightIs(80);
    
    _creditValueButton.sd_layout
    .rightSpaceToView(self, 30)
    .topSpaceToView(self, 30 + 64)
    .widthIs(100)
    .heightIs(30);
    
    _creditValueLabel.sd_layout
    .topSpaceToView(_creditValueButton, 3)
    .rightSpaceToView(self, 30)
    .widthIs(100)
    .heightIs(30);
    
    _userNameLabel.sd_layout
    .topSpaceToView(_iconImageView, 10)
    .leftSpaceToView(self, (SCREEN_WIDTH - 120) / 2)
    .rightSpaceToView(self, (SCREEN_WIDTH - 120) / 2)
//    .widthIs(80)
    .heightIs(30);
    
    _authenticationButton.sd_layout
    .topSpaceToView(_userNameLabel, 10)
    .leftSpaceToView(self, (SCREEN_WIDTH - 100) /2)
    .widthIs(100)
    .heightIs(30);
}

- (void)setModel:(WMUserModel *)model
{
    _model = model;
    if ([[NSString stringWithFormat:@"%@", model.userIdentifyStatus] isEqualToString:@"1"]) {
        [_authenticationButton setBackgroundImage:[UIImage imageNamed:@"haveCertification"] forState:UIControlStateNormal];
        _authenticationButton.enabled = YES;
    } else if ([[NSString stringWithFormat:@"%@", model.userIdentifyStatus] isEqualToString:@"0"]) {
        [_authenticationButton setBackgroundImage:[UIImage imageNamed:@"noCertification"] forState:UIControlStateNormal];
        _authenticationButton.enabled = YES;
    }
    [_walletButton setTitle:_model.userBalance forState:UIControlStateNormal];
    [_creditValueButton setTitle:_model.userCreditNum forState:UIControlStateNormal];
    _userNameLabel.text = _model.userNickName;
}

- (void)tapAvatarView:(UITapGestureRecognizer *)gesture
{
    [self goToMineDetail];
}

- (void)goToMineDetail
{
    if ([self.delegate respondsToSelector:@selector(goToMineDetail)]) {
        [self.delegate goToMineDetail];
    }
}

- (void)goToWallet
{
    if ([self.delegate respondsToSelector:@selector(goToMineWallet)]) {
        [self.delegate goToMineWallet];
    }
}

- (void)goToAuthentication
{
    if ([self.delegate respondsToSelector:@selector(goToAuthenticationController)]) {
        [self.delegate goToAuthenticationController];
    }
}

- (void)goToCreditVC
{
    if ([self.delegate respondsToSelector:@selector(goToCreditController)]) {
        [self.delegate goToCreditController];
    }
}

@end
