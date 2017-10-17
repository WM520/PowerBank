//
//  WMCustomCalloutView.m
//  PowerBank
//
//  Created by foreverlove on 2017/8/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCustomCalloutView.h"
#import "WMNavViewController.h"
#import "WMNavWalkViewController.h"
#define kArrorHeight        10
#define kPortraitMargin     5
#define kPortraitWidth      20
#define kPortraitHeight     20

#define kTitleWidth         150
#define kTitleHeight        50


@interface WMCustomCalloutView ()

@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *distanceImageView; // 距离
@property (nonatomic, strong) UILabel *partLine; // 分割线
@property (nonatomic, strong) UILabel * powerCountLabel;
@property (nonatomic, strong) UIImageView *powerCountImageView;

@end

@implementation WMCustomCalloutView


- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
//    self.layer.shadowColor = [[UIColor whiteColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 10.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // 添加图片，即商户图
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin , kPortraitMargin * 2 + 3, kPortraitWidth, kPortraitHeight)];
    self.portraitView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.portraitView];
    
    // 添加标题，即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#414141"];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"titletitletitletitle";
    [self addSubview:self.titleLabel];
    
    // 添加副标题，即商户地址
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin * 3 + kTitleHeight, kTitleWidth, kTitleHeight /2)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    self.subtitleLabel.text = @"subtitleLabelsubtitleLabelsubtitleLabel";
    [self addSubview:self.subtitleLabel];
    
    self.partLine = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin * 2 + kTitleHeight - 1, kPortraitMargin * 2 + kPortraitWidth + kTitleWidth, 1)];
    [self.partLine setBackgroundColor:RGBA(234, 234, 234, 1)];
    [self addSubview:self.partLine];
    
    self.distanceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin * 3 + kTitleHeight + 3, kPortraitWidth, kPortraitHeight)];
    self.distanceImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.distanceImageView];
    
    self.powerCountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin * 3 + kPortraitWidth + 60, kPortraitMargin * 3 + kTitleHeight + 3, kPortraitWidth, kPortraitHeight)];
    self.powerCountImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.powerCountImageView];
    
    
    self.powerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 4 + kPortraitWidth + 80, kPortraitMargin * 3 + kTitleHeight, kTitleWidth, kTitleHeight /2)];
    self.powerCountLabel.font = [UIFont systemFontOfSize:12];
    self.powerCountLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.powerCountLabel];
    
    self.navigationButton = [[UIButton alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth + kTitleWidth, 0, self.width - kPortraitMargin * 2 - kPortraitWidth - kTitleWidth, kPortraitMargin * 2 + kTitleHeight)];
//    self.navigationButton.backgroundColor = [UIColor redColor];
    self.navigationButton.layer.borderWidth = 1;
    self.navigationButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.navigationButton addTarget:self action:@selector(navChick) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationButton setBackgroundImage:[UIImage imageNamed:@"white_nav"] forState:UIControlStateNormal];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - kPortraitMargin * 2 - kPortraitWidth - kTitleWidth)/3, 0, (self.width - kPortraitMargin * 2 - kPortraitWidth - kTitleWidth)/2.5, (kPortraitMargin * 2 + kTitleHeight)/2)];
    [image setImage:[UIImage imageNamed:@"white_nav"]];
    [self.navigationButton addSubview:image];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, (kPortraitMargin * 2 + kTitleHeight)/2, self.width - kPortraitMargin * 2 - kPortraitWidth - kTitleWidth, (kPortraitMargin * 2 + kTitleHeight)/2)];
    lable.backgroundColor = [UIColor clearColor];
    lable.text = @"导航";
    lable.font = [UIFont systemFontOfSize:13];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.navigationButton addSubview:lable];
    
    [self addSubview:self.navigationButton];
    
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)setImage:(UIImage *)image
{
    self.portraitView.image = image;
}

- (void)setDistanceImage:(UIImage *)distanceImage
{
    self.distanceImageView.image = distanceImage;
}

- (void)setPowerCount:(NSString *)powerCount
{
    self.powerCountLabel.text = powerCount;
}

- (void)setPowerCountImage:(UIImage *)powerCountImage
{
    self.powerCountImageView.image = powerCountImage;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)navChick
{
    NSLog(@"navChicknavChicknavChick");
    UIViewController * vc  = [self topViewController];
    
    WMNavWalkViewController * nav = [[WMNavWalkViewController alloc] init];
    CLLocationCoordinate2D coor ;
    coor.latitude = 32.159423;
    coor.longitude = 118.697407;
    CLLocationCoordinate2D currentUL ;
    currentUL.latitude = 32.157423;
    currentUL.longitude = 118.696407;
    
    nav.currentUL = currentUL;
    nav.coor = coor;
    
//    [vc.navigationController pushViewController:nav animated:YES];
    [vc presentViewController:nav animated:YES completion:nil];
    
}

@end
