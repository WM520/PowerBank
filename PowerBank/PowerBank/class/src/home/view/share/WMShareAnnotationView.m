//
//  WMShareAnnotationView.m
//  PowerBank
//
//  Created by baiju on 2017/9/5.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMShareAnnotationView.h"
#import "WMShareModel.h"

@interface WMShareAnnotationView ()

@property (nonatomic, strong) UILabel * powerLabel;
@property (nonatomic, strong) UIImageView * backImage;

@end

@implementation WMShareAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
        [self setUpLayout];
    }
    return self;
}

- (void)initUI
{
    _powerLabel = [[UILabel alloc] init];
    _powerLabel.textColor = [UIColor colorWithHexString:@"#414141"];
    _powerLabel.font = Font(10);
    _powerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_powerLabel];
}

- (void)setModel:(WMShareModel *)model
{
    _model = model;
    _powerLabel.text = [NSString stringWithFormat:@"%@%%", model.quantity];
}

- (void)setUpLayout
{
    _powerLabel.sd_layout
    .topSpaceToView(self, 3)
    .widthIs(40)
    .heightIs(20)
    .centerXEqualToView(self);
}

@end
