//
//  WMListHeadView.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/26.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMListHeadView.h"
#import "UIButton+ImageTitleSpacing.h"

#define width (SCREEN_WIDTH - 43) /4
#define fontsize 14

@interface WMListHeadView ()

@property (nonatomic, strong) UIButton * comprehensiveSort;
@property (nonatomic, strong) UIButton * moneySort;
@property (nonatomic, strong) UIButton * distanceSort;
@property (nonatomic, strong) UILabel * selectLine;
@property (nonatomic, strong) UIButton * swithMode;
@property (nonatomic, strong) UILabel * firstPartLine;
@property (nonatomic, strong) UILabel * secondPartLine;
@property (nonatomic, strong) UILabel * thirdPartLine;
@property (nonatomic, strong) UILabel * fourPartLine;
@property (nonatomic, strong) UILabel * partLine;
@property (nonatomic, assign) NSInteger indexSelected;
@property (nonatomic, strong) UIButton * settingsButton;

@end

@implementation WMListHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self setLayout];
        [_comprehensiveSort layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                          imageTitleSpace:5];
        [_moneySort layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                            imageTitleSpace:5];
        [_distanceSort layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                            imageTitleSpace:5];
    }
    return self;
}

- (void)initUI
{
    _indexSelected = 0;
    _comprehensiveSort = [[UIButton alloc] init];
    _comprehensiveSort.selected = YES;
    [_comprehensiveSort setTitle:@"综合排序" forState:UIControlStateNormal];
    [_comprehensiveSort setImage:[UIImage imageNamed:@"topdown"] forState:UIControlStateNormal];
    _comprehensiveSort.titleLabel.font = Font(fontsize);
    [_comprehensiveSort addTarget:self action:@selector(comprehensiveSortAction) forControlEvents:UIControlEventTouchUpInside];
    [_comprehensiveSort setTitleColor:[UIColor colorWithHexString:@"#414141"] forState:UIControlStateNormal];
    [_comprehensiveSort setTitleColor:[UIColor colorWithHexString:@"#2e875a"] forState:UIControlStateSelected];
    [self addSubview:_comprehensiveSort];
    
    _selectLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 1, width, 1)];
    _selectLine.backgroundColor = [UIColor colorWithHexString:@"#2e875a"];
    [self addSubview:_selectLine];
    
    _moneySort = [[UIButton alloc] init];
    [_moneySort setTitle:@"奖金" forState:UIControlStateNormal];
    [_moneySort setImage:[UIImage imageNamed:@"topdown"] forState:UIControlStateNormal];
    _moneySort.titleLabel.font = Font(fontsize);
     [_moneySort addTarget:self action:@selector(moneySortSortAction) forControlEvents:UIControlEventTouchUpInside];
    [_moneySort setTitleColor:[UIColor colorWithHexString:@"#414141"] forState:UIControlStateNormal];
    [_moneySort setTitleColor:[UIColor colorWithHexString:@"#2e875a"] forState:UIControlStateSelected];
    [self addSubview:_moneySort];
    
    
    _secondPartLine = [[UILabel alloc] init];
    _secondPartLine.backgroundColor = RGB(229, 229, 229);
    [self addSubview:_secondPartLine];
    
    _firstPartLine = [[UILabel alloc] init];
    _firstPartLine.backgroundColor = RGB(229, 229, 229);
    [self addSubview:_firstPartLine];
    
    _fourPartLine = [[UILabel alloc] init];
    _fourPartLine.backgroundColor = RGB(229, 229, 229);
    [self addSubview:_fourPartLine];
    
    _distanceSort = [[UIButton alloc] init];
    [_distanceSort setTitle:@"距离" forState:UIControlStateNormal];
    _distanceSort.titleLabel.font = Font(fontsize);
     [_distanceSort addTarget:self action:@selector(distanceSortSortAction) forControlEvents:UIControlEventTouchUpInside];
    [_distanceSort setImage:[UIImage imageNamed:@"topdown"] forState:UIControlStateNormal];
    [_distanceSort setTitleColor:[UIColor colorWithHexString:@"#414141"] forState:UIControlStateNormal];
    [_distanceSort setTitleColor:[UIColor colorWithHexString:@"#2e875a"] forState:UIControlStateSelected];
    [self addSubview:_distanceSort];
    
    _thirdPartLine = [[UILabel alloc] init];
    _thirdPartLine.backgroundColor = RGB(229, 229, 229);
    [self addSubview:_thirdPartLine];
    
    _partLine = [[UILabel alloc] init];
    _partLine.backgroundColor = RGB(229, 229, 229);
    [self addSubview:_partLine];
    
    _swithMode = [[UIButton alloc] init];
    [_swithMode setImage:[UIImage imageNamed:@"mapMode"] forState:UIControlStateNormal];
     [_swithMode addTarget:self action:@selector(swithModeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_swithMode];
    
    _settingsButton = [[UIButton alloc] init];
    [_settingsButton setTitle:@"设置" forState:UIControlStateNormal];
    [_settingsButton addTarget:self action:@selector(settingsAction) forControlEvents:UIControlEventTouchUpInside];
    _settingsButton.titleLabel.font = Font(fontsize);
    [_settingsButton setTitleColor:[UIColor colorWithHexString:@"#414141"] forState:UIControlStateNormal];
    [_settingsButton setTitleColor:[UIColor colorWithHexString:@"#2e875a"] forState:UIControlStateSelected];
    [self addSubview:_settingsButton];
    
}


- (void)comprehensiveSortAction
{
    if (_indexSelected == 0) {
        return;
    }
//    [UIView animateWithDuration:0.2 animations:^{
//        _selectLine.frame = CGRectMake(0, self.height - 1, width, 1);
//    }];
    _indexSelected = 0;
    _comprehensiveSort.selected = YES;
    _moneySort.selected = NO;
    _distanceSort.selected = NO;
    _settingsButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(comprehensiveSortAction)]) {
        [self.delegate comprehensiveSortAction];
    }
}

- (void)moneySortSortAction
{
    if (_indexSelected == 1) {
        return;
    }
    
//    [UIView animateWithDuration:0.2 animations:^{
//        _selectLine.frame = CGRectMake(width, self.height - 1, width, 1);
//    }];
    
    _indexSelected = 1;
    _comprehensiveSort.selected = NO;
    _moneySort.selected = YES;
    _distanceSort.selected = NO;
    _settingsButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(moneySortSortAction)]) {
        [self.delegate moneySortSortAction];
    }
}

- (void)distanceSortSortAction
{
    if (_indexSelected == 2) {
        return;
    }
    
//    [UIView animateWithDuration:0.2 animations:^{
//        _selectLine.frame = CGRectMake(width * 2, self.height - 1, width, 1);
//    }];
    
    _indexSelected = 2;
    _comprehensiveSort.selected = NO;
    _moneySort.selected = NO;
    _distanceSort.selected = YES;
    _settingsButton.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(distanceSortSortAction)]) {
        [self.delegate distanceSortSortAction];
    }
}

- (void)swithModeAction
{
    
    if ([self.delegate respondsToSelector:@selector(swithAddressModeAction)]) {
        [self.delegate swithAddressModeAction];
    }
}

- (void)settingsAction
{
//    if (_indexSelected == 3) {
//        return;
//    }
    
    //    [UIView animateWithDuration:0.2 animations:^{
    //        _selectLine.frame = CGRectMake(width * 2, self.height - 1, width, 1);
    //    }];
    
    _indexSelected = 3;
    _comprehensiveSort.selected = NO;
    _moneySort.selected = NO;
    _distanceSort.selected = NO;
    _settingsButton.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(settingsAction)]) {
        [self.delegate settingsAction];
    }
}

- (void)setLayout
{
    _comprehensiveSort.sd_layout
    .leftEqualToView(self)
    .widthIs(width)
    .heightIs(self.height - 1 )
    .topEqualToView(self);
    
    _firstPartLine.sd_layout
    .leftSpaceToView(_comprehensiveSort, 0)
    .widthIs(1)
    .heightIs(self.height - 20)
    .bottomSpaceToView(self, 10);
    
    
 
    
    _moneySort.sd_layout
    .leftSpaceToView(_firstPartLine, 0)
    .topEqualToView(self)
    .heightIs(self.height - 1)
    .widthIs(width);
    
    _secondPartLine.sd_layout
    .leftSpaceToView(_moneySort, 0)
    .widthIs(1)
    .heightIs(self.height - 20)
    .bottomSpaceToView(self, 10);
    
//    _selectLine.sd_layout
//    .leftSpaceToView(self, 0)
//    .widthIs(width)
//    .heightIs(1)
//    .bottomEqualToView(self);
//    
    _distanceSort.sd_layout
    .leftSpaceToView(_secondPartLine, 0)
    .topEqualToView(self)
    .heightIs(self.height)
    .widthIs(width);
    
    _thirdPartLine.sd_layout
    .leftSpaceToView(_distanceSort, 0)
    .widthIs(1)
    .heightIs(self.height - 20)
    .bottomSpaceToView(self, 10);
    
    _settingsButton.sd_layout
    .leftSpaceToView(_thirdPartLine, 0)
    .topEqualToView(self)
    .heightIs(self.height - 1)
    .widthIs(width);
    
    _fourPartLine.sd_layout
    .leftSpaceToView(_settingsButton, 0)
    .widthIs(1)
    .heightIs(self.height - 20)
    .bottomSpaceToView(self, 10);
    
    _swithMode.sd_layout
    .leftSpaceToView(_fourPartLine, 0)
    .widthIs(40)
    .heightIs(self.height - 1)
    .topEqualToView(self);
    
    
    _partLine.sd_layout
    .leftSpaceToView(self, 0)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(1);
}

@end
