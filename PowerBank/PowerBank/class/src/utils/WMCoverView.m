//
//  WMCoverView.m
//  PowerBank
//
//  Created by baiju on 2017/8/31.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCoverView.h"

@implementation WMCoverView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_clickCover) {
        _clickCover();
    }
}

@end
