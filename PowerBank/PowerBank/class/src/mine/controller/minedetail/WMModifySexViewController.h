//
//  WMModifySexViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"

@protocol WMModifySexViewControllerDelegate <NSObject>

- (void)userSexModify: (NSInteger)index;

@end

@interface WMModifySexViewController : BaseViewController

@property (nonatomic, weak) id<WMModifySexViewControllerDelegate> delegate;

@end
