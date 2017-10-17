//
//  WMHasBankCardViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"
@class BankModel;
@protocol WMHasBankCardViewControllerDelegate <NSObject>

- (void)refreshData;

@end

@interface WMHasBankCardViewController : BaseViewController

@property (nonatomic, strong) BankModel * model;
@property (nonatomic, weak) id<WMHasBankCardViewControllerDelegate> delegate;


@end
