//
//  WMShareListModel.h
//  PowerBank
//
//  Created by baiju on 2017/9/7.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMShareListModel : NSObject

@property (nonatomic, assign) BOOL isReceive;
@property (nonatomic, copy) NSString * timeString;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * payStatus;

@end
