//
//  WMUserModel.h
//  PowerBank
//
//  Created by baiju on 2017/8/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMUserModel : NSObject

/*
 cancelRequireCountLimit = 0;
 cancelShareCountLimit = 0;
 userBalance = "0.00";
 userCancelRequireCount = 0;
 userCancelShareCount = 0;
 userCashedMoney = "0.00";
 userCity = "";
 userCreditNum = 0;
 userDeviceType = IOS;
 userGrossIncome = "0.00";
 userHeadImage = "";
 userID = 14;
 userIdentifyID = 5;
 userIdentifyStatus = 1;
 userMobilephone = 17625929112;
 userNickName = 17625929112;
 userProvince = "";
 userSex = UN;
 userStatus = 1;
 userTown = "";
 *
 */
@property (nonatomic, copy) NSString * userCashedMoney;
@property (nonatomic, copy) NSString * userGrossIncome;
@property (nonatomic, assign) BOOL isCertification;
@property (nonatomic, copy) NSString * userID;
@property (nonatomic, copy) NSString * userNickName;
@property (nonatomic, copy) NSString * userMobilephone;
@property (nonatomic, copy) NSString * userHeadImage;
@property (nonatomic, copy) NSString * userProvince;
@property (nonatomic, copy) NSString * userCity;
@property (nonatomic, copy) NSString * userTown;
@property (nonatomic, copy) NSString * userSex;
@property (nonatomic, copy) NSString * userCreditNum;
@property (nonatomic, copy) NSString * userBalance;
@property (nonatomic, copy) NSString * orderNoSendCount;
/** 状态 1为正常，0为禁用 */
@property (nonatomic, copy) NSString * userStatus;
@property (nonatomic, copy) NSString * userIdentifyStatus;
@property (nonatomic, copy) NSString * userIdentifyID;
@property (nonatomic, copy) NSString * userDeviceType;
@property (nonatomic, copy) NSString * userCancelShareCount;
@property (nonatomic, copy) NSString * userCancelRequireCount;
@property (nonatomic, copy) NSString * cancelShareCountLimit;
@property (nonatomic, copy) NSString * cancelRequireCountLimit;

- (id)initWithDictionary:(NSDictionary *)dic;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
