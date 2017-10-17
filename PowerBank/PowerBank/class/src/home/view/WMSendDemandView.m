//
//  WMSendDemandView.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/19.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMSendDemandView.h"
#import <ActionSheetStringPicker.h>
#import <ActionSheetDatePicker.h>
#import "WMSendDemandModel.h"

@interface WMSendDemandView ()
<UITextFieldDelegate>

// 黑色透明背景
@property (nonatomic, copy) NSString * dataSelectedTime;
@property (nonatomic, strong) WMSendDemandModel * model;

@end

@implementation WMSendDemandView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSDate * date = [NSDate date];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _dataSelectedTime = [dateFormatter1 stringFromDate:date];
        _count = 0;
        _selectIndex = 0;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        _addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
        [self addSubview:_addressImageView];
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.userInteractionEnabled = YES;
        _addressLabel.text = @"南京市中海大厦南京市中海大厦南京市中海大厦";
        _addressLabel.font = Font(15);
        _addressLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _addressSelect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEnvelope:)];
        _addressSelect.numberOfTapsRequired = 1;
        [_addressLabel addGestureRecognizer:_addressSelect];
        [self addSubview:_addressLabel];
        
        _rightLink = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightlink"]];
        [self addSubview:_rightLink];
        _detailArress = [[UITextField alloc] init];
        _detailArress.placeholder = @"补充详细地址";
        _detailArress.delegate = self;
        _detailArress.font = Font(14);
        [self addSubview:_detailArress];
        _partLineImage = [[UILabel alloc] init];
        [_partLineImage setBackgroundColor:RGBA(234, 234, 234, 1)];
        [self addSubview:_partLineImage];
        _walletLabel = [[UILabel alloc] init];
        _walletLabel.text = @"红包";
        _walletLabel.font = Font(14);
        _walletLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _walletLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_walletLabel];
        _walletCount = [[UILabel alloc] init];
        _walletCount.userInteractionEnabled = YES;
        _walletCount.textAlignment = NSTextAlignmentCenter;
        NSString * count = @"￥5元";
        _walletCount.attributedText = [self createWithString:count];
        _selectMoney = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEnvelope:)];
        _selectMoney.numberOfTapsRequired = 1;
        [_walletCount addGestureRecognizer:_selectMoney];
        [self addSubview:_walletCount];
        
        _verticalPartLine = [[UILabel alloc] init];
        [_verticalPartLine setBackgroundColor:RGBA(234, 234, 234, 1)];
        [self addSubview:_verticalPartLine];
        
        _sendTimeLabel = [[UILabel alloc] init];
        _sendTimeLabel.text = @"希望送达时间";
        _sendTimeLabel.font = Font(14);
        _sendTimeLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        _sendTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_sendTimeLabel];
        
        _sendTimeLabelCount = [[UILabel alloc] init];
        _sendTimeLabelCount.userInteractionEnabled = YES;
        _sendTimeLabelCount.text = @"17:30";
        _sendTimeLabelCount.textAlignment = NSTextAlignmentCenter;
        _sendTimeLabelCount.font = Font(25);
        _sendTimeLabelCount.textColor = [UIColor redColor];
        _selectDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEnvelope:)];
        _selectDate.numberOfTapsRequired = 1;
        [_sendTimeLabelCount addGestureRecognizer:_selectDate];
        [self addSubview:_sendTimeLabelCount];
        
        _secondPartLine = [[UILabel alloc] init];
        [_secondPartLine setBackgroundColor:RGBA(234, 234, 234, 1)];
        [self addSubview:_secondPartLine];
        
        _sendDemandButton = [[UIButton alloc] init];
        [_sendDemandButton addTarget:self action:@selector(sendDemendAction) forControlEvents:UIControlEventTouchUpInside];
        [_sendDemandButton setTitle:@"发送需求" forState:UIControlStateNormal];
        [_sendDemandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendDemandButton setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_sendDemandButton];
        
        [self setupLayout];
    }
    return self;
}

- (void)setAddressLabelText:(NSString *)addressLabelText
{
    if (addressLabelText.length > 0) {
        _addressLabel.text = addressLabelText;
    }
    
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

- (void)backgroundClickAction:(id)sender {
    if (_hideWhenTouchBackground) {
        [self hide];
    }
}

- (void)sendDemendAction
{
    _model = [[WMSendDemandModel alloc] init];
    _model.addr = _detailArress.text;
    _model.address = _addressLabel.text;
    NSAttributedString * money =[_walletCount.attributedText attributedSubstringFromRange:NSMakeRange(1, _walletCount.attributedText.length - 2)];
    _model.money = [money string];
    _model.date = _dataSelectedTime;
    _model.longitude = _longitude;
    _model.latitude = _latitude;
    if ([self.delegate respondsToSelector:@selector(sendDemand:)]) {
        [self.delegate sendDemand: _model];
    }
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender

{
    NSLog(@"%@", sender);
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        if (sender.view == _walletCount) {
            _count++;
            _walletCount.attributedText = [self createWithString:[NSString stringWithFormat:@"￥%ld元", _count]];
        } else if (sender.view == _sendTimeLabelCount) {
            _sendTimeLabelCount.text = @"20:20";
        }

    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        if (sender.view == _walletCount) {
            _count--;
            _walletCount.attributedText = [self createWithString:[NSString stringWithFormat:@"￥%ld元", _count]];
        } else if (sender.view == _sendTimeLabelCount) {
            _sendTimeLabelCount.text = @"20:10";
        }


    }
}

- (NSAttributedString *)createWithString:(NSString *)text
{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:13.0]
     
                          range:NSMakeRange(0, 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithHexString:@"#999999"]
     
                          range:NSMakeRange(0, 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithHexString:@"#999999"]
     
                          range:NSMakeRange(text.length - 1, 1)];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:13.0]
     
                          range:NSMakeRange(text.length - 1, 1)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(1, text.length - 2)];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:25.0]
     
                          range:NSMakeRange(1, text.length - 2)];
    return AttributedStr;
}

- (void)selectEnvelope:(UITapGestureRecognizer *)sender
{
        if (sender.view == _walletCount) {
            NSMutableArray * dataArray = [NSMutableArray array];
            for (int i = 0; i < 99; i++) {
                NSString * moneyCount = [NSString stringWithFormat:@"￥%d元", i+1];
                [dataArray addObject:moneyCount];
            }
            _dataArray = dataArray;
            [ActionSheetStringPicker showPickerWithTitle:@"红包" rows:dataArray initialSelection:_selectIndex target:self successAction:@selector(animalWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:self];
        } else if (sender.view == _sendTimeLabelCount) {
            NSInteger minuteInterval = 5;
            //clamp date
            NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
            NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
            NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
            if(remainingSeconds>((minuteInterval*60)/2)) {/// round up
                timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
            }
            self.selectedTime = [NSDate date];
            ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择时间" datePickerMode:UIDatePickerModeTime selectedDate:self.selectedTime target:self action:@selector(timeWasSelected:element:) origin:self];
            datePicker.minuteInterval = minuteInterval;
            [datePicker showActionSheetPicker];
        } else if (sender.view == _addressLabel) {
            if ([self.delegate respondsToSelector:@selector(selectCity)]) {
                [self.delegate selectCity];
            }
        }
}

- (void)animalWasSelected:(NSNumber *)selectedIndex element:(id)element {
    _selectIndex = [selectedIndex integerValue];
    NSString * count = self.dataArray[_selectIndex];
    _walletCount.attributedText = [self createWithString:count];
}
- (void)actionPickerCancelled:(id)sender {
    NSLog(@"user was cancelled");
}

-(void)dateSelector
{
    NSLog(@"SELECTOR");
}

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    NSLog(@"%@", selectedTime);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    _sendTimeLabelCount.text = [dateFormatter stringFromDate:selectedTime];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _dataSelectedTime = [dateFormatter1 stringFromDate:selectedTime];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_detailArress resignFirstResponder];
    return YES;
}

- (void)setupLayout
{
    _addressImageView.sd_layout
    .leftSpaceToView(self, 5)
    .topSpaceToView(self, 10)
    .widthIs(12)
    .heightIs(15);
    
    _addressLabel.sd_layout
    .leftSpaceToView(_addressImageView, 5)
    .centerYEqualToView(_addressImageView)
    .heightIs(20)
    .minWidthIs(50);
    [_addressLabel setSingleLineAutoResizeWithMaxWidth:230];
    
    _rightLink.sd_layout
    .leftSpaceToView(_addressLabel, 2)
    .centerYEqualToView(_addressImageView)
    .heightIs(15)
    .widthIs(10);
    
    _detailArress.sd_layout
    .topSpaceToView(_addressLabel, 2)
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, 20)
    .heightIs(20);
    
    _partLineImage.sd_layout
    .topSpaceToView(_detailArress, 2)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(1);
    
    _walletLabel.sd_layout
    .centerXIs(self.frame.size.width / 4)
    .widthIs(50)
    .topSpaceToView(_partLineImage, 10)
    .heightIs(21);
    
    _walletCount.sd_layout
    .centerXIs(self.frame.size.width / 4)
    .widthIs(150)
    .topSpaceToView(_walletLabel, 5)
    .heightIs(40);
    
    
    _verticalPartLine.sd_layout
    .centerXEqualToView(self)
    .widthIs(1)
    .heightIs(50)
    .topSpaceToView(_detailArress, 20);
    
    _sendTimeLabel.sd_layout
    .centerXIs((self.frame.size.width / 4) * 3)
    .widthIs(150)
    .topSpaceToView(_partLineImage, 10)
    .heightIs(21);
    
    _sendTimeLabelCount.sd_layout
    .centerXIs((self.frame.size.width / 4) * 3)
    .widthIs(150)
    .topSpaceToView(_sendTimeLabel, 5)
    .heightIs(40);
    
    _secondPartLine.sd_layout
    .topSpaceToView(_walletCount, 5)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(1);
    
    _sendDemandButton.sd_layout
    .topSpaceToView(_secondPartLine, 15)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomEqualToView(self);
}

@end
