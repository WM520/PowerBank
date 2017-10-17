//
//  WMSendDemandModel.h
//  PowerBank
//
//  Created by baiju on 2017/8/23.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMSendDemandModel : NSObject

@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * latitude;
/** 用户输入的地址 */
@property (nonatomic, copy) NSString * addr;
/** 定位获取到的地址 */
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * orderID;
@property (nonatomic, copy) NSString * status;

@end
