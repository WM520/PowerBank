//
//  WMRechargeModel.m
//  PowerBank
//
//  Created by 汪淼 on 2017/9/30.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMRechargeModel.h"

@implementation WMRechargeModel


- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.orderID = [self objectOrNilForKey:@"id" fromDictionary:dic];
        self.uid = [self objectOrNilForKey:@"uid" fromDictionary:dic];
        self.device = [self objectOrNilForKey:@"device" fromDictionary:dic];
        self.createTime = [self objectOrNilForKey:@"createTime" fromDictionary:dic];
        self.address = [self objectOrNilForKey:@"address" fromDictionary:dic];
        self.latitude = [self objectOrNilForKey:@"latitude" fromDictionary:dic];
        self.longitude = [self objectOrNilForKey:@"longitude" fromDictionary:dic];
        self.openSatus = [self objectOrNilForKey:@"openSatus" fromDictionary:dic];
    }
    return self;
}

+ (id)modelWithDictionary:(NSDictionary *)dic
{
    return [[self alloc]initWithDictionary:dic];
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? @"" : object;
}


@end
