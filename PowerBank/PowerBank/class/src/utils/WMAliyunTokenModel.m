//
//  WMAliyunTokenModel.m
//  PowerBank
//
//  Created by baiju on 2017/9/13.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMAliyunTokenModel.h"

@implementation WMAliyunTokenModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.keyId = [self objectOrNilForKey:@"id" fromDictionary:dic];
        self.expiration = [self objectOrNilForKey:@"expiration" fromDictionary:dic];
        self.secret = [self objectOrNilForKey:@"secret" fromDictionary:dic];
        self.token = [self objectOrNilForKey:@"token" fromDictionary:dic];
    }
    return self;
}

+ (id)modelWithDictionary:(NSDictionary *)dic
{
    return [[self alloc] initWithDictionary:dic];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.keyId forKey:@"keyId"];
    [aCoder encodeObject:self.expiration forKey:@"expiration"];
    [aCoder encodeObject:self.secret forKey:@"secret"];
    [aCoder encodeObject:self.token forKey:@"token"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        if ([[aDecoder decodeObjectForKey:@"keyId"] isKindOfClass:[NSNull class]]) {
            self.keyId = @"nil";
        }else
        {
            self.keyId = [aDecoder decodeObjectForKey:@"keyId"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"expiration"] isKindOfClass:[NSNull class]]) {
            self.expiration = @"nil";
        }else
        {
            self.expiration = [aDecoder decodeObjectForKey:@"expiration"];
        }
        if ([[aDecoder decodeObjectForKey:@"secret"] isKindOfClass:[NSNull class]]) {
            self.secret = @"nil";
        }else
        {
            self.secret = [aDecoder decodeObjectForKey:@"secret"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"token"] isKindOfClass:[NSNull class]]) {
            self.token = @"nil";
        }else
        {
            self.token = [aDecoder decodeObjectForKey:@"token"];
        }

    }
    return self;
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? @"" : object;
}


@end
