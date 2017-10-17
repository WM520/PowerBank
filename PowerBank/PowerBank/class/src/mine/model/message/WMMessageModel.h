//
//  WMMessageModel.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMMessageModel : NSObject

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * bannerimg;
@property (nonatomic, copy) NSString * h5url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)hotModelWithDictionary:(NSDictionary *)dict;



@end
