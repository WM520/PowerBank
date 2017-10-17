//
//  HotNoImageCell.m
//  DHETC
//
//  Created by David on 16/8/18.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import "HotNoImageCell.h"
#define Margin 5

@interface HotNoImageCell ()
@property (nonatomic, strong) UILabel * kTitleLabel;
@property (nonatomic, strong) UILabel * kTimeLabel;
@property (nonatomic, strong) UILabel * kContentLabel;
@property (nonatomic, strong) UIImageView * backView;

@end

@implementation HotNoImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化UI
        [self configUI];
        // 设置约束
        [self configAutoLayout];
    }
    return self;
}

- (void)configUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    
    self.backView = [[UIImageView alloc] init];
    _backView.image = [UIImage imageNamed:@"magicbox_ activity_bg"];
    [contentView addSubview:_backView];
    
    self.kTitleLabel = [[UILabel alloc] init];
    _kTitleLabel.text = @"注册赠券";
    _kTitleLabel.textColor = RGBA(21, 21, 21, 1);
    _kTitleLabel.font = Font(14);
    [contentView addSubview:_kTitleLabel];
    
    self.kTimeLabel = [[UILabel alloc] init];
    _kTimeLabel.font = Font(12);
    _kTimeLabel.textColor = RGBA(152, 152, 152, 1);
    _kTimeLabel.text = @"7月08号";
    [contentView addSubview:_kTimeLabel];
    
    self.kContentLabel = [[UILabel alloc] init];
    _kContentLabel.font = Font(12);
    _kContentLabel.textColor = RGBA(142, 143, 145, 1);
    _kContentLabel.numberOfLines = 0;
    _kContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [contentView addSubview:_kContentLabel];
    
//    self.kDetailLabel = [[UILabel alloc] init];
//    _kDetailLabel.font = Font(12);
//    _kDetailLabel.textColor = RGBA(124, 125, 127, 1);
//    _kDetailLabel.text = @"立即查看";
//    [contentView addSubview:_kDetailLabel];
}

-(void)configAutoLayout
{
    UIView *contentView = self.contentView;
    
    self.backView.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);
    
    self.kTitleLabel.sd_layout
    .leftSpaceToView(contentView, Margin)
    .topSpaceToView(contentView, Margin)
    .widthIs(150)
    .heightIs(20);
    
    self.kTimeLabel.sd_layout
    .topSpaceToView(_kTitleLabel, Margin)
    .leftEqualToView(_kTitleLabel)
    .widthIs(150)
    .heightIs(20);

    self.kContentLabel.sd_layout
    .leftEqualToView(_kTitleLabel)
    .rightEqualToView(contentView)
    .autoHeightRatio(0)
    .topSpaceToView(_kTimeLabel, Margin);
    
//    self.kDetailLabel.sd_layout
//    .leftEqualToView(_kTitleLabel)
//    .rightEqualToView(contentView)
//    .topSpaceToView(_kContentLabel, Margin)
//    .heightIs(20);
    
    [self setupAutoHeightWithBottomView:self.kContentLabel bottomMargin:Margin + 10];
}


- (void)setModel:(WMMessageModel *)model
{
    _model = model;
    self.kContentLabel.text = FormatterString(model.info);
    self.kTitleLabel.text = FormatterString(model.name);
    self.kTimeLabel.text = FormatterString(model.time);
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width -= 2 * 10;
    frame.size.height -= 10;
    frame.origin.y += 10;
    [super setFrame:frame];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
