//
//  WMMineWalletHeadView.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoToCashWithdrawalBlock)();

@interface WMMineWalletHeadView : UIView

@property (nonatomic, strong) WMUserModel * userModel;
@property (nonatomic, copy) GoToCashWithdrawalBlock goToCashBlock;

@end
