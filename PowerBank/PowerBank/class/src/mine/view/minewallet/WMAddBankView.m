//
//  WMAddBankView.m
//  PowerBank
//
//  Created by baiju on 2017/8/30.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMAddBankView.h"

@implementation WMAddBankView

- (IBAction)addBankCardAction:(id)sender {
    
    if (self.block) {
        self.block();
    }
}


@end
