//
//  WMRepairTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMRepairTableViewCell.h"

@interface WMRepairTableViewCell ()
<UITextFieldDelegate>

@end
@implementation WMRepairTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        [contentView addSubview:self.titleLabel];
        
        if ([reuseIdentifier isEqualToString:@"cell00"]) {
            _titleLabel.text = @"选择地址";
            _selectedMessage = [[UILabel alloc] init];
            _selectedMessage.textColor = [UIColor colorWithHexString:@"#999999"];
            _selectedMessage.text = @"请选择省市区";
            [contentView addSubview:_selectedMessage];
        } else if ([reuseIdentifier isEqualToString:@"cell01"]) {
            _titleLabel.text = @"详细地址";
            _detailMessage = [[UITextField alloc] init];
            _detailMessage.delegate = self;
            _detailMessage.placeholder = @"请输入详细地址";
            [contentView addSubview:_detailMessage];
        } else if ([reuseIdentifier isEqualToString:@"cell02"]) {
            _titleLabel.text = @"换修时间";
            // 选择日期
            _selectDate = [[UIButton alloc] init];
            [_selectDate setTitle:@"选择日期" forState:UIControlStateNormal];
            [_selectDate addTarget:self action:@selector(selectDateAction) forControlEvents:UIControlEventTouchUpInside];
            [_selectDate setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            _selectDate.titleLabel.textAlignment = NSTextAlignmentLeft;
            [contentView addSubview:_selectDate];
            // 选择时间
            _selectTime = [[UIButton alloc] init];
            [_selectTime setTitle:@"选择时间" forState:UIControlStateNormal];
            [_selectTime setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            _selectTime.titleLabel.textAlignment = NSTextAlignmentLeft;
            [_selectTime addTarget:self action:@selector(selectTimeAction) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:_selectTime];
        }
        [self setupLayout: reuseIdentifier];
    }
    return self;
}

- (void)selectDateAction
{
    if ([self.delegate respondsToSelector:@selector(selectDate:)]) {
        [self.delegate selectDate: self];
    }
}

- (void)selectTimeAction
{
    if ([self.delegate respondsToSelector:@selector(selectTime:)]) {
        [self.delegate selectTime:self];
    }
}

- (void)setupLayout:(NSString *)reuseIdentifier
{
    UIView *contentView = self.contentView;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView, 10)
    .widthIs(100)
    .heightIs(30);
    
    if ([reuseIdentifier isEqualToString:@"cell00"] ) {
        _selectedMessage.sd_layout
        .leftSpaceToView(_titleLabel, 10)
        .topSpaceToView(contentView, 10)
        .rightEqualToView(contentView)
        .heightIs(30);
    }
    
    if ([reuseIdentifier isEqualToString:@"cell01"]) {
        _detailMessage.sd_layout
        .leftSpaceToView(_titleLabel, 10)
        .topSpaceToView(contentView, 10)
        .rightEqualToView(contentView)
        .heightIs(30);
    }
    
    if ([reuseIdentifier isEqualToString:@"cell02"]) {
        _selectDate.sd_layout
        .leftSpaceToView(_titleLabel, 0)
        .topSpaceToView(contentView, 10)
        .widthIs((contentView.frame.size.width - 120) /2)
        .heightIs(30);
        
        _selectTime.sd_layout
        .leftSpaceToView(_selectDate, 0)
        .widthIs((contentView.frame.size.width - 120) /2)
        .topSpaceToView(contentView, 10)
        .heightIs(30);
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(keyBoradDidShow)]) {
        [self.delegate keyBoradDidShow];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(keyBoradDidHide:)]) {
        [self.delegate keyBoradDidHide:textField];
    }
}
@end
