//
//  WMAddressSelectViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/24.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol WMAddressSelectViewControllerDelegate <NSObject>

- (void)callback:(NSString *)addreeName;

@end

@interface WMAddressSelectViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * addressArray;

@property (strong, nonatomic) CLLocation * nowLocation;

@property (weak, nonatomic) id<WMAddressSelectViewControllerDelegate> delegate;

@end
