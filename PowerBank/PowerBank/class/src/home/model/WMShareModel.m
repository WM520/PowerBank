//
//  WMShareModel.m
//  PowerBank
//
//  Created by baiju on 2017/9/4.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMShareModel.h"

@implementation WMShareModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.addr = [self objectOrNilForKey:@"addr" fromDictionary:dic];
        self.address = [self objectOrNilForKey:@"address" fromDictionary:dic];
        self.createTime = [self objectOrNilForKey:@"createTime" fromDictionary:dic];
        self.getTime = [self objectOrNilForKey:@"getTime" fromDictionary:dic];
        self.device = [self objectOrNilForKey:@"device" fromDictionary:dic];
        self.deviceID = [self objectOrNilForKey:@"id" fromDictionary:dic];
        self.latitude = [self objectOrNilForKey:@"latitude" fromDictionary:dic];
        self.longitude = [self objectOrNilForKey:@"longitude" fromDictionary:dic];
        self.quantity = [self objectOrNilForKey:@"quantity" fromDictionary:dic];
        self.status = [self objectOrNilForKey:@"status" fromDictionary:dic];
        self.uid = [self objectOrNilForKey:@"uid" fromDictionary:dic];
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
