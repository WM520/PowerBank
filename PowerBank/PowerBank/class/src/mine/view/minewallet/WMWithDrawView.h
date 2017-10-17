//
//  WMWithDrawView.h
//  PowerBank
//
//  Created by baiju on 2017/8/30.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankModel;
typedef void(^WITHDRAWBLOCK)();
typedef void(^GOTOBANKCARD)();
@interface WMWithDrawView : UIView

@property (nonatomic, copy) WITHDRAWBLOCK block;
@property (nonatomic, copy) GOTOBANKCARD goToBankBlock;
@property (nonatomic, strong) BankModel * model;

@end
