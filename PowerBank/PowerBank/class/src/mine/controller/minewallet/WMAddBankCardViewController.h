//
//  WMAddBankCardViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ADDBANKRETURNBLOCK)();

@interface WMAddBankCardViewController : BaseViewController

@property (nonatomic, copy) ADDBANKRETURNBLOCK block;

@end
