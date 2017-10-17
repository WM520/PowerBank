//
//  AliPayModel.m
//  PanDaCar
//
//  Created by zcd on 16/4/7.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import "CommonPayParam.h"

@implementation CommonPayParam
#pragma mark - 构造方法
+ (instancetype)paramWithUserId:(NSString *) userId orderId:(NSString *) orderId orderDeposit:(NSString *)orderDeposit{
    
    CommonPayParam *param = [[self alloc] init];
    
    param.userId = userId;
    param.orderId = orderId;
    
    param.orderDeposit = orderDeposit;
    
    return param;
}
@end
