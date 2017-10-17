//
//  WXPayModel.m
//  PanDaCar
//
//  Created by zcd on 16/4/8.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import "WXPayModel.h"

@implementation WXPayModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        if ([dic[@"packagestr"] isKindOfClass:[NSNull class]]) {
            self.packagestr = @"";
        }else{
            self.packagestr = dic[@"packagestr"];
        }
        
        if ([dic[@"appid"] isKindOfClass:[NSNull class]]) {
            self.appid = @"";
        }else{
            self.appid = dic[@"appid"];
        }
        
        if ([dic[@"noncestr"] isKindOfClass:[NSNull class]]) {
            self.noncestr = @"";
        }else{
            self.noncestr = dic[@"noncestr"];
        }
        if ([dic[@"package"] isKindOfClass:[NSNull class]]) {
            self.package = @"";
        }else{
            self.package = dic[@"package"];
        }
        if ([dic[@"partnerid"] isKindOfClass:[NSNull class]]) {
            self.partnerid = @"";
        }else{
            self.partnerid = dic[@"partnerid"];
        }
        if ([dic[@"prepayid"] isKindOfClass:[NSNull class]]) {
            self.prepayid = @"";
        }else{
            self.prepayid = dic[@"prepayid"];
        }
        if ([dic[@"sign"] isKindOfClass:[NSNull class]]) {
            self.sign = @"";
        }else{
            self.sign = dic[@"sign"];
        }
        if ([dic[@"timestamp"] isKindOfClass:[NSNull class]]) {
            self.timestamp = @"";
        }else{
            self.timestamp = dic[@"timestamp"];
        }
    }
    return self;
}

+ (id)modelWithDictionary:(NSDictionary *)dic
{
    return [[self alloc]initWithDictionary:dic];
}

@end
