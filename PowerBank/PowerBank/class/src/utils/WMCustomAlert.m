//
//  WMCustomAlert.m
//  PowerBank
//
//  Created by baiju on 2017/8/10.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCustomAlert.h"

@interface WMCustomAlert ()
/** 标题 */
@property (nonatomic, strong) UILabel * titleLabel;
/** 取消 */
@property (nonatomic, strong) UIButton * cancleButton;
/** 确定 */
@property (nonatomic, strong) UIButton * commitButton;
/** 大的背景 */
@property (nonatomic, strong) UIImageView * backGroundView;
/** content */
@property (nonatomic, strong) UIView * contentView;
@end

@implementation WMCustomAlert

- (instancetype)initWithTitle:(NSString *)title cancleButtonTitle:(NSString *)cancleTitle commitButtonTitle:(NSString *)commitTitle isCancleImage:(BOOL)iscancle
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

        // 大的背景
        _backGroundView = [[UIImageView alloc] initWithFrame:self.frame];
        _backGroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancle)];
        [_backGroundView addGestureRecognizer:tap];
        _backGroundView.backgroundColor = [UIColor blackColor];
        _backGroundView.alpha = 0.4;
        [self addSubview:_backGroundView];
        // 大的容器
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = 10;
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLabel];
        // 取消
        _cancleButton = [[UIButton alloc] init];
//        _cancleButton.layer.cornerRadius = 10;
//        _cancleButton.clipsToBounds = YES;
        [_cancleButton setTitle:cancleTitle forState:UIControlStateNormal];
        [_cancleButton setBackgroundImage:[UIImage imageNamed:@"alert_button_left"] forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithHexString:@"#414141"] forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancleButton];
        // 确定
        _commitButton = [[UIButton alloc] init];
//        _commitButton.layer.cornerRadius = 10;
//        _commitButton.clipsToBounds = YES;
        [_commitButton setTitle:commitTitle forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage imageNamed:@"alert_button_right"] forState:UIControlStateNormal];
        [_commitButton setBackgroundColor:DominantColor];
        [_commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_commitButton];
        
        [self setLayout];
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


- (void)setLayout
{
    _contentView.sd_layout
    .widthIs(250)
    .heightIs(200)
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    
    _titleLabel.sd_layout
    .topSpaceToView(_contentView, 30)
    .heightIs(100)
    .leftSpaceToView(_contentView, 20)
    .rightSpaceToView(_contentView, 20);
    
    _cancleButton.sd_layout
    .bottomSpaceToView(_contentView, 20)
    .leftSpaceToView(_contentView, 30)
    .widthIs((_contentView.width - 30 * 3) /2)
    .heightIs(35);
    
    _commitButton.sd_layout
    .bottomSpaceToView(_contentView, 20)
    .leftSpaceToView(_cancleButton, 30)
    .widthIs((_contentView.width - 30 * 3) /2)
    .heightIs(35);
    
}

// 移除
- (void)hide {
    [UIView animateWithDuration:.25 animations:^{
        self.backGroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancle
{
    [self hide];
    if (self.commitBlock) {
        self.commitBlock();
    }
    
}

- (void)commit
{
    [self hide];
    if (self.cancleBlock) {
       self.cancleBlock(); 
    }
    
}

@end
