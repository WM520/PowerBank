//
//  WMHasCardTableViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMHasCardTableViewCell.h"

@interface WMHasCardTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bankIconImage;


@end

@implementation WMHasCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bankIconImage.layer.cornerRadius = 25;
    _bankIconImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
