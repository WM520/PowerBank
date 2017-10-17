//
//  WMHaveNoOpenShareView.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/26.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMHaveNoOpenShareViewDelegate <NSObject>

- (void)swithToAddress;

@end


@interface WMHaveNoOpenShareView : UIView

@property (nonatomic, weak) id<WMHaveNoOpenShareViewDelegate> delegate;

@end
