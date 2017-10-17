//
//  WMSettingsView.m
//  PowerBank
//
//  Created by baiju on 2017/8/31.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMSettingsView.h"
#import "HYSlider.h"
#import "WMCoverView.h"

@interface WMSettingsView ()
<HYSliderDelegate>

@property (nonatomic, strong) WMCoverView * coverView;
@property (nonatomic, strong) UILabel * scopeLabel;
@property (nonatomic, strong) HYSlider * slider;
@property (nonatomic, strong) UILabel * firstPartLine;
@property (nonatomic, strong) UIButton * commitButton;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * scopeCountLabel;
@property (nonatomic, assign) CGFloat distance;

@end

@implementation WMSettingsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _distance = 1000;
        _coverView = [[WMCoverView alloc] init];
        kWeakSelf(self);
        _coverView.clickCover = ^{
            [weakself hide];
        };
        _coverView.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:.7];
        [self addSubview: _coverView];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _scopeLabel = [[UILabel alloc] init];
        _scopeLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _scopeLabel.text = @"配送范围";
        [_contentView addSubview:_scopeLabel];
        
        _scopeCountLabel = [[UILabel alloc] init];
        _scopeCountLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _scopeCountLabel.text = @"1000米以内";
        [_contentView addSubview:_scopeCountLabel];
        
        _slider = [[HYSlider alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH - 20, 5)];
        _slider.sliderMoveType = HYSliderLongPressGRMove;
        _slider.currentValueColor = [UIColor blackColor];
        _slider.maxValue = 3000;
        _slider.currentSliderValue = 1000;
        _slider.showTextColor = [UIColor blackColor];
        _slider.touchViewColor = [UIColor blackColor];
        
        _slider.showTouchView = YES;
        _slider.showScrollTextView = YES;
        _slider.delegate = self;
        [_contentView addSubview:_slider];
        
        _firstPartLine = [[UILabel alloc] init];
        _firstPartLine.backgroundColor = RGB(223, 223, 223);
        [_contentView addSubview:_firstPartLine];
        
        _commitButton = [[UIButton alloc] init];
        [_commitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setBackgroundColor:RGB(82, 83, 84)];
        _commitButton.layer.cornerRadius = 10;
        _commitButton.layer.masksToBounds = YES;
        [_contentView addSubview:_commitButton];
        
        
        [self setLayout];
    }
    return self;
}

- (void)commit
{
    [self hide];
    if (self.block) {
        self.block(_distance);
    }
}


- (void)hide
{
    // 移除蒙版
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settingsViewHidden" object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)setLayout
{
    
    _coverView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    _contentView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(200);
    
    _scopeLabel.sd_layout
    .leftSpaceToView(_contentView, 10)
    .topSpaceToView(_contentView, 10)
    .widthIs(80)
    .heightIs(25);
    
    _scopeCountLabel.sd_layout
    .leftSpaceToView(_scopeLabel, 5)
    .topSpaceToView(_contentView, 10)
    .widthIs(150)
    .heightIs(25);
    
    _firstPartLine.sd_layout
    .leftSpaceToView(_contentView, 10)
    .rightSpaceToView(_contentView, 10)
    .heightIs(1)
    .topSpaceToView(_slider, 40);
    
    _commitButton.sd_layout
    .centerXEqualToView(_contentView)
    .widthIs(150)
    .heightIs(40)
    .topSpaceToView(_firstPartLine, 30);
    
}

#pragma mark - HYSliderDelegate
- (void)HYSlider:(HYSlider *)hySlider didScrollValue:(CGFloat)value
{
    _scopeCountLabel.text = [NSString stringWithFormat:@"%.0fm以内", value];
    
    _distance = value;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
