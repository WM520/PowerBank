//
//  WMGuideTableViewCell.m
//  PowerBank
//
//  Created by foreverlove on 2017/7/31.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMGuideTableViewCell.h"
#import "WMGuideModel.h"

@interface WMGuideTableViewCell ()

@property (strong, nonatomic) UILabel * questionLabel;
@property (strong, nonatomic) UILabel * answerLabel;
@property (strong, nonatomic) UIImageView * questionImageView;
@property (strong, nonatomic) UIImageView * answerImageView;
@property (strong, nonatomic) UILabel * partLine;
@end


@implementation WMGuideTableViewCell

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
        [self initUI];
        [self setLayout];
    }
    return self;
}

- (void)initUI
{
    UIView * content = self.contentView;
    _questionImageView = [[UIImageView alloc] init];
    _questionImageView.image = [UIImage imageNamed:@"question"];
    [content addSubview:_questionImageView];
    _answerImageView = [[UIImageView alloc] init];
    _answerImageView.image = [UIImage imageNamed:@"answer"];
    [content addSubview:_answerImageView];
    _questionLabel = [[UILabel alloc] init];
    [content addSubview:_questionLabel];
    _answerLabel = [[UILabel alloc] init];
    [content addSubview:_answerLabel];
    _partLine = [[UILabel alloc] init];
    _partLine.backgroundColor = RGBA(234, 234, 234, 1);
    [content addSubview:_partLine];
}

- (void)setLayout
{
    UIView *contentView = self.contentView;
    _questionImageView.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 5)
    .widthIs(25)
    .heightIs(25);
    
    _questionLabel.sd_layout
    .leftSpaceToView(_questionImageView, 3)
    .centerYEqualToView(_questionImageView)
    .heightIs(25)
    .rightSpaceToView(contentView, 10);
    
    _answerImageView.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(_questionImageView, 3)
    .widthIs(25)
    .heightIs(25);
    
    _answerLabel.sd_layout
    .leftSpaceToView(_answerImageView, 3)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(_questionLabel, 3)
    .autoHeightRatio(0);
    
    _partLine.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(1)
    .bottomSpaceToView(contentView, 1);
    
    [self setupAutoHeightWithBottomView:_answerLabel bottomMargin:10];
}

- (void)setModel:(WMGuideModel *)model
{
    _questionLabel.text = model.question;
    _answerLabel.text = model.answer;
}

@end
