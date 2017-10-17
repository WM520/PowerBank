//
//  WMAddBankView.h
//  PowerBank
//
//  Created by baiju on 2017/8/30.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ADDBANKCARDBLOCK)();

@interface WMAddBankView : UIView

@property (nonatomic, copy) ADDBANKCARDBLOCK block;

@end
