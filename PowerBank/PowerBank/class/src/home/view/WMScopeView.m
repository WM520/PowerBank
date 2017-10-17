//
//  WMScopeView.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/25.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMScopeView.h"
#import "HYSlider.h"

@interface WMScopeView ()
<HYSliderDelegate>

@property (nonatomic, strong) UILabel * scopeLabel;
@property (nonatomic, strong) UILabel * scopeCountLabel;
@property (nonatomic, strong) HYSlider * slider;
@property (nonatomic, strong) UILabel * scanLabel;
@property (nonatomic, strong) UIButton * scanButton;
@property (nonatomic, strong) UIImageView * scanImage;
@property (nonatomic, strong) UIButton * commitButton;
@property (nonatomic, strong) UILabel * firstPartLine;
@property (nonatomic, strong) UILabel * secondPartLine;
@property (nonatomic, strong) UILabel * absolutelyLable;

@end


@implementation WMScopeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        _scopeLabel = [[UILabel alloc] init];
        _scopeLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _scopeLabel.text = @"配送范围";
        [self addSubview:_scopeLabel];
        
        _scopeCountLabel = [[UILabel alloc] init];
        _scopeCountLabel.text = @"1000m以内";
        _scopeCountLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        [self addSubview:_scopeCountLabel];
        
        _slider = [[HYSlider alloc] initWithFrame:CGRectMake(5, 110, SCREEN_WIDTH - 20, 5)];
        _slider.sliderMoveType = HYSliderLongPressGRMove;
        _slider.currentValueColor = [UIColor blackColor];
        _slider.maxValue = 3000;
        _slider.currentSliderValue = 1000;
        _slider.showTextColor = [UIColor blackColor];
        _slider.touchViewColor = [UIColor blackColor];
        _slider.showTouchView = YES;
        _slider.showScrollTextView = NO;
        _slider.delegate = self;
        [self addSubview:_slider];
        
        _firstPartLine = [[UILabel alloc] init];
        _firstPartLine.backgroundColor = RGB(228, 228, 228);
        [self addSubview:_firstPartLine];
        
        
        _scanLabel = [[UILabel alloc] init];
        _scanLabel.text = @"扫一扫共享充电宝";
        _scanLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        [self addSubview:_scanLabel];
        
        _absolutelyLable = [[UILabel alloc] init];
        _absolutelyLable.text = @"电量66%";
        _absolutelyLable.textAlignment = NSTextAlignmentRight;
        _absolutelyLable.textColor = [UIColor colorWithHexString:@"#414141"];
        [self addSubview:_absolutelyLable];
        
        _scanButton = [[UIButton alloc] init];
//        [_scanButton setBackgroundImage:[UIImage imageNamed:@"scanToPower-2"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(goToScan) forControlEvents:UIControlEventTouchUpInside];
        
        _scanImage = [[UIImageView alloc] init];
        [_scanImage setImage:[UIImage imageNamed:@"scanToPower-2"]];
        
        [_scanButton addSubview:_scanImage];
        [self addSubview:_scanButton];
        
        _secondPartLine = [[UILabel alloc] init];
        _secondPartLine.backgroundColor = RGB(228, 228, 228);
        [self addSubview:_secondPartLine];
        
        _commitButton = [[UIButton alloc] init];
        [_commitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setBackgroundColor:RGB(37, 38, 39)];
        [self addSubview:_commitButton];
        
//        [self setLayout];
    }
    return self;
}

- (void)commit
{
    if ([self.delegate respondsToSelector:@selector(commit:)]) {
        NSString * distance = [_scopeCountLabel.text substringToIndex:_scopeCountLabel.text.length - 3];
        [self.delegate commit:distance];
    }
}

- (void)goToScan
{
    if ([self.delegate respondsToSelector:@selector(goToScan)]) {
        [self.delegate goToScan];
    }
}

- (void)HYSlider:(HYSlider *)hySlider didScrollValue:(CGFloat)value{
    
    NSLog(@"%f",value);
    
    _scopeCountLabel.text = [NSString stringWithFormat:@"%.0fm以内", value];
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

// 移除
- (void)hide {
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)immediatelyHide
{
    [self removeFromSuperview];
}

- (void)setType:(ScopeType)type
{
    _type = type;
    [self setLayout];
}

- (void)setLayout
{
    
    _scanLabel.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 10)
    .widthIs(200)
    .heightIs(40);
    
    _scanButton.sd_layout
    .centerYEqualToView(_scanLabel)
    .heightIs(40)
    .widthIs(40)
    .rightSpaceToView(self, 10);
    
    _scanImage.sd_layout
    .topSpaceToView(_scanButton, 10)
    .leftSpaceToView(_scanButton, 10)
    .widthIs(20)
    .heightIs(20);

    _secondPartLine.sd_layout
    .topSpaceToView(_scanLabel, 10)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(1);
    
    //配送范围
    _scopeLabel.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(_secondPartLine, 5)
    .widthIs(80)
    .heightIs(25);
    
    //距离
    _scopeCountLabel.sd_layout
    .leftSpaceToView(_scopeLabel, 5)
    .topSpaceToView(_secondPartLine, 5)
    .widthIs(150)
    .heightIs(25);
    
//    _slider.sd_layout
//    .leftSpaceToView(self, 10)
//    .rightSpaceToView(self, 10)
//    .topSpaceToView(_scopeLabel, 20)
//    .heightIs(10);
    
    
    _firstPartLine.sd_layout
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .topSpaceToView(_slider, 20)
    .heightIs(1);
    
    
    //扫描label
//    _scanLabel.sd_layout
//    .leftSpaceToView(self, 10)
//    .topSpaceToView(_firstPartLine, 10)
//    .widthIs(200)
//    .heightIs(40);
    
    
    
    //扫描button
//    _scanButton.sd_layout
//    .centerYEqualToView(_scanLabel)
//    .heightIs(40)
//    .widthIs(40)
//    .rightSpaceToView(self, 10);
   
    
//    _secondPartLine.sd_layout
//    .topSpaceToView(_scanLabel, 10)
//    .leftSpaceToView(self, 10)
//    .rightSpaceToView(self, 10)
//    .heightIs(1);
    
    _commitButton.sd_layout
    .topSpaceToView(_firstPartLine, 20)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomEqualToView(self);
    
    if (_type == ScopeTypeNoScan) {
        

    } else if (_type == ScopeTypeHaveScan) {
       
        _scanButton.sd_layout
        .topSpaceToView(_firstPartLine, 5)
        .heightIs(20)
        .widthIs(20)
        .rightSpaceToView(self, 10);
        
        _absolutelyLable.sd_layout
        .topSpaceToView(_scanButton, 5)
        .heightIs(20)
        .widthIs(100)
        .rightSpaceToView(self, 10);
        
    }
    

    
    
    
}

@end
