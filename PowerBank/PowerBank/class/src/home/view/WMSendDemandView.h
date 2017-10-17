//
//  WMSendDemandView.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/19.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMSendDemandModel;

@protocol WMSendDemandViewDelegate <NSObject>

- (void)sendDemand: (WMSendDemandModel *) model;
- (void)selectCity;

@end

@interface WMSendDemandView : UIView

@property (nonatomic ,strong ,readonly) UIControl *backgroundView;
@property (nonatomic, assign) BOOL hideWhenTouchBackground;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIButton * canclebutton;
@property (nonatomic, strong) UIImageView * addressImageView;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UIImageView * rightLink;
@property (nonatomic, strong) UITextField * detailArress;
@property (nonatomic, strong) UILabel * partLineImage;
@property (nonatomic, strong) UILabel * walletLabel;
@property (nonatomic, strong) UILabel * walletCount;
@property (nonatomic, strong) UILabel * verticalPartLine;
@property (nonatomic, strong) UILabel * sendTimeLabel;
@property (nonatomic, strong) UILabel * sendTimeLabelCount;
@property (nonatomic, strong) UILabel * secondPartLine;
@property (nonatomic, strong) UIButton * sendDemandButton;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UITapGestureRecognizer * selectMoney;
@property (nonatomic, strong) UITapGestureRecognizer * selectDate;
@property (nonatomic, strong) NSDate * currentDate;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSDate *selectedTime;
@property (nonatomic, strong) UITapGestureRecognizer * addressSelect;
@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * addressLabelText;

- (void)show;
- (void)hide;
- (void)immediatelyHide;
@property (nonatomic, weak) id<WMSendDemandViewDelegate> delegate;


@end
