//
//  MineTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/9.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "MineTableViewCell.h"

@interface MineTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mineImage;
@property (weak, nonatomic) IBOutlet UILabel *intructionTitle;
@property (weak, nonatomic) IBOutlet UIImageView *linkImage;


@end

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MineCellModel *)model
{
    _mineImage.image = [UIImage imageNamed:model.imgName];
    _intructionTitle.text = model.title;
}

@end
