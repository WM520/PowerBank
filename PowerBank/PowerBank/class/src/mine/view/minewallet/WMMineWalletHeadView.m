//
//  WMMineWalletHeadView.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMineWalletHeadView.h"
#import "WMUserModel.h"
@interface WMMineWalletHeadView ()

@property (nonatomic, strong) UILabel * walletLabelCount;
@property (nonatomic, strong) UILabel * walletLabel;
@property (nonatomic, strong) UILabel * allInCome;
@property (nonatomic, strong) UILabel * allInComeCount;
@property (nonatomic, strong) UILabel * withDrawal;
@property (nonatomic, strong) UILabel * withDrawalCount;
@property (nonatomic, strong) UIImageView * partLine;
@end

@implementation WMMineWalletHeadView

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
    bgImageView.image = [UIImage imageNamed:@"mineWalletBg"];
    [self addSubview:bgImageView];
    _walletLabelCount = [[UILabel alloc] init];
    _walletLabelCount.userInteractionEnabled = YES;
    _walletLabelCount.textAlignment = NSTextAlignmentCenter;
    _walletLabelCount.text = @"$6000.00";
    _walletLabelCount.textColor = [UIColor whiteColor];
    _walletLabelCount.font = [UIFont systemFontOfSize:35];
    // 添加点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToCashWithdrawal)];
    [_walletLabelCount addGestureRecognizer:tap];
    [self addSubview:_walletLabelCount];
    _walletLabel = [[UILabel alloc] init];
    _walletLabel.text = @"账户余额";
    _walletLabel.textColor = [UIColor whiteColor];
    _walletLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_walletLabel];
    
    _allInCome = [[UILabel alloc] init];
    _allInCome.text = @"总收入";
    _allInCome.textColor = [UIColor whiteColor];
    _allInCome.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_allInCome];
    
    _allInComeCount = [[UILabel alloc] init];
    _allInComeCount.text = @"$9000.00";
    _allInComeCount.textColor = [UIColor whiteColor];
    _allInComeCount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_allInComeCount];
    
    _withDrawal = [[UILabel alloc] init];
    _withDrawal.text = @"已提现";
    _withDrawal.textColor = [UIColor whiteColor];
    _withDrawal.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_withDrawal];
    
    _withDrawalCount = [[UILabel alloc] init];
    _withDrawalCount.textColor = [UIColor whiteColor];
    _withDrawalCount.textAlignment = NSTextAlignmentCenter;
    _withDrawalCount.text = @"$9000.00";
    [self addSubview:_withDrawalCount];
    
    _partLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PartingLine"]];
    [self addSubview:_partLine];
    
}

- (void)setUserModel:(WMUserModel *)userModel
{
    _userModel = userModel;
    _allInComeCount.text = userModel.userGrossIncome == nil ? @"0.00" : userModel.userGrossIncome;
    _withDrawalCount.text = userModel.userCashedMoney == nil ? @"0.00" : userModel.userCashedMoney;
    NSLog(@"%@", userModel.userCashedMoney);
    _walletLabelCount.text = userModel.userBalance == nil ? @"0.00" : userModel.userBalance;
}

- (void)configLayout
{
    _walletLabel.sd_layout
    .topSpaceToView(self, 50 + 64)
    .centerXEqualToView(self)
    .widthIs(100)
    .heightIs(30);
    
    _walletLabelCount.sd_layout
    .topSpaceToView(_walletLabel, 0)
    .centerXEqualToView(_walletLabel)
    .widthIs(200)
    .heightIs(50);
    
    _allInCome.sd_layout
    .topSpaceToView(_walletLabelCount, 20)
    .centerXIs(SCREEN_WIDTH/4)
    .widthIs(100)
    .heightIs(20);
    
    _allInComeCount.sd_layout
    .topSpaceToView(_allInCome, 10)
    .centerXIs(SCREEN_WIDTH/4)
    .widthIs(200)
    .heightIs(20);
    
    _withDrawal.sd_layout
    .topSpaceToView(_walletLabelCount, 20)
    .centerXIs((SCREEN_WIDTH/4) * 3)
    .widthIs(100)
    .heightIs(20);
    
    _withDrawalCount.sd_layout
    .topSpaceToView(_withDrawal, 10)
    .centerXIs((SCREEN_WIDTH/4) * 3)
    .widthIs(200)
    .heightIs(20);
    
    _partLine.sd_layout
    .centerXEqualToView(self)
    .heightIs(50)
    .widthIs(0.5)
    .topSpaceToView(_walletLabelCount, 20);
}

- (void)goToCashWithdrawal
{
    if (self.goToCashBlock) {
        self.goToCashBlock();
    }
    
}

@end
