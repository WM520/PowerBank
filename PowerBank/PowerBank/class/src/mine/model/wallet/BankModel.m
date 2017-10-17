//
//  BankModel.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.cardID = [self objectOrNilForKey:@"id" fromDictionary:dic];
        self.username = [self objectOrNilForKey:@"username" fromDictionary:dic];
        self.bankname = [self objectOrNilForKey:@"bankname" fromDictionary:dic];
        self.depositname = [self objectOrNilForKey:@"depositBankname" fromDictionary:dic];
        self.number = [self objectOrNilForKey:@"bankCardNumber" fromDictionary:dic];
    }
    return self;
}


+ (instancetype)modelWithDictionary:(NSDictionary *)dic
{
    return [[self alloc] initWithDictionary:dic];
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? @"" : object;
}

@end
