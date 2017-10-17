//
//  WMAliyunTokenModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/13.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMAliyunTokenModel : NSObject

@property (nonatomic, copy) NSString * keyId;
@property (nonatomic, copy) NSString * expiration;
@property (nonatomic, copy) NSString * secret;
@property (nonatomic, copy) NSString * token;

- (id)initWithDictionary:(NSDictionary *)dic;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
