//
//  HomeRemindBox.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/3.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "HomeRemindBox.h"

@interface HomeRemindBox ()
<VerticalLoopDelegate>

@property (nonatomic, strong) UILabel * remindLabel;
@property (nonatomic, strong) UIImageView * remindImageView;
@property (nonatomic, strong) UIImageView * rightLinkView;
@property (nonatomic, strong) MTAVerticalLoopView * loopView;
@end


@implementation HomeRemindBox


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.messageArray = [NSMutableArray array];
        // 初始化控件
        [self initUI];
        // 设置约束
        [self addLayOut];
    }
    return self;
}
// 初始化控件
- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    _remindImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReminderBox"]];
    [self addSubview:_remindImageView];
    
//    _remindLabel = [[UILabel alloc] init];
//    _remindLabel.text = @"您有订单未确认送达，是否送达？";
//    [_remindLabel setTextColor:[UIColor colorWithHexString:@"#414141"]];
//    _remindLabel.font = [UIFont systemFontOfSize:12];
//    [self addSubview:_remindLabel];
    _loopView = [[MTAVerticalLoopView alloc] init];
    _loopView.Direction = VerticalLoopDirectionBottom;
    
    _loopView.loopDelegate = self;
    _loopView.verticalLoopAnimationDuration = 2.0;
    [self addSubview:_loopView];
    [_loopView start];
    _rightLinkView = [[UIImageView alloc] init];
    _rightLinkView.image = [UIImage imageNamed:@"rightlink"];
    [self addSubview:_rightLinkView];
}

- (void)didClickContentAtIndex:(NSInteger)index
{
    NSLog(@"%ld", index);
    
    
    
}

- (void)setMessageArray:(NSMutableArray *)messageArray
{
    _messageArray = messageArray;
    _loopView.data = _messageArray;
}

// 设置约束
- (void)addLayOut
{
    _remindImageView.sd_layout
    .leftSpaceToView(self, 5)
    .centerYEqualToView(self)
    .widthIs(25)
    .heightIs(25);
    
    _loopView.sd_layout
    .leftSpaceToView(_remindImageView, 5)
    .centerYEqualToView(self)
    .rightSpaceToView(self, 50)
    .heightIs(25);
    
    _rightLinkView.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(self, 10)
    .widthIs(8)
    .heightIs(10);
}





@end
