//
//  WMRechargeModel.h
//  PowerBank
//
//  Created by 汪淼 on 2017/9/30.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMRechargeModel : NSObject

@property (nonatomic, copy) NSString * orderID;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * device;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * openSatus;


- (id)initWithDictionary:(NSDictionary *)dic;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
