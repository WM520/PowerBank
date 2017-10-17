//
//  WMShareOrderModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/6.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMShareOrderModel : NSObject

/** 定位直接获取的地址 */
@property (nonatomic, copy) NSString * addr;
/** 用户手动输入的地址 */
@property (nonatomic, copy) NSString * address;
/** 共享充电宝的电量 */
@property (nonatomic, copy) NSString * quantity;
/** 共享充电宝的经度 */
@property (nonatomic, copy) NSString * longitude;
/** 共享充电宝的纬度 */
@property (nonatomic, copy) NSString * latitude;
/** 共享充电宝的设备ID */
@property (nonatomic, copy) NSString * device;
/** 共享充电宝订单ID */
@property (nonatomic, copy) NSString * orderID;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
