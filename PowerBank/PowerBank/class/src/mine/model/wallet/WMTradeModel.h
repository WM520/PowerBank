//
//  WMTradeModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/8.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMTradeModel : NSObject

+ (instancetype)modelWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
