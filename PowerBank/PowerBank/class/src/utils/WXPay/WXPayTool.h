//
//  WXPayTool.h
//  DHETC
//
//  Created by zlx on 16/7/28.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"
#import "WXPayModel.h"

typedef enum : NSUInteger {
    
    WXPayResultTypeSuccess,//成功
    WXPayResultTypeFailed,//失败
    WXPayResultTypeCanceled//取消
} WXPayResultType;

typedef void(^WXPayHandleBlock)(WXPayResultType wxpayResultHandle);
@interface WXPayTool : NSObject<WXApiDelegate>

@property (nonatomic, copy) WXPayHandleBlock wxpayHandleBlock;

+ (instancetype)shareWXPayTool;

//避开使用通知，使用block回调结果，仅供参考。
- (void)wxPay:(NSString *)orderId withCompletionBlock:(WXPayHandleBlock)handleBlock;
- (void)onlineWXPay:(NSString *)orderId info:(NSDictionary *)infoDic withCompletionBlock:(WXPayHandleBlock)handleBlock;






@end
