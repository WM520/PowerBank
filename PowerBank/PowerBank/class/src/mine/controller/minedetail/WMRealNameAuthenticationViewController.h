//
//  WMRealNameAuthenticationViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^ReturnBlock)();

@interface WMRealNameAuthenticationViewController : BaseViewController

/** 认证成功返回block */
@property (nonatomic, copy) ReturnBlock block;
/** 是否认证 */
@property (nonatomic, assign) BOOL isCertification;
@end
