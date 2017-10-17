//
//  WMCustomRightAnnotionView.m
//  PowerBank
//
//  Created by baiju on 2017/8/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCustomRightAnnotionView.h"
#import "WMCustomWalletCalloutView.h"
#import "WMRequireModel.h"

#define kCalloutWidth       250.0
#define kCalloutHeight      100.0

@interface WMCustomRightAnnotionView ()
<WMCustomWalletCalloutViewDelegate>

@property (nonatomic, strong, readwrite) WMCustomWalletCalloutView *walletCalloutView;

@end

@implementation WMCustomRightAnnotionView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.walletCalloutView.delegate = self;
        
 
    }
    return self;
}


#pragma mark - WMCustomWalletCalloutViewDelegate
- (void)receiveOrder
{
    if ([self.delegate respondsToSelector:@selector(receiveOrderAction:)]) {
        [self.delegate receiveOrderAction:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return; 
    }
    
    if (selected)
    {
            if (self.walletCalloutView == nil)
            {
                self.walletCalloutView = [[WMCustomWalletCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
                self.walletCalloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                            -CGRectGetHeight(self.walletCalloutView.bounds) / 2.f + self.calloutOffset.y);
            }
            kWeakSelf(self);
            self.walletCalloutView.block = ^{
                if ([weakself.delegate respondsToSelector:@selector(receiveOrderAction:)]) {
                    [weakself.delegate receiveOrderAction:weakself.model];
                }
            };
            self.walletCalloutView.image = [UIImage imageNamed:@"location"];
            //        self.calloutView.title = self.annotation.title;
            self.walletCalloutView.title = _model.address;
            self.walletCalloutView.subtitle = _model.money;
            self.walletCalloutView.distanceImage = [UIImage imageNamed:@"orderMoney"];
            self.walletCalloutView.powerCount = @"12:30";
            self.walletCalloutView.powerCountImage = [UIImage imageNamed:@"orderTime"];
            self.walletCalloutView.moneyImage = [UIImage imageNamed:@"orderDistance"];
        
            MAMapPoint point1 = MAMapPointForCoordinate(_nowLocation.coordinate);
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_model.latitude floatValue], [_model.longitude floatValue]));
            //2.计算距离
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            self.walletCalloutView.moneyCount = [NSString stringWithFormat:@"%.0f米", distance];
            [self addSubview:self.walletCalloutView];
    }
    else
    {
        [self.walletCalloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        
        CGPoint tempoint = [self.walletCalloutView.navigationButton convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(self.walletCalloutView.navigationButton.bounds, tempoint))
            
        {
            view = self.walletCalloutView.navigationButton;
        }
        
    }
    
    return view;
    
}

- (void)setModel:(WMRequireModel *)model
{
    _model = model;
}

@end
