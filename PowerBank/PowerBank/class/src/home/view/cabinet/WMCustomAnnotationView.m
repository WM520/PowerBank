//
//  WMCustomAnnotationView.m
//  PowerBank
//
//  Created by foreverlove on 2017/8/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCustomAnnotationView.h"
#import "WMCabinetModel.h"
#define kCalloutWidth       250.0
#define kCalloutHeight      100.0


@interface WMCustomAnnotationView ()

@property (nonatomic, strong, readwrite) WMCustomCalloutView *calloutView;

@end

@implementation WMCustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[WMCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.image = [UIImage imageNamed:@"location"];
//        self.calloutView.title = @"南京市浦口区 弘扬广场B1";
//        self.calloutView.subtitle = @"700m";
        self.calloutView.distanceImage = [UIImage imageNamed:@"orderDistance"];
//        self.calloutView.powerCount = @"60个";
        self.calloutView.powerCountImage = [UIImage imageNamed:@"powerCount"];
        
        self.calloutView.title = _model.address;
        self.calloutView.powerCount = [NSString stringWithFormat:@"%@个", _model.deviceNum];
        
        MAMapPoint point1 = MAMapPointForCoordinate(_nowLocation.coordinate);
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_model.latitude floatValue], [_model.longitude floatValue]));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        self.calloutView.subtitle = [NSString stringWithFormat:@"%.0f米", distance];
        self.calloutView.startCLLocation = _nowLocation.coordinate;
        self.calloutView.endCLLocation = CLLocationCoordinate2DMake([_model.latitude floatValue], [_model.longitude floatValue]);
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        
        CGPoint tempoint = [self.calloutView.navigationButton convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(self.calloutView.navigationButton.bounds, tempoint))
            
        {
            
            view = self.calloutView.navigationButton;
            
        }
        
    }
    
    return view;
    
}

- (void)setModel:(WMCabinetModel *)model
{
    _model = model;
    self.calloutView.title = model.address;
    self.calloutView.powerCount = [NSString stringWithFormat:@"%@个", model.deviceNum];
    
    MAMapPoint point1 = MAMapPointForCoordinate(_nowLocation.coordinate);
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    self.calloutView.subtitle = [NSString stringWithFormat:@"%.0f", distance];
}

@end
