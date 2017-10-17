//
//  WMReflectViewController.h
//  PowerBank
//
//  Created by baiju on 2017/8/8.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^REFLECTBANKRETURNBLOCK)();

@interface WMReflectViewController : BaseViewController

@property (nonatomic, copy) REFLECTBANKRETURNBLOCK block;

@end
