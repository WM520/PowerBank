//
//  WMOrderModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/6.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMUserModel.h"
#import "WMShareModel.h"
#import "WMRequireModel.h"

@interface WMOrderModel : NSObject
/**共享充电宝人的信息 对应字段shareUser*/
@property (nonatomic, strong) WMUserModel * userShareModel;
/**需求人的信息 对应字段requireUser*/
@property (nonatomic, strong) WMUserModel * userRequireModel;
@property (nonatomic, copy) NSString * payMoney;
/**订单的状态*/
@property (nonatomic, copy) NSString * status;
/**订单的金额*/
@property (nonatomic, copy) NSString * money;
/**红包*/
@property (nonatomic, copy) NSString * redpacket;
/**支付时间*/
@property (nonatomic, copy) NSString * payTime;
/**支付ID*/
@property (nonatomic, copy) NSString * payId;
/**发布的时间*/
@property (nonatomic, copy) NSString * sendTime;
/**接单的时间*/
@property (nonatomic, copy) NSString * receiveTime;
/***/
@property (nonatomic, copy) NSString * sendStatus;
/**发布需求的model 字段uri*/
@property (nonatomic, strong) WMRequireModel * requiremodel;
/**订单ID*/
@property (nonatomic, copy) NSString * orderID;
/***/
@property (nonatomic, copy) NSString * quantity;
/***/
@property (nonatomic, copy) NSString * appeal;
/**  */
@property (nonatomic, copy) NSString * receiveStatus;
/**  */
@property (nonatomic, copy) NSString * serialNumber;
/**  */
@property (nonatomic, copy) NSString * payStatus;
/**  */
@property (nonatomic, copy) NSString * createTime;
/** 对应字段usi */
@property (nonatomic, strong) WMShareModel * shareModel;
/** device */
@property (nonatomic, copy) NSString * device;
/** cancelTime */
@property (nonatomic, copy) NSString * cancelTime;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
