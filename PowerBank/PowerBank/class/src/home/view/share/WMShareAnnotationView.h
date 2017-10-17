//
//  WMShareAnnotationView.h
//  PowerBank
//
//  Created by baiju on 2017/9/5.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class WMShareModel;

/** 共享充电 */
@interface WMShareAnnotationView : MAAnnotationView

@property (nonatomic, strong) WMShareModel * model;

@end
