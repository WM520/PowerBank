//
//  WMAlertViewExtension.m
//  PowerBank
//
//  Created by baiju on 2017/8/9.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMAlertViewExtension.h"


@interface WMAlertViewExtension ()
<UITextFieldDelegate>

@property (strong, nonatomic) UIView * backgroundView;
@property (nonatomic, strong) UIButton * btnOK;
@property (nonatomic, strong) UITextField * moneyField;
@property (nonatomic, strong) UILabel * moneyLabel;
@property (nonatomic, strong) UIButton * cancleButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * partLine;
@property (nonatomic, assign) NSInteger moneyAddY;

@end

@implementation WMAlertViewExtension

- (instancetype)initWithTitle:(NSString *)title Msg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile OKBtnTitle:(NSString *)okBtnTitle Img:(UIImage *)img
{
    if ([super init]) {
        self.backgroundColor = [UIColor whiteColor];
        // 取消按钮
        _cancleButton = [[UIButton alloc] init];
        [_cancleButton setBackgroundImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleButton];
        // 标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        // 确定按钮
        _btnOK = [[UIButton alloc] init];
        [_btnOK setTitle:okBtnTitle forState:UIControlStateNormal];
        [_btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnOK setBackgroundColor:RGB(82, 83, 84)];
        [_btnOK addTarget:self action:@selector(commitMoney) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnOK];
        _btnOK.layer.cornerRadius = 10;
        _btnOK.clipsToBounds = YES;
        // 输入金额
        _moneyField = [[UITextField alloc] init];
        _moneyField.placeholder = @"输入金额";
        _moneyField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _moneyField.delegate = self;
        [self addSubview:_moneyField];
        // 分界线
        _partLine = [[UILabel alloc] init];
        [_partLine setBackgroundColor:RGBA(234, 234, 234, 1)];
        [self addSubview:_partLine];
        // 末尾的元
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"元";
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        [self addSubview:_moneyLabel];
        [self.backgroundView addSubview:self];
        CGFloat alertViewWidth = 260;
        CGFloat alertHeight = 200;
        self.frame = CGRectMake((_backgroundView.frame.size.width - alertViewWidth) / 2,
                                (_backgroundView.frame.size.height - alertHeight) / 2,
                                alertViewWidth,
                                alertHeight);
//        [self setUpLayout];
        _titleLabel.frame =  CGRectMake(30, 20, 200, 30);
        _cancleButton.frame =  CGRectMake(225, 10, 25, 25);
        _moneyField.frame = CGRectMake(80, 75, 80, 30);
        _moneyLabel.frame = CGRectMake(160, 75, 30, 30);
        _partLine.frame = CGRectMake(90, 106, 100, 1);
        _btnOK.frame = CGRectMake(70, 150, 120, 40);
        _moneyAddY = self.centerY;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }

    return self;
}


- (void)setUpLayout
{
    _titleLabel.sd_layout
    .topSpaceToView(self, 20)
    .leftSpaceToView(self, 30)
    .widthIs(200)
    .heightIs(25);
}

- (void)layoutSubviews
{

    
    
//    _titleLabel.sd_layout
//    .topSpaceToView(self, 20)
//    .leftSpaceToView(self, 30)
//    .widthIs(200)
//    .heightIs(25);
    
//    _cancleButton.sd_layout
//    .topSpaceToView(self, 10)
//    .rightSpaceToView(self, 10)
//    .widthIs(20)
//    .heightIs(20);
//    
//    _moneyField.sd_layout
//    .topSpaceToView(_titleLabel, 20)
//    .centerXEqualToView(self)
//    .heightIs(25)
//    .widthIs(100);
//    
//    _moneyLabel.sd_layout
//    .centerYEqualToView(_moneyField)
//    .leftSpaceToView(_moneyField, 0)
//    .widthIs(30)
//    .heightIs(25);
//    
//    _partLine.sd_layout
//    .topSpaceToView(_moneyField, 3)
//    .centerXEqualToView(self)
//    .widthIs(130)
//    .heightIs(1);
//    
//    _btnOK.sd_layout
//    .topSpaceToView(_partLine, 20)
//    .centerXEqualToView(self)
//    .heightIs(40)
//    .widthIs(120);
    
    
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES;
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        _backgroundView.layer.masksToBounds = YES;
    }
    
    return _backgroundView;
}

#pragma mark - public method

- (void)show
{
    [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
    } completion:nil];
}


- (void)cancle
{
    [UIView animateWithDuration:0.1 animations:^{
        
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished) {
        
        [self.backgroundView removeFromSuperview];
    }];
}

- (void)commitMoney
{
    [self cancle];
    self.returnMoney(_moneyField.text);
}

#pragma mark -监听键盘弹起事件
- (void)keyboardWillShow:(NSNotification *)notif
{
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.centerY = y - 100;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.centerY = _moneyAddY;
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate
// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
