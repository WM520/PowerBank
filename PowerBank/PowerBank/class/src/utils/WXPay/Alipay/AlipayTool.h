//
//  AlipayTool.h
//  DHETC
//
//  Created by zlx on 16/7/28.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHETC_ENUM.h"
@interface AlipayTool : NSObject

+ (instancetype)shareInstance;

//使用block回调，避免使用通知。
- (void)payAlipay:(NSString *)orderId payNum:(NSString *)money alipayType:(alipayPayType)type withCompletionBlock:(void(^)(AlipayResultType resultStatusType))handleBlock;

@end
