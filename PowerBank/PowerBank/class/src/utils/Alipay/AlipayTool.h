//
//  AlipayTool.h
//  DHETC
//
//  Created by zlx on 16/7/28.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    AlipayResultTypeSuccess,//成功
    AlipayResultTypeFailed,//失败
    AlipayResultTypeCanceled,//取消
    AlipayResultTypeUnknowError//未知错误
} AlipayResultType;


typedef enum : NSUInteger {
    
    alipayRecharge,//支付宝充值
    alipayPayOnLine//支付宝在线支付
    
} alipayPayType;

@interface AlipayTool : NSObject

+ (instancetype)shareInstance;

//使用block回调，避免使用通知。
- (void)payAlipay:(NSString *)orderId payNum:(NSString *)money alipayType:(alipayPayType)type withCompletionBlock:(void(^)(AlipayResultType resultStatusType))handleBlock;

@end
