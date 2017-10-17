//
//  WMAddBankTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMAddBankTableViewCell.h"

@interface WMAddBankTableViewCell ()

@property (nonatomic, strong) UITextField * userNameTF;
@property (nonatomic, strong) UITextField * cardTF;
@property (nonatomic, strong) UITextField * bankNameTF;
@property (nonatomic, strong) UILabel * bankName;

@end

@implementation WMAddBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView * content = self.contentView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([reuseIdentifier isEqualToString:@"00"]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
            label.text = @"银行卡姓名";
            [content addSubview:label];
            _userNameTF = [[UITextField alloc] init];
            _userNameTF.placeholder = @"请输入持卡人姓名";
            [content addSubview:_userNameTF];
            _userNameTF.sd_layout
            .leftSpaceToView(label, 0)
            .rightSpaceToView(content, 5)
            .heightIs(44)
            .topEqualToView(content);
        } else if ([reuseIdentifier isEqualToString:@"10"]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
            label.text = @"银行卡号";
            [content addSubview:label];
            _cardTF = [[UITextField alloc] init];
            _cardTF.placeholder = @"请输入银行卡号";
            [content addSubview:_cardTF];
            _cardTF.sd_layout
            .leftSpaceToView(label, 0)
            .rightSpaceToView(content, 5)
            .heightIs(44)
            .topEqualToView(content);
        } else if ([reuseIdentifier isEqualToString:@"11"]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
            label.text = @"选择银行";
            [content addSubview:label];
            _bankName = [[UILabel alloc] init];
            _bankName.text = @"请选择银行";
            [content addSubview:_bankName];
            _bankName.sd_layout
            .leftSpaceToView(label, 0)
            .rightSpaceToView(content, 5)
            .heightIs(44)
            .topEqualToView(content);
        } else if ([reuseIdentifier isEqualToString:@"12"]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
            label.text = @"开户行";
            [content addSubview:label];
            _bankNameTF = [[UITextField alloc] init];
            _bankNameTF.placeholder = @"请输入开户行";
            [content addSubview:_bankNameTF];
            _bankNameTF.sd_layout
            .leftSpaceToView(label, 0)
            .rightSpaceToView(content, 5)
            .heightIs(44)
            .topEqualToView(content);
        }
        
        // [self setUpLayout: reuseIdentifier];
    }
    return self;
}

- (void)setUpLayout:(NSString *)reuseIdentifier
{
    
}

@end
