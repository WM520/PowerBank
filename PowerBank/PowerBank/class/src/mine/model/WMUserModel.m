//
//  WMUserModel.m
//  PowerBank
//
//  Created by baiju on 2017/8/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMUserModel.h"

@implementation WMUserModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.userID = [NSString stringWithFormat:@"%@",dic[@"userID"]];
        self.userNickName = [NSString stringWithFormat:@"%@",dic[@"userNickName"]];
        self.userMobilephone = [NSString stringWithFormat:@"%@",dic[@"userMobilephone"]];
        self.userHeadImage = [NSString stringWithFormat:@"%@",dic[@"userHeadImage"]];
        self.userProvince = [NSString stringWithFormat:@"%@",dic[@"userProvince"]];
        self.userCity = [NSString stringWithFormat:@"%@",dic[@"userCity"]];
        self.userTown = [NSString stringWithFormat:@"%@",dic[@"userTown"]];
        self.userSex = [NSString stringWithFormat:@"%@",dic[@"userSex"]];
        self.userCreditNum = [NSString stringWithFormat:@"%@",dic[@"userCreditNum"]];
        self.userBalance = [NSString stringWithFormat:@"%@",dic[@"userBalance"]];
        self.userStatus = [NSString stringWithFormat:@"%@",dic[@"userStatus"]];
        
        self.userIdentifyStatus = [NSString stringWithFormat:@"%@",dic[@"userIdentifyStatus"]];
        self.userIdentifyID = [NSString stringWithFormat:@"%@",dic[@"userIdentifyID"]];
        self.userDeviceType = [NSString stringWithFormat:@"%@",dic[@"userDeviceType"]];
        
        self.userCancelShareCount = [NSString stringWithFormat:@"%@",dic[@"userCancelShareCount"]];
        self.userCancelRequireCount = [NSString stringWithFormat:@"%@",dic[@"userCancelRequireCount"]];
        self.cancelShareCountLimit = [NSString stringWithFormat:@"%@",dic[@"cancelShareCountLimit"]];
        
        self.cancelRequireCountLimit = [NSString stringWithFormat:@"%@",dic[@"cancelRequireCountLimit"]];
        self.userCashedMoney = [NSString stringWithFormat:@"%@", dic[@"userCashedMoney"]];
        self.userGrossIncome = [NSString stringWithFormat:@"%@", dic[@"userGrossIncome"]];
        self.orderNoSendCount = [NSString stringWithFormat:@"%@", dic[@"orderNoSendCount"]];
    }
    
    return self;
}

+ (id)modelWithDictionary:(NSDictionary *)dic
{
    return [[self alloc]initWithDictionary:dic];
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.userNickName forKey:@"userNickName"];
    [aCoder encodeObject:self.userMobilephone forKey:@"userMobilephone"];
    [aCoder encodeObject:self.userHeadImage forKey:@"userHeadImage"];
    [aCoder encodeObject:self.userProvince forKey:@"userProvince"];
    [aCoder encodeObject:self.userCity forKey:@"userCity"];
    [aCoder encodeObject:self.userTown forKey:@"userTown"];
    [aCoder encodeObject:self.userSex forKey:@"userSex"];
    [aCoder encodeObject:self.userCreditNum forKey:@"userCreditNum"];
    [aCoder encodeObject:self.userBalance forKey:@"userBalance"];
    [aCoder encodeObject:self.userStatus forKey:@"userStatus"];
    [aCoder encodeObject:self.userIdentifyStatus forKey:@"userIdentifyStatus"];
    [aCoder encodeObject:self.userIdentifyID forKey:@"userIdentifyID"];
    [aCoder encodeObject:self.userDeviceType forKey:@"userDeviceType"];
    [aCoder encodeObject:self.userCancelShareCount forKey:@"userCancelShareCount"];
    [aCoder encodeObject:self.userCancelRequireCount forKey:@"userCancelRequireCount"];
    [aCoder encodeObject:self.cancelShareCountLimit forKey:@"cancelShareCountLimit"];
    [aCoder encodeObject:self.cancelRequireCountLimit forKey:@"cancelRequireCountLimit"];
    [aCoder encodeObject:self.userCashedMoney forKey:@"userCashedMoney"];
    [aCoder encodeObject:self.userGrossIncome forKey:@"userGrossIncome"];
    [aCoder encodeObject:self.orderNoSendCount forKey:@"orderNoSendCount"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        if ([[aDecoder decodeObjectForKey:@"orderNoSendCount"] isKindOfClass:[NSNull class]]) {
            self.orderNoSendCount = @"nil";
        }else
        {
            self.orderNoSendCount = [aDecoder decodeObjectForKey:@"orderNoSendCount"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userCashedMoney"] isKindOfClass:[NSNull class]]) {
            self.userCashedMoney = @"nil";
        }else
        {
            self.userCashedMoney = [aDecoder decodeObjectForKey:@"userCashedMoney"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userGrossIncome"] isKindOfClass:[NSNull class]]) {
            self.userGrossIncome = @"nil";
        }else
        {
            self.userGrossIncome = [aDecoder decodeObjectForKey:@"userGrossIncome"];
        }

        
        if ([[aDecoder decodeObjectForKey:@"userID"] isKindOfClass:[NSNull class]]) {
            self.userID = @"nil";
        }else
        {
            self.userID = [aDecoder decodeObjectForKey:@"userID"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userNickName"] isKindOfClass:[NSNull class]]) {
            self.userNickName = @"nil";
        }else
        {
            self.userNickName = [aDecoder decodeObjectForKey:@"userNickName"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userMobilephone"] isKindOfClass:[NSNull class]]) {
            self.userMobilephone = @"nil";
        }else
        {
            self.userMobilephone = [aDecoder decodeObjectForKey:@"userMobilephone"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userHeadImage"] isKindOfClass:[NSNull class]]) {
            self.userHeadImage = @"nil";
        }else
        {
            self.userHeadImage = [aDecoder decodeObjectForKey:@"userHeadImage"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userTown"] isKindOfClass:[NSNull class]]) {
            self.userTown = @"0";
        }else
        {
            self.userTown = [aDecoder decodeObjectForKey:@"userTown"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userProvince"] isKindOfClass:[NSNull class]]) {
            self.userProvince = @"nil";
        }else
        {
            self.userProvince = [aDecoder decodeObjectForKey:@"userProvince"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userCity"] isKindOfClass:[NSNull class]]) {
            self.userCity = @"nil";
        }else
        {
            self.userCity = [aDecoder decodeObjectForKey:@"userCity"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userSex"] isKindOfClass:[NSNull class]]) {
            self.userSex = @"0";
        }else
        {
            self.userSex = [aDecoder decodeObjectForKey:@"userSex"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userCreditNum"] isKindOfClass:[NSNull class]]) {
            self.userCreditNum = @"nil";
        }else
        {
            self.userCreditNum = [aDecoder decodeObjectForKey:@"userCreditNum"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userBalance"] isKindOfClass:[NSNull class]]) {
            self.userBalance = @"0";
        }else
        {
            self.userBalance = [aDecoder decodeObjectForKey:@"userBalance"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userStatus"] isKindOfClass:[NSNull class]]) {
            self.userStatus = @"nil";
        }else
        {
            self.userStatus = [aDecoder decodeObjectForKey:@"userStatus"];
        }
        
        
        if ([[aDecoder decodeObjectForKey:@"userIdentifyStatus"] isKindOfClass:[NSNull class]]) {
            self.userIdentifyStatus = @"nil";
        }else
        {
            self.userIdentifyStatus = [aDecoder decodeObjectForKey:@"userIdentifyStatus"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userIdentifyID"] isKindOfClass:[NSNull class]]) {
            self.userIdentifyID = @"nil";
        }else
        {
            self.userIdentifyID = [aDecoder decodeObjectForKey:@"userIdentifyID"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userDeviceType"] isKindOfClass:[NSNull class]]) {
            self.userDeviceType = @"nil";
        }else
        {
            self.userDeviceType = [aDecoder decodeObjectForKey:@"userDeviceType"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userCancelShareCount"] isKindOfClass:[NSNull class]]) {
            self.userCancelShareCount = @"nil";
        }else
        {
            self.userCancelShareCount = [aDecoder decodeObjectForKey:@"userCancelShareCount"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"userCancelRequireCount"] isKindOfClass:[NSNull class]]) {
            self.userCancelRequireCount = @"nil";
        }else
        {
            self.userStatus = [aDecoder decodeObjectForKey:@"userCancelRequireCount"];
        }
        
        
        if ([[aDecoder decodeObjectForKey:@"cancelShareCountLimit"] isKindOfClass:[NSNull class]]) {
            self.cancelShareCountLimit = @"nil";
        }else
        {
            self.cancelShareCountLimit = [aDecoder decodeObjectForKey:@"cancelShareCountLimit"];
        }
        
        if ([[aDecoder decodeObjectForKey:@"cancelRequireCountLimit"] isKindOfClass:[NSNull class]]) {
            self.cancelRequireCountLimit = @"nil";
        }else
        {
            self.userStatus = [aDecoder decodeObjectForKey:@"cancelRequireCountLimit"];
        }
    }
    
    return self;
}


@end
