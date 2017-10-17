//
//  AliPayModel.h
//  PanDaCar
//
//  Created by zcd on 16/4/7.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *** userId 用户唯一标识
 *** orderId 订单Id
 *** orderDeposit 支付金额
 */

@interface CommonPayParam : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderDeposit;

+ (instancetype)paramWithUserId:(NSString *) userId orderId:(NSString *) orderId orderDeposit:(NSString *)orderDeposit;
@end
