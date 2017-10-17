//
//  WMCabinetModel.m
//  PowerBank
//
//  Created by baiju on 2017/9/5.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCabinetModel.h"

@implementation WMCabinetModel


- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.cabinetID = [self objectOrNilForKey:@"id" fromDictionary:dic];
        self.address = [self objectOrNilForKey:@"address" fromDictionary:dic];
        self.latitude = [self objectOrNilForKey:@"latitude" fromDictionary:dic];
        self.longitude = [self objectOrNilForKey:@"longitude" fromDictionary:dic];
        self.deviceNum = [self objectOrNilForKey:@"deviceNum" fromDictionary:dic];
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
