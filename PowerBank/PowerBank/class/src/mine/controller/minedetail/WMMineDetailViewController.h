//
//  WMMineDetailViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"
@class WMUserModel;

typedef void(^ReturnImageBlock)(UIImage * iconImage);
typedef void(^ReturnUserName)(NSString * name);
typedef void(^ReturnUserSex)(NSString * sex);

@interface WMMineDetailViewController : BaseViewController
// 返回的image的block
@property (nonatomic, copy) ReturnImageBlock returnImageBlock;
// 修改姓名过后的回调block
@property (nonatomic, copy) ReturnUserName returnUserNameBlock;
// 修改性别过后的回调block
@property (nonatomic, copy) ReturnUserSex returnUserSex;
// 个人信息model
@property (nonatomic, strong) WMUserModel * model;

@end
