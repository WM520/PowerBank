//
//  WMListHeadView.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/26.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WMListHeadViewDeleagte <NSObject>

- (void)comprehensiveSortAction;
- (void)moneySortSortAction;
- (void)distanceSortSortAction;
- (void)swithAddressModeAction;
- (void)settingsAction;


@end

@interface WMListHeadView : UIView


@property (nonatomic, weak) id<WMListHeadViewDeleagte> delegate;

@end
