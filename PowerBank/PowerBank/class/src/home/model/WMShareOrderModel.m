//
//  WMShareOrderModel.m
//  PowerBank
//
//  Created by baiju on 2017/9/6.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMShareOrderModel.h"

@implementation WMShareOrderModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.addr = [self objectOrNilForKey:@"addr" fromDictionary:dic];
        self.address = [self objectOrNilForKey:@"address" fromDictionary:dic];
        self.latitude = [self objectOrNilForKey:@"latitude" fromDictionary:dic];
        self.longitude = [self objectOrNilForKey:@"longitude" fromDictionary:dic];
        self.quantity = [self objectOrNilForKey:@"quantity" fromDictionary:dic];
        self.device = [self objectOrNilForKey:@"device" fromDictionary:dic];
        self.orderID = [self objectOrNilForKey:@"id" fromDictionary:dic];
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
