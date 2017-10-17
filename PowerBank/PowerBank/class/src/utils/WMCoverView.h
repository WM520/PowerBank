//
//  WMCoverView.h
//  PowerBank
//
//  Created by baiju on 2017/8/31.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMCoverView : UIView

/**
 *  点击蒙版调用
 */
@property (nonatomic, strong) void(^clickCover)();

@end
