//
//  WMRequireModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/4.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//addr = "\U7ea2\U8272\U886c\U886b";
//address = "\U6d66\U53e3\U533a\U7eac\U516b\U8def15\U53f7\U661f\U706b\U8def(\U5730\U94c1\U7ad9)";
//createTime = "2017-09-01 15:16:44";
//getTime = "2017-09-01 15:46:00";
//id = 48;
//latitude = "32.157198";
//longitude = "118.697885";
//money = "5.00";
//status = 0;
//uid = 21;

@interface WMRequireModel : NSObject
/** 定位直接获取的地址 */
@property (nonatomic, copy) NSString * addr;
/** 用户手动输入的地址 */
@property (nonatomic, copy) NSString * address;
/** 创建订单的时间 */
@property (nonatomic, copy) NSString * createTime;
/** 获取订单的时间 */
@property (nonatomic, copy) NSString * getTime;
/** 需求的ID */
@property (nonatomic, copy) NSString * requireID;
/** 需求的纬度 */
@property (nonatomic, copy) NSString * latitude;
/** 需求的经度 */
@property (nonatomic, copy) NSString * longitude;
/** 需求的价格 */
@property (nonatomic, copy) NSString * money;
/** 需求的status */
@property (nonatomic, copy) NSString * status;
/** 需求的uid */
@property (nonatomic, copy) NSString * uid;

- (id)initWithDictionary:(NSDictionary *)dic;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
