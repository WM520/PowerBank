//
//  WMSettingsView.h
//  PowerBank
//
//  Created by baiju on 2017/8/31.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^COMMITBLOCK)(CGFloat);

@interface WMSettingsView : UIView

@property (nonatomic, copy) COMMITBLOCK block;
- (void)hide;
@end
