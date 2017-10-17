//
//  WMCreditValueModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/7.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMCreditValueModel : NSObject

@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * option;
@property (nonatomic, copy) NSString * type;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
