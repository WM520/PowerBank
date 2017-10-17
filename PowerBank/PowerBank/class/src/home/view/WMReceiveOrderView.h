//
//  WMReceiveOrderView.h
//  PowerBank
//
//  Created by baiju on 2017/8/29.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMOrderModel;

typedef void(^COMMITSENDED)();
typedef void(^CACLE)();

@interface WMReceiveOrderView : UIView

@property (nonatomic, copy) COMMITSENDED commitBlock;
@property (nonatomic, copy) CACLE cancleBlock;
@property (nonatomic, copy) WMOrderModel * model;

@end
