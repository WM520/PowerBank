//
//  WMWithDrawView.m
//  PowerBank
//
//  Created by baiju on 2017/8/30.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMWithDrawView.h"
#import "BankModel.h"

@interface WMWithDrawView ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankName;

@property (weak, nonatomic) IBOutlet UILabel *lastCardNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightConstant;

@end

@implementation WMWithDrawView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)setModel:(BankModel *)model
{
    _model = model;
    _bankName.text = model.bankname;
    _lastCardNumber.text = [model.number substringFromIndex:model.number.length- 4];
}

- (IBAction)withDrawAction:(id)sender {
    if (self.block) {
        self.block();
    }
}

- (IBAction)goToCardVC:(id)sender
{
    if (self.goToBankBlock) {
        self.goToBankBlock();
    }
}

@end
