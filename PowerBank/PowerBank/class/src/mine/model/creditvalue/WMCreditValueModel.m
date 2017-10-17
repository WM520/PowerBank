//
//  WMCreditValueModel.m
//  PowerBank
//
//  Created by baiju on 2017/9/7.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCreditValueModel.h"

@implementation WMCreditValueModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.createTime = [self objectOrNilForKey:@"createTime" fromDictionary:dic];
        self.option = [self objectOrNilForKey:@"option" fromDictionary:dic];
        self.type = [self objectOrNilForKey:@"type" fromDictionary:dic];
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
