//
//  WMMessageModel.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMessageModel.h"

@implementation WMMessageModel

+ (instancetype)hotModelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict != nil) {
            self.name = dict[@"name"];
            self.time = dict[@"time"];
            self.info = dict[@"info"];
            self.bannerimg = dict[@"bannerimg"];
            self.h5url = dict[@"h5url"];
        }
        
    }
    return self;
}


@end
