//
//  WMRepairTableViewCell.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMRepairTableViewCell;

@protocol WMRepairTableViewCellDelegate <NSObject>

- (void)keyBoradDidShow;
- (void)keyBoradDidHide:(UITextField *)textField;
- (void)selectDate:(WMRepairTableViewCell *)cell;
- (void)selectTime:(WMRepairTableViewCell *)cell;


@end

@interface WMRepairTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * selectedMessage;
@property (nonatomic, strong) UITextField * detailMessage;
@property (nonatomic, strong) UIButton * selectDate;
@property (nonatomic, strong) UIButton * selectTime;
@property (nonatomic, weak) id<WMRepairTableViewCellDelegate> delegate;

@end
