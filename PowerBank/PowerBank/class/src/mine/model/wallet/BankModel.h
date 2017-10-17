//
//  BankModel.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject

@property (nonatomic, copy) NSString * cardID;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * bankname;
@property (nonatomic, copy) NSString * depositname;
@property (nonatomic, copy) NSString * number;

+ (instancetype)modelWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
