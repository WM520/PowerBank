//
//  AlipayTool.m
//  DHETC
//
//  Created by zlx on 16/7/28.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import "AlipayTool.h"
#import "CommonPayParam.h"
#import "DataSigner.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>

#define PARTNER @"2088021994129197"
#define SELLER @"huibowangluo@donghuienterprise.com"

static AlipayTool *_alipayInstace;

@implementation AlipayTool

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _alipayInstace = [[AlipayTool alloc]init];
    });
    
    return _alipayInstace;
}

/**
 *orderId：订单号
 *money ：支付金额
 *  @return
 */

//传入订单号、充值金额、调用方式


- (void)payAlipay:(NSString *)orderId payNum:(NSString *)money alipayType:(alipayPayType)type withCompletionBlock:(void(^)(AlipayResultType resultStatusType))handleBlock
{
    UIWindow *windows = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    windows.hidden = NO;
    [windows makeKeyAndVisible];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"dhtec2";
    //订单字符串
    NSString *orderString = nil;
    if (type == alipayRecharge) {
        //充值
        NSString *partner = PARTNER;
        NSString *seller = SELLER;
        
        NSString *privateKey = @"MIICXQIBAAKBgQDWR5AVzyx/SgIqMqZKSJfTRgnti3mR/Tif3kqmSqM0RbfFRIAWVRVOedAcE0KXHUluUz8mgTkyNoxhyL1x6myOmsj7lRkSGFU/BBLg/GyJJirrk2DMAGYGs+wSPR/euLxqWkN/hnW69l2e/zPMRg8S7udbnNLhcYwBQmzalWJ8wQIDAQABAoGBAJGQ0fAO6pKaSzgxakgiYomTFeF6k566YAIyt5GaOJ6lEf9/1mfVawEBvX+lEeKocZ7yDH9y39Edv2YaQaAmeZFz4bpaMKFT+9xxu64igGXMYLo09izBFWzc9rrU3ql3Gg7v2fkgkU79WuR7qGosevV5qHDjyUN426jI3H4wT40lAkEA+pC9rYQBgDC6w85F/83z4bpCmhdYkFJGNtmFNLjG7oy7od4MaBpr3yty5/mqtqh0cKgkSi7ALYsVsrPs2dCq/wJBANrtWHEYjhYsEdxpPuvExIpIkSiemB82aHVHFb/YXLS/NGSuYNX+tkLA7kegT66p0huzyN4wdx0mQfEt3L9/mD8CQAZZtsT4DIWwNnuR9co28RBuhROctdzqiOcI+kxMxpXzMSo4E35r9QHx+vaQKFh6yoC0cj8DElHVLZaa4szecgcCQHZFVMs8db46rqeBYBGk6ny+OVVVYF80WHhLH8/VhjfLN/XQUtYo1bP4YIHndESqz6xRkwmd6yufOG6f1SrLNqcCQQDGHRgWfj1erN/gJTG31L/mNRycnNGKuGotoOIpL5bXlMWQAIOGr1I0OH9y45Y7WHY/iCyRlaguRoYDWMdaJ9QN";
        NSLog(@"--privateKey.length---%lu",(unsigned long)privateKey.length);
        
        Order *order = [[Order alloc] init];
        order.partner = partner; //商户id
        order.seller = seller;
        order.tradeNO = orderId;//订单号
        order.amount = money; //商品价格
        order.productName =@"东汇ETC支付"; //商品标题
        order.productDescription = @"东汇ETC支付"; //商品描述
        order.notifyURL =[NSString stringWithFormat:@"%@%@",kServerUrl,RechargeAlipayHandle_URI];
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showUrl = @"m.alipay.com";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privateKey);
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
            NSLog(@"orderString:%@",orderString);
        }

    }else if (type == alipayPayOnLine) {
        //支付
        orderString = [[AppSettings sharedInstance] stringForKey:@"orderString"];

    }
//    支付宝返回结果
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        windows.hidden = YES;
        NSLog(@"resultStatus:%@",resultDic);
        [[AppSettings sharedInstance] setString:nil forKey:@"orderString"];
        NSString *resultStatus = resultDic[@"resultStatus"];
        
        if ([resultStatus isEqualToString:@"9000"]) {
            //支付成功
            handleBlock(AlipayResultTypeSuccess);
            
        }else if ([resultStatus isEqualToString:@"6001"]){
            //支付取消
            handleBlock(AlipayResultTypeCanceled);
        }else if ([resultStatus isEqualToString:@"4000"]){
            //支付失败
            handleBlock(AlipayResultTypeFailed);
        }else{
            handleBlock(AlipayResultTypeUnknowError);
            //未知错误
        }
    }];

}



@end
