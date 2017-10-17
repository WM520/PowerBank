//
//  WMOrderModel.m
//  PowerBank
//
//  Created by baiju on 2017/9/6.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMOrderModel.h"


@implementation WMOrderModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.payMoney = [self objectOrNilForKey:@"payMoney" fromDictionary:dic];
        self.status = [self objectOrNilForKey:@"status" fromDictionary:dic];
        self.money = [self objectOrNilForKey:@"money" fromDictionary:dic];
        self.redpacket = [self objectOrNilForKey:@"redpacket" fromDictionary:dic];
        self.payTime = [self objectOrNilForKey:@"payTime" fromDictionary:dic];
        self.payId = [self objectOrNilForKey:@"payId" fromDictionary:dic];
        self.sendTime = [self objectOrNilForKey:@"sendTime" fromDictionary:dic];
        self.receiveTime = [self objectOrNilForKey:@"receiveTime" fromDictionary:dic];
        self.sendStatus = [self objectOrNilForKey:@"sendStatus" fromDictionary:dic];
        self.orderID = [self objectOrNilForKey:@"id" fromDictionary:dic];
        self.quantity = [self objectOrNilForKey:@"quantity" fromDictionary:dic];
        self.appeal = [self objectOrNilForKey:@"appeal" fromDictionary:dic];
        self.receiveStatus = [self objectOrNilForKey:@"receiveStatus" fromDictionary:dic];
        self.serialNumber = [self objectOrNilForKey:@"serialNumber" fromDictionary:dic];
        self.payStatus = [self objectOrNilForKey:@"payStatus" fromDictionary:dic];
        self.createTime = [self objectOrNilForKey:@"createTime" fromDictionary:dic];
        self.device = [self objectOrNilForKey:@"device" fromDictionary:dic];
        self.cancelTime = [self objectOrNilForKey:@"cancelTime" fromDictionary:dic];
        
        self.userShareModel = [WMUserModel modelWithDictionary:[self objectOrNilForKey:@"shareUser" fromDictionary:dic]];
        self.userRequireModel = [WMUserModel modelWithDictionary:[self objectOrNilForKey:@"requireUser" fromDictionary:dic]];
        self.requiremodel = [WMRequireModel modelWithDictionary:[self objectOrNilForKey:@"uri" fromDictionary:dic]];
        self.shareModel = [WMShareModel modelWithDictionary:[self objectOrNilForKey:@"usi" fromDictionary:dic]];
        
    }
    return self;
}
+ (id)modelWithDictionary:(NSDictionary *)dic
{
    return [[self alloc] initWithDictionary:dic];
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? @"" : object;
}

@end
