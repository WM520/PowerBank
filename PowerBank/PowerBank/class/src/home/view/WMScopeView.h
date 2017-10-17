//
//  WMScopeView.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/25.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ScopeType {
    ScopeTypeHaveScan  = 0,
    ScopeTypeNoScan
} ScopeType;

@protocol WMScopeViewDelegate <NSObject>

- (void)commit:(NSString *)distance;
- (void)goToScan;

@end

@interface WMScopeView : UIView

@property (nonatomic, weak) id<WMScopeViewDelegate> delegate;
@property (nonatomic, assign) ScopeType type;

- (void)show;
- (void)hide;

@end
