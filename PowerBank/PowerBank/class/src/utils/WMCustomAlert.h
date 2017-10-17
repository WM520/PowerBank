//
//  WMCustomAlert.h
//  PowerBank
//
//  Created by baiju on 2017/8/10.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CommitBlock)();
typedef void(^CancleBlock)();

@interface WMCustomAlert : UIView


- (instancetype)initWithTitle:(NSString *)title
            cancleButtonTitle:(NSString *)cancleTitle
            commitButtonTitle:(NSString *)commitTitle
                isCancleImage:(BOOL) iscancle;
- (void)show;
- (void)hide;

@property (nonatomic, copy) CommitBlock commitBlock;

@property (nonatomic, copy) CancleBlock cancleBlock;

@end
