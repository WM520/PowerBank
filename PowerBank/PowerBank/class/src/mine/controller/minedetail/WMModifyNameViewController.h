//
//  WMModifyNameViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"

@protocol WMModifyNameViewControllerDelegate <NSObject>

- (void)userNameModify:(NSString *)userName;

@end

@interface WMModifyNameViewController : BaseViewController

@property (nonatomic, weak) id<WMModifyNameViewControllerDelegate> delegate;

@end
