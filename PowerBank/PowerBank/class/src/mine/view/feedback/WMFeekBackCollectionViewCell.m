//
//  WMFeekBackCollectionViewCell.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/13.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMFeekBackCollectionViewCell.h"

@implementation WMFeekBackCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)deleteImage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteImageWithCell:)]) {
        [self.delegate deleteImageWithCell: self];
    }
}



@end
