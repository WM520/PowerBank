//
//  WMReceiveOrderTableViewCell.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/26.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
@class WMReceiveOrderTableViewCell;
@class WMRequireModel;

@protocol WMReceiveOrderTableViewCellDelegate <NSObject>

- (void)receiveOrder:(WMReceiveOrderTableViewCell *) cell;

@end

@interface WMReceiveOrderTableViewCell : UITableViewCell

@property (nonatomic, weak) id<WMReceiveOrderTableViewCellDelegate> delegate;
@property (nonatomic, weak) WMRequireModel * model;
@property (strong, nonatomic) CLLocation * nowLocation;

@end
