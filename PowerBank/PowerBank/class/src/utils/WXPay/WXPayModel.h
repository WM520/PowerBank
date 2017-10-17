//
//  WXPayModel.h
//  PanDaCar
//
//  Created by zcd on 16/4/8.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXPayModel : NSObject

/**
 ***  appId 微信开放平台审核通过的应用APPID
 ***   mch_id 微信支付分配的商户号
 ***   nonceStr 随机字符串
 ***   prepayid 微信返回的支付交易会话ID
 ***   timeStamp 时间戳
 */
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *packagestr;

- (id)initWithDictionary:(NSDictionary *)dic;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
