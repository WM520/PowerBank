//
//  WMCabinetModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/5.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMCabinetModel : NSObject

@property (nonatomic, copy) NSString * cabinetID;
@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * deviceNum;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
