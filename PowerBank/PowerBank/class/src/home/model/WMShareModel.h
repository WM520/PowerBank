//
//  WMShareModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/4.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//addr = "";
//address = "\U6d66\U53e3\U533a\U7eac\U516b\U8def15\U53f7\U661f\U706b\U8def(\U5730\U94c1\U7ad9)";
//createTime = "2017-09-04 15:53:20";
//device = 2;
//id = 32;
//latitude = "32.157232";
//longitude = "118.697857";
//quantity = 20;
//status = 0;
//uid = 15;

@interface WMShareModel : NSObject

/** 定位直接获取的地址 */
@property (nonatomic, copy) NSString * addr;
/** 用户手动输入的地址 */
@property (nonatomic, copy) NSString * address;
/** 创建订单的时间 */
@property (nonatomic, copy) NSString * createTime;
/** 获取订单的时间 */
@property (nonatomic, copy) NSString * getTime;
/** 共享设备号 */
@property (nonatomic, copy) NSString * device;
/** 共享设备的ID */
@property (nonatomic, copy) NSString * deviceID;
/** 共享的纬度 */
@property (nonatomic, copy) NSString * latitude;
/** 共享的经度 */
@property (nonatomic, copy) NSString * longitude;
/** 共享充电宝的电量 */
@property (nonatomic, copy) NSString * quantity;
/** 共享的status */
@property (nonatomic, copy) NSString * status;
/** 共享的uid */
@property (nonatomic, copy) NSString * uid;

- (id)initWithDictionary:(NSDictionary *)dic;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
