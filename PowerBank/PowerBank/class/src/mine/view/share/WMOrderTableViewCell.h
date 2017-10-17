//
//  WMOrderTableViewCell.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMOrderTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *underLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
